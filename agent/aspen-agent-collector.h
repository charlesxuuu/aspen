#ifndef ASPEN_AGENT_COLLECTOR_H_
#define ASPEN_AGENT_COLLECTOR_H_
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <algorithm>
#include <iterator>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>

namespace aspen {
namespace agent {

class Collector {
public:
	Collector();
	~Collector();
	void Collect(std::string, std::string, int);
};

} // namespace agent
} // namespace aspen

#endif // ASPEN_AGENT_COLLECTOR_H_