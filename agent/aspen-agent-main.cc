#include "aspen-agent.h"

using namespace std;
using namespace aspen::agent;

int main(int argc, char **argv) {
	PerfCollector* perf_collector = new PerfCollector();

	perf_collector->Collect();

	delete perf_collector;
	return 0;
}