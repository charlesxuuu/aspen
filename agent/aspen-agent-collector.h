
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

class Collector {
private:
	bool exit_signal_;
	timespec interval_;
	std::string output_path_;
	std::ifstream istream_;
	std::ofstream ostream_;
	std::map<std::string, std::string> target_list_;
	std::map<std::string, std::string> pipe_list_;
	std::map<std::string, std::string> environment_list_;
public:
	explicit Collector(const int &interval) {
		exit_signal_ = false;
		output_path_ = "";
		target_list_.clear();
		pipe_list_.clear();
		SetInterval(interval);
	};
	~Collector();
	void SetInterval(const int &interval);
	void SetOutputPath(const std::string &target, const std::string &path);
	void AddTarget(const std::string &target, const std::string &path,
								 const std::string &arguments);
	void BindPipe(const std::string &target, const std::string &pipe);
	void SetEnvironment(const std::string &target, const std::string &environment);
	void ListTarget();
	void CollectInformation();
	void StopCollection();
//	void Collect(std::string, std::string, int);
};

} // namespace agent
} // namespace aspen

#endif // ASPEN_AGENT_COLLECTOR_H_