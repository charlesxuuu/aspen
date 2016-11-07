#include "aspen-agent-collector.h"

using namespace std;
using namespace aspen::agent;

Collector::Collector() {}
Collector::~Collector() {}

void Collector::Collect(string bw_pipe, string rapl_pipe, int interval) {
	ifstream bw_input, rapl_input;
	string bw_info, rapl_info;

	while(true) {
		bw_input.open(bw_pipe.c_str(),ifstream::in);
		rapl_input.open(rapl_pipe.c_str(),ifstream::in);
		if (getline(bw_input, bw_info)) {
			cout << bw_info << endl;
			bw_input.close();
		}

		if (getline(rapl_input, rapl_info)) {
			cout << rapl_info << endl;
			rapl_input.close();
		}
		usleep(interval/2);
	}

	bw_input.close();
	rapl_input.close();
};

