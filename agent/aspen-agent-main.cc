#include "aspen-agent.h"

using namespace std;
using namespace aspen::agent;

void exitHandler(int signum) {
	system(("pkill " + kRaplSrc + "; pkill " + kBwSrc).c_str());
	exit(signum);
};

void startReaders() {
	string bw_reader = kRteDir + kNetDir + kBwSrc;
	string rapl_reader = kRteDir + kPowerDir + kRaplSrc;

	system((bw_reader + " -t " + kSampleIntvlStr + " -i " + kNicName + " &").c_str());
	system(("cd " + kRteDir + kPowerDir + ";" + rapl_reader + " -t " + kSampleIntvlStr + " &").c_str());
	cout << "==Aspen Agent==> Executed readers." <<endl;
};

int main(int argc, char **argv) {
	signal(SIGINT, exitHandler);

	startReaders();
	usleep(kSampleIntvl*2);

	Collector* col = new Collector();
	col->Collect(kBwPipe, kRaplPipe, kSampleIntvl);
	delete col;

	return 0;
}

