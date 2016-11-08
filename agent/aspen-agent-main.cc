#include "aspen-agent.h"

using namespace std;
using namespace aspen::agent;

Collector* collector;

void ExitHandler(int signum) {
	cerr << " Captured Interrupt Signal\n";
	if (collector) {
		collector->StopCollection();
		delete collector;
		collector = nullptr;
	}
	exit(signum);
};

int main(int argc, char **argv) {
	signal(SIGINT, ExitHandler);

	try {
		collector = new Collector(0);
	} catch (const bad_alloc& e) {
		cerr << "== Aspen Agent ==> Reached memory limitation" << endl;
		ExitHandler(SIGQUIT);
	}

	collector->SetInterval(kSampleIntvlInt);
  collector->SetOutputPath(kOutputTarget, kOutputDirectory);

	collector->AddTarget(kBwSrc,
											 kParentDirectory + kNetDir,
											 " -t " + kSampleIntvlStr + " -i " + kInterfaceName);
	collector->BindPipe(kBwSrc, kBwPipe);
	collector->AddTarget(kRaplSrc,
											 kParentDirectory + kPowerDir,
											 " -t " + kSampleIntvlStr);
	collector->BindPipe(kRaplSrc, kRaplPipe);
	collector->SetEnvironment(kRaplSrc, kParentDirectory + kPowerDir);

	collector->CollectInformation();

	if (collector) {
		delete collector;
		collector = nullptr;
	}

	return 0;
}

