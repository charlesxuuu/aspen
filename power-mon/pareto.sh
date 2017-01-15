#!/bin/bash
#
# Perform pareto frontier probing for b/w-frequency and latency-frequency,
# with the assumptions: 1. All CPUs have identical frequency settings (e.g., range) 2. ...

IPERF_SERVER_IP="192.168.1.34"
IPERF_SERVER_USER="silvery"
IPERF_SERVER_KEY="../etc/id_rsa_iperf"
IPERF_CLIENT_IP="192.168.1.34"
IPERF_CLIENT_USER="silvery"
IPERF_CLIENT_KEY="../etc/id_rsa_iperf"
IPERF_MEASURE_TIME=10
BOX_IP="192.168.1.4"
BOX_USER="dpdk-ovs0"
BOX_KEY="../etc/id_rsa_box"
RUN_COUNT=1
BI_FLAG=0

iperf_tmp_file=".iperf.tmp"
iperf_client_cmd_prefix="ssh -i $IPERF_CLIENT_KEY -l $IPERF_CLIENT_USER $IPERF_CLIENT_IP"
iperf_client_cmd="$iperf_client_cmd_prefix iperf -c $BOX_IP -i 0.5 > $iperf_tmp_file"
iperf_client_cmd_bi="$iperf_client_cmd_prefix iperf -c $BOX_IP -i 0.5 -r -p 8887 > $iperf_tmp_file"

rapl_bw_cmd="./rapl-bw"

pmd_core=0

declare -A frontier_bw
declare -A frontier_power

# Obtain the Pareto frontier of bandwidth-frequency
probe_bw() { 
  freq_range=$(sudo cpufreq-info -c 0 | grep -G "avail.*steps" | grep -o "[0-9]\.[0-9]\{2\}")
  freq_foo="1.60 3.40"

  for freq in $freq_range; do
    set_cpu_freq $pmd_core $freq

    for ((i=1;i<=RUN_COUNT;i++)); do
      echo "-> Running test on "$freq" , Run "$i

      # Format: Total Core Graphics Mem_control_LLC (DRAM)
      local rapl_result=($(eval "$rapl_bw_cmd -i \"$iperf_client_cmd\""))

      # Format: throughput_1 throughput_2 ...
      local bw_result=$(cat $iperf_tmp_file | grep "0.0-10.0 sec" | grep -o "[0-9]* Mbits/sec" | cut -d' ' -f1)
      rm $iperf_tmp_file

      if [ $BI_FLAG == 1 ]; then
        local tx_rate=${bw_result[0]}
        local rx_rate=${bw_result[1]}

        frontier_bw["tx_"$freq]=$tx_rate
        frontier_bw["rx_"$freq]=$rx_rate
        continue
      fi
      
      local key=$freq
      frontier_bw[key]="${bw_result[0]} ${rapl_result[0]} ${rapl_result[1]}"
      echo ${frontier_bw[key]}
    done
  done
}

set_cpu_freq() {
  sudo cpufreq-set -c $1 -f $2"GHz"
  echo "-> "CPU $1: $(sudo cpufreq-info -c $1 | grep "current CPU frequency")
}

init() {
  sudo modprobe msr
  sudo modprobe cpufreq_userspace
  sudo cpupower frequency-set --governor userspace
}

install_req() {
  sudo apt-get install linux-tools-common -y
  sudo apt-get install linux-tools-$(uname -r) -y
}

# Syntax sugar for existence checking in associative array
exists(){
  if [ "$2" != in ]; then
    echo "-> Usage: exists {key} in {array}"
    return
  fi   
  eval '[ ${'$3'[$1]+foo} ]'  
}

OPTS=`getopt -o ribs:p:c:fh --long core,iperfserver:,count:,iperfclient:,freq:,help -n 'pareto.sh' -- "$@"`
eval set -- "$OPTS"

while true; do
    case "$1" in
      -r)  
        install_req
        shift
        ;;
      -i)  
        init
        shift
        ;;
      -b)
        probe_bw
        shift
        ;;
      -p|--count)
        RUN_COUNT=$2
        shift 2
        ;;
      -c|--core)  
        pmd_core=$2
        shift 2
        ;;
      -f|--freq)  
        FREQ_LIST=$2
        shift 2
        ;;
      --iperfserver)  
        IPERF_SERVER_IP=$2
        shift 2
        ;;
      --iperfclient)  
        IPERF_CLIENT_IP=$2
        shift 2
        ;;
      -h|--help)  
        shift
        ;;
      --) shift ; break ;;
      *) echo "Parsing Error!" ; exit 1 ;;
    esac
done

