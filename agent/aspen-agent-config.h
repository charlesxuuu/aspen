#ifndef ASPEN_AGENT_CONFIG_H
#define ASPEN_AGENT_CONFIG_H

const std::string kNetDir="net-mon/";
const std::string kPowerDir="power-mon/";

const std::string kBwSrc="bw-pipe.sh";
const std::string kRaplSrc="rapl-pipe.sh";
const std::string kInterfaceName="eno1";
const std::string kSampleIntvlStr="1";

const std::string kParentDirectory = "../";

const std::string kOutputDirectory = "../agent/";
const std::string kOutputTarget = "output.txt";
const int         kSampleIntvlInt=atoi(kSampleIntvlStr.c_str());
const std::string kBwPipe="/tmp/bw_pipe";
const std::string kRaplPipe="/tmp/rapl_pipe";


#endif
