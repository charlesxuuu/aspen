#ifndef ASPEN_AGENT_CONFIG_H
#define ASPEN_AGENT_CONFIG_H

const std::string kRteDir="..";
const std::string kNetDir="/net-mon/";
const std::string kBwSrc="bw-pipe.sh";
const std::string kPowerDir="/power-mon/";
const std::string kRaplSrc="rapl-pipe.sh";
const std::string kSampleIntvlStr="1";
const int         kSampleIntvl=atoi(kSampleIntvlStr.c_str());
const std::string kNicName="eno1";
const std::string kBwPipe="/tmp/bw_pipe";
const std::string kRaplPipe="/tmp/rapl_pipe";

#endif