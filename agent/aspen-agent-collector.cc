
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

Collector::~Collector() {
	for (auto iter : pipe_list_) {
		string pname = iter.first;
		if (pname.size() > 15) pname = pname.substr(0, 15);
		int ret = system(("pkill " + pname).c_str());
		cout << "==Aspen Agent==> Kill target: " << pname << ":" << ret << endl;
	}
  istream_.close();
  ostream_.close();
}

void Collector::SetInterval(const int &interval) {
	interval_.tv_sec = interval;
	interval_.tv_nsec = 0;
	cout << "==Aspen Agent==> Set interval (sec.): " << interval_.tv_sec << endl;
}

void Collector::SetOutputPath(const std::string &target, const std::string &path) {
	struct stat buf;

	if (lstat(path.c_str(), &buf) < 0)
		cerr << "==Aspen Agent==> Path \"" << path << "\" does not exist\n";
	else {
		if (S_ISDIR(buf.st_mode)) {
			output_path_ = path + target;
			cout << "==Aspen Agent==> Set output path: " << output_path_ << endl;
		} else cerr << "==Aspen Agent==> \"" << path << "\" is not a directory\n";
	}
}

void Collector::AddTarget(const std::string &target, const std::string &path, const std::string &arguments = "") {
	struct stat buf;

	const std::string absolute_target(path+target);
	if (lstat(absolute_target.c_str(), &buf) < 0)
		cerr << "==Aspen Agent==> File " << target << " does not exist\n";
	else {
		if (S_ISREG(buf.st_mode)) {
			target_list_.insert(pair<string, string>(target, path + target + arguments));
			cout << "==Aspen Agent==> Add target: " << target << endl;
		} else cerr << "==Aspen Agent==> File " << target << " is not a valid file\n";
	}
}

void Collector::BindPipe(const std::string &target, const std::string &pipe) {
	auto check = target_list_.find(target);
	if (target_list_.end() != check) {
		pipe_list_.insert(pair<string, string>(target, pipe));
		cout << "==Aspen Agent==> Bind target (" << target << ") with pipe: " << pipe << endl;
	} else cerr << "==Aspen Agent==> Cannot find " << target << "\n";
}

void Collector::SetEnvironment(const std::string &target, const std::string &environment) {
	auto check = target_list_.find(target);
	if (target_list_.end() != check) {
		environment_list_.insert(pair<string, string>(target, environment));
		cout << "==Aspen Agent==> Set target (" << target << ") with environment: " << environment << endl;
	} else cerr << "==Aspen Agent==> Cannot find " << target << "\n";
}

void Collector::ListTarget() {
	cout << "Target List:" << endl;
	for(auto iter : target_list_) {
		auto bound_pipe = pipe_list_.find(iter.first);
		if (pipe_list_.end() != bound_pipe) cout << iter.first << ":" << bound_pipe->second << endl;
		else cout << iter.first << ":" << "no access" << endl;
	}
}

void Collector::CollectInformation() {
	if (0 == interval_.tv_sec && 0 == interval_.tv_nsec) {
		cerr << "==Aspen Agent==> Collector has interval 0\n";
		return ;
	}

	for(auto iter : pipe_list_) {
		auto target = target_list_.find(iter.first);
		if (target_list_.end() != target) {
			auto environment = environment_list_.find(iter.first);
			if (environment_list_.end() != environment) {
				int ret = chdir(environment->second.c_str());
				cout << "==Aspen Agent==> Applied environment: " << environment->second << ":" << ret << endl;
			}
			int ret = system((target->second + " &").c_str());
#ifdef DEBUG
			system("pwd");
			cout << target->second << endl;
#endif
			cout << "==Aspen Agent==> Forked target: " << iter.first << ":" << ret << endl;
		} else {
			cerr << "==Aspen Agent==> Unexpected target: " << iter.first << endl;
		}
	}
	timespec initial_time = interval_;
	initial_time.tv_sec = interval_.tv_sec * pipe_list_.size();
	nanosleep(&initial_time, NULL);

	string raw_data;
  ostream_.open(output_path_, ios::out | ios::app);
	while(!exit_signal_) {
		for(auto iter : pipe_list_) {
			istream_.open(iter.second.c_str(), ios::in);
#ifdef DEBUG
			cout << "==Aspen Agent==> [DEBUG] Access:" << iter.second << " || ";
			cout << "istream.good(): " << istream_.good() << endl;
#endif
			if (istream_.good() && getline(istream_, raw_data)) {
				if("" == output_path_)
					cout << raw_data << endl;
				else {
#ifdef DEBUG
			cout << "==Aspen Agent==> [DEBUG] ostream.good(): " << ostream_.good() << endl;
#endif
					if(ostream_.good()) ostream_ << raw_data << endl;
					else cerr << "==Aspen Agent==> Output failed\n";
				}
				istream_.close();
			} else break;
		}
		nanosleep(&interval_, NULL);
	}
	cerr << "==Aspen Agent==> Failure on reading pipes\n";
	istream_.close();
	ostream_.close();
	return ;
}

void Collector::StopCollection() {
	exit_signal_ = true;
}
