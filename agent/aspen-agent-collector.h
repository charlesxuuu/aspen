
//////////////////////////////////////////////////////////////////////////////
//
// aspen-agent-collector.h
//
// Collector Class Header
//
// Project          : aspen-agent
// Author           : Danyang Song (Arthur) Handle: GreysTone
// Contact          : arthur.r.song@gmail.com
//
// Last Modified on 2016-11-07 by GreysTone, [Contact]
// Modified         : ...
//
//////////////////////////////////////////////////////////////////////////////

#ifndef ASPEN_AGENT_COLLECTOR_H_
#define ASPEN_AGENT_COLLECTOR_H_

#include <map>
#include <utility>
#include <iostream>
#include <fstream>
#include <sys/stat.h>

#include <sstream>
#include <algorithm>
#include <iterator>
#include <sys/types.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>

namespace aspen {
namespace agent {

#define EXEC 0
#define PIPE 1
#define ENVI 2
#define DIR_FILE 0x1
#define REG_FILE 0x2
#define XSR_FILE 0x4

class Collector {
private:
  bool exit_signal_;
  timespec interval_;
  std::string output_path_;
  std::ifstream istream_;
  std::ofstream ostream_;
  std::map<std::string, std::map<int, std::string>> target_list_;
  int IsValidFile(const std::string &file, const int &mode);
public:
  explicit Collector(const int &interval, const std::string &path, 
      const std::string &outlet);
  ~Collector();
  void AddTarget(const std::string &target, const std::string &pipe, 
      const std::string &path, const std::string &arguments, 
      const std::string &environment);
  void CollectInformation();
  void StopCollection();
  void DebugInfo(const std::string &action, const std::string &target, const int &ret);
};

} // namespace agent
} // namespace aspen

#endif // ASPEN_AGENT_COLLECTOR_H_
