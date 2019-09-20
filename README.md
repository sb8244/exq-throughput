# Exq.Enqueuer Throughput Benchmarks

This is a benchmark of `Exq.Enqueuer` throughput. The following scenarios are benchmarked:

* Default - The Enqueuer that Exq ships with out of the box.
* Named Pool - A pool of processes is created with names in `[0, num_schedulers)`. A random process is selected based on this range.
* Poolboy Pool - A pool of processes is created using Poolboy.

The pool sizes are always set to the num schedulers. I noticed some timeouts when it was set lower, but I didn't investigate these too
heavily.

## The Test

Benchee is used to benchmark each scenario. Benchee is ran with various parallelism amounts to simulate how you might run Exq in production.
For example, if you are enqueueing from a web tier, then your parallelism will be quite high. If you're enqueueing from a single process, you
would have no parallelism.

The redis queues are cleaned up before/after each test.

The Exq work processor is not running. This test is purely around speed of enqueueing.

These tests are all running locally. Redis is not running through any type of virtualization. The performance would be significantly different
depending on how redis is setup and the network speed between your application and redis.

## The Results

### Parallelism 1

There isn't a ton of difference across these.

```
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
Number of Available Cores: 12
Available memory: 32 GB
Elixir 1.9.0
Erlang 22.0.4

Benchmark suite executing with the following configuration:
warmup: 1 s
time: 4 s
memory time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 15 s

Benchmarking default enqueuer...
Benchmarking named enqueuer...
Benchmarking poolboy enqueuer...

Name                       ips        average  deviation         median         99th %
named enqueuer          9.05 K      110.52 μs    ±42.61%          99 μs         210 μs
poolboy enqueuer        8.73 K      114.51 μs    ±57.05%         102 μs         240 μs
default enqueuer        8.30 K      120.54 μs    ±51.87%         110 μs         249 μs

Comparison:
named enqueuer          9.05 K
poolboy enqueuer        8.73 K - 1.04x slower +3.99 μs
default enqueuer        8.30 K - 1.09x slower +10.03 μs
```

### Parallelism 6

The difference really starts to come through with client parallelism.

```
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
Number of Available Cores: 12
Available memory: 32 GB
Elixir 1.9.0
Erlang 22.0.4

Benchmark suite executing with the following configuration:
warmup: 1 s
time: 4 s
memory time: 0 ns
parallel: 6
inputs: none specified
Estimated total run time: 15 s

Benchmarking default enqueuer...
Benchmarking named enqueuer...
Benchmarking poolboy enqueuer...

Name                       ips        average  deviation         median         99th %
poolboy enqueuer        4.40 K      227.14 μs    ±39.15%         216 μs         417 μs
named enqueuer          3.95 K      253.41 μs    ±45.96%         227 μs         605 μs
default enqueuer        1.05 K      954.02 μs    ±21.91%         951 μs     1446.13 μs

Comparison:
poolboy enqueuer        4.40 K
named enqueuer          3.95 K - 1.12x slower +26.27 μs
default enqueuer        1.05 K - 4.20x slower +726.88 μs
```

### Parallelism 12

This is a fairly normal case that shows poolboy and named being about neck and neck.

```
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
Number of Available Cores: 12
Available memory: 32 GB
Elixir 1.9.0
Erlang 22.0.4

Benchmark suite executing with the following configuration:
warmup: 1 s
time: 4 s
memory time: 0 ns
parallel: 12
inputs: none specified
Estimated total run time: 15 s

Benchmarking default enqueuer...
Benchmarking named enqueuer...
Benchmarking poolboy enqueuer...

Name                       ips        average  deviation         median         99th %
poolboy enqueuer        2.83 K      352.86 μs    ±26.97%         339 μs         655 μs
named enqueuer          2.78 K      359.24 μs    ±53.25%         302 μs        1004 μs
default enqueuer        0.84 K     1187.04 μs    ±21.96%        1121 μs     1882.19 μs

Comparison:
poolboy enqueuer        2.83 K
named enqueuer          2.78 K - 1.02x slower +6.38 μs
default enqueuer        0.84 K - 3.36x slower +834.18 μs
```

### Parallelism 24

This was a pretty big surprise to me. I did not expect poolboy to be so much slower than named here. However, it was this way in
every single test I ran.

```
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
Number of Available Cores: 12
Available memory: 32 GB
Elixir 1.9.0
Erlang 22.0.4

Benchmark suite executing with the following configuration:
warmup: 1 s
time: 4 s
memory time: 0 ns
parallel: 24
inputs: none specified
Estimated total run time: 15 s

Benchmarking default enqueuer...
Benchmarking named enqueuer...
Benchmarking poolboy enqueuer...

Name                       ips        average  deviation         median         99th %
named enqueuer          1.48 K      675.58 μs    ±66.26%      541.98 μs     2198.98 μs
poolboy enqueuer        1.06 K      942.92 μs    ±51.20%      845.98 μs     2470.98 μs
default enqueuer        0.34 K     2900.89 μs    ±19.05%     2765.98 μs     4482.25 μs

Comparison:
named enqueuer          1.48 K
poolboy enqueuer        1.06 K - 1.40x slower +267.34 μs
default enqueuer        0.34 K - 4.29x slower +2225.31 μs
```

### Parallelism 48

This surprises me after the results of 24. However, it is consistently ranked this way in various parallelisms I tested.

```
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
Number of Available Cores: 12
Available memory: 32 GB
Elixir 1.9.0
Erlang 22.0.4

Benchmark suite executing with the following configuration:
warmup: 1 s
time: 4 s
memory time: 0 ns
parallel: 48
inputs: none specified
Estimated total run time: 15 s

Benchmarking default enqueuer...
Benchmarking named enqueuer...
Benchmarking poolboy enqueuer...

Name                       ips        average  deviation         median         99th %
poolboy enqueuer        912.30        1.10 ms    ±30.56%        1.01 ms        2.35 ms
named enqueuer          896.40        1.12 ms    ±77.47%        0.86 ms        4.06 ms
default enqueuer        203.05        4.92 ms    ±18.66%        4.65 ms        8.84 ms

Comparison:
poolboy enqueuer        912.30
named enqueuer          896.40 - 1.02x slower +0.0195 ms
default enqueuer        203.05 - 4.49x slower +3.83 ms
```
