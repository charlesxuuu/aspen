#include "aspen-agent-collector.h"

using namespace std;
using namespace aspen::agent;

PerfCollector::PerfCollector() {}
PerfCollector::~PerfCollector() {}

PowerCollector::PowerCollector() {}
PowerCollector::~PowerCollector() {}

void PerfCollector::Collect() {
	string lineInput;

	while (cin >> lineInput) {
		istringstream ss(lineInput);
		string token;

		while(getline(ss, token, ',')) {
			cout << token << endl;
		}
	}
};

void PowerCollector::Collect() {
	string lineInput;

	while (cin >> lineInput) {
		istringstream ss(lineInput);
		string token;

		while(getline(ss, token, ',')) {
			cout << token << endl;
		}
	}
}

