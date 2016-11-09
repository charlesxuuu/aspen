
//////////////////////////////////////////////////////////////////////////////
//
// aspen-agent-collector.cc
//
// Collector Class Implementation
//
// Project          : aspen-agent
// Author           : Danyang Song (Arthur) Handle: GreysTone
// Contact          : arthur.r.song@gmail.com
//
// Last Modified on 2016-11-07 by GreysTone, [Contact]
// Modified         : ...
//
//////////////////////////////////////////////////////////////////////////////

#include "aspen-agent-collector.h"

using namespace std;
using namespace aspen::agent;

Collector::Collector(const int &interval, const std::string &path="",
    const std::string &outlet="") {
  exit_signal_ = false;
  interval_.tv_sec = interval;
  interval_.tv_nsec = 0;
  if (path != "" && IsValidFile(path, DIR_FILE)) {
    output_path_ = path + outlet;
    DebugInfo("Set output path", output_path_, 0);
  } else output_path_ = "";
  target_list_.clear();
  DebugInfo("Initialied collector with interval", to_string(interval), 0);
}

Collector::~Collector() {
	for (auto iter : target_list_) {
	  string proc_name = iter.first;
	  if (proc_name.size() > 15) proc_name = proc_name.substr(0, 15);
	  int ret = system(("pkill " + proc_name).c_str());
    DebugInfo("Killed target", proc_name, ret);
	}
  istream_.close();
  ostream_.close();
}

int Collector::IsValidFile(const std::string &file, const int &mode) {
  if ((mode & DIR_FILE) && (mode & REG_FILE)) return -1;
  struct stat buf;
  int ret = 0;
  if (lstat(file.c_str(), &buf) < 0) return -1;
  else {
    if ((mode & DIR_FILE) && S_ISDIR(buf.st_mode)) ret |= DIR_FILE;
    if ((mode & REG_FILE) && S_ISREG(buf.st_mode)) ret |= REG_FILE;
    if ((mode & XSR_FILE) && (access(file.c_str(), X_OK) > -1)) ret |= XSR_FILE;
  }
  return ret;
}

void Collector::AddTarget(const std::string &target, const std::string &pipe,
    const std::string &path="", const std::string &arguments="",
    const std::string &environment="") {
  const std::string abs_target(path + target);
  const int valid_target = REG_FILE | XSR_FILE;
  if (valid_target != IsValidFile(abs_target, valid_target)) {
    DebugInfo("Invalid file", target, -1);
    return ;
  }
  if (environment != "") {
    if (!IsValidFile(environment, DIR_FILE)) {
      DebugInfo("Invalid environment", environment, -1);
      return ;
    }
  }
  map<int, string> setting;
  setting.insert(pair<int, string>(EXEC, abs_target + arguments));
  setting.insert(pair<int, string>(PIPE, pipe));
  setting.insert(pair<int, string>(ENVI, environment));
  auto combined_target = pair<string, map<int, string>>(target, setting);
  target_list_.insert(combined_target);
  DebugInfo("Added target", target, 0);
  return ;
}

void Collector::CollectInformation() {
	if (0 == interval_.tv_sec && 0 == interval_.tv_nsec) {
    DebugInfo("Collector has interval", "0", -1);
	  return ;
	}

  for (auto iter : target_list_) {
    string environment = iter.second.find(ENVI)->second;
    if ("" != environment) {
      int ret = chdir(environment.c_str());
      DebugInfo("Applied environment", environment, ret);
    }
    string execution = iter.second.find(EXEC)->second;
    int ret = system((execution + " &").c_str());
    DebugInfo("Background task", iter.first, ret);
  }

	timespec initial_time = interval_;
	initial_time.tv_sec = interval_.tv_sec * target_list_.size();
	nanosleep(&initial_time, NULL);

	string raw_data;
  ostream_.open(output_path_, ios::out | ios::app);
	while(!exit_signal_) {
	  for(auto iter : target_list_) {
      const string pipe_file(iter.second.find(PIPE)->second);
	    istream_.open(pipe_file.c_str(), ios::in);
	    if (istream_.good() && getline(istream_, raw_data)) {
	      if("" == output_path_)
	        cout << raw_data << endl;
	      else {
	        if(ostream_.good()) ostream_ << raw_data << endl;
          else DebugInfo("Output failed", "", -1);
	      }
	      istream_.close();
	    } else break;
	  }
	  nanosleep(&interval_, NULL);
	}
  DebugInfo("Failure on reading pipes", "", -1);
	istream_.close();
	ostream_.close();
	return ;
}

void Collector::StopCollection() {
	exit_signal_ = true;
}

void Collector::DebugInfo(const std::string &action, const std::string &target, 
    const int &ret) {
#ifdef DEBUG
  cout << "==Aspen Agent==> " << action << ": " 
    << target << " > " << ((ret < 0)?"failed":"succeed") << endl;
#endif
}
