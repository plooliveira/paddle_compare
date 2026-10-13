class ApiConfig {
  const ApiConfig({
    this.minLatency = const Duration(milliseconds: 300),
    this.maxLatency = const Duration(milliseconds: 800),
    this.failureRate = 0.15,
  }) : assert(failureRate >= 0 && failureRate <= 1);

  final Duration minLatency;

  /// Upper bound of the simulated latency. Treated as [minLatency] if lower.
  final Duration maxLatency;

  final double failureRate;
}
