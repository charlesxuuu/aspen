#ifndef ASPEN_AGENT_COLLECTOR_H_
#define ASPEN_AGENT_COLLECTOR_H_
#include <iostream>
#include <string>
#include <sstream>
#include <algorithm>
#include <iterator>

namespace aspen {
namespace agent {

class Collector {
public:
	Collector() {};
	virtual void Collect(){};
};

class PerfCollector: public Collector {
public:
	PerfCollector();
	~PerfCollector();
	void Collect();
};

class PowerCollector: public Collector {
public:
	PowerCollector();
	~PowerCollector();
	void Collect();	
};

} // namespace agent
} // namespace aspen

#endif // ASPEN_AGENT_COLLECTOR_H_