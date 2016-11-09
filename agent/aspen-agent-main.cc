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
}

int main(int argc, char **argv) {
  signal(SIGINT, ExitHandler);

  try {
    collector = new Collector(kSampleIntvlInt, kOutputDirectory, kOutputTarget);
  } catch (const bad_alloc& e) {
    cerr << "==Aspen Agent==> Reached memory limitation" << endl;
    ExitHandler(SIGQUIT);
  }

  collector->AddTarget(kBwSrc,
      kBwPipe,
      kParentDirectory + kNetDir,
      " -t " + kSampleIntvlStr + " -i " + kInterfaceName,
      "");

  collector->AddTarget(kRaplSrc,
      kRaplPipe,
      kParentDirectory + kPowerDir,
      " -t " + kSampleIntvlStr,
      kParentDirectory + kPowerDir);

  collector->CollectInformation();

  if (collector) {
    delete collector;
    collector = nullptr;
  }

  return 0;
}

