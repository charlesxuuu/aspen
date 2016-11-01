Power agent
==
- Collector: a wrapper for performance monitoring agent (sflow) and power monitoring agent. It uses pipe for each collector as to communicate with the original agent modules.
- Pareto-prober: probes the Pareto frontier given dimensions (e.g., power and throughput)
- Main: the coordinator for the modules.
- Power-tuner: in charge of the access to power interface (RAPL)