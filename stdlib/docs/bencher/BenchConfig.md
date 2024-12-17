---
title: BenchConfig
version: 0.0.0
slug: BenchConfig
type: struct
namespace: benchmark.bencher
---

<section class='mojo-docs'>

Defines a benchmark configuration struct to control execution times and
frequency.

## Fields

- ​<b>out_file</b> (`Optional[Path]`): Output file to write results to.
- ​<b>min_runtime_secs</b> (`SIMD[float64, 1]`): Lower bound on benchmarking time
  in secs.
- ​<b>max_runtime_secs</b> (`SIMD[float64, 1]`): Upper bound on benchmarking time
  in secs.
- ​<b>min_warmuptime_secs</b> (`SIMD[float64, 1]`): Lower bound on the warmup time
  in secs.
- ​<b>max_batch_size</b> (`Int`): The maximum number of iterations to perform per
  time measurement.
- ​<b>max_iters</b> (`Int`): Max number of iterations to run.
- ​<b>num_repetitions</b> (`Int`): Number of times the benchmark has to be
  repeated.
- ​<b>flush_denormals</b> (`Bool`): Whether or not the denormal values are
  flushed.
- ​<b>show_progress</b> (`Bool`): Whether or not to show the progress of each
  benchmark.
- ​<b>tabular_view</b> (`Bool`): Whether to print results in csv readable/tabular
  format.

## Implemented traits

`AnyType`,
`CollectionElement`,
`Copyable`,
`Movable`

## Methods

### `__init__`

<div class='mojo-function-detail'>

<div class="mojo-function-sig">

```mojo
__init__(out self: out_file: Optional[Path] = None, min_runtime_secs: SIMD[float64, 1] = 1.0, max_runtime_secs: SIMD[float64, 1] = 2.0, min_warmuptime_secs: SIMD[float64, 1] = 1.0, max_batch_size: Int = 0, max_iters: Int = 1000000000, num_repetitions: Int = 1, flush_denormals: Bool = True)
```

</div>

Constructs and initializes Benchmark config object with default and inputted values.

**Args:**

- ​<b>out_file</b> (`Optional[Path]`): Output file to write results to.
- ​<b>min_runtime_secs</b> (`SIMD[float64, 1]`): Upper bound on benchmarking time
  in secs (default `1.0`).
- ​<b>max_runtime_secs</b> (`SIMD[float64, 1]`): Lower bound on benchmarking time
  in secs (default `2.0`).
- ​<b>min_warmuptime_secs</b> (`SIMD[float64, 1]`): Lower bound on the warmup time
  in secs (default `1.0`).
- ​<b>max_batch_size</b> (`Int`): The maximum number of iterations to perform per
  time measurement.
- ​<b>max_iters</b> (`Int`): Max number of iterations to run (default
  `1_000_000_000`).
- ​<b>num_repetitions</b> (`Int`): Number of times the benchmark has to be
  repeated.
- ​<b>flush_denormals</b> (`Bool`): Whether or not the denormal values are
  flushed.

</div>

</section>
