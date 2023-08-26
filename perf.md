# Benchmark Report for */home/vchuravy/src/HashArrayMappedTries*

## Job Properties
* Time of benchmark: 26 Aug 2023 - 15:50
* Package commit: 084db7
* Julia commit: 661654
* Julia command flags: None
* Environment variables: None

## Results
Below is a table of this job's results, obtained by running the benchmarks.
The values listed in the `ID` column have the structure `[parent_group, child_group, ..., key]`, and can be used to
index into the BaseBenchmarks suite to retrieve the corresponding benchmarks.
The percentages accompanying time and memory values in the below table are noise tolerances. The "true"
time/memory value for a given benchmark is expected to fall within this percentage of the reported value.
An empty cell means that the value was zero.

| ID                                              | time            | GC time | memory          | allocations |
|-------------------------------------------------|----------------:|--------:|----------------:|------------:|
| `["HAMT", "creation (Persistent), size=0"]`     | 188.077 ns (5%) |         |   80 bytes (1%) |           2 |
| `["HAMT", "creation (Persistent), size=1"]`     | 277.804 ns (5%) |         |  272 bytes (1%) |           6 |
| `["HAMT", "creation (Persistent), size=1024"]`  | 167.470 μs (5%) |         | 820.34 KiB (1%) |        6883 |
| `["HAMT", "creation (Persistent), size=128"]`   |  15.520 μs (5%) |         |  71.72 KiB (1%) |         730 |
| `["HAMT", "creation (Persistent), size=16"]`    |   1.591 μs (5%) |         |   5.77 KiB (1%) |          75 |
| `["HAMT", "creation (Persistent), size=16384"]` |   3.656 ms (5%) |         |  16.18 MiB (1%) |      136157 |
| `["HAMT", "creation (Persistent), size=2"]`     | 338.595 ns (5%) |         |  480 bytes (1%) |          10 |
| `["HAMT", "creation (Persistent), size=2048"]`  | 373.520 μs (5%) |         |   1.75 MiB (1%) |       14694 |
| `["HAMT", "creation (Persistent), size=256"]`   |  30.320 μs (5%) |         | 150.27 KiB (1%) |        1545 |
| `["HAMT", "creation (Persistent), size=32"]`    |   3.929 μs (5%) |         |  15.91 KiB (1%) |         158 |
| `["HAMT", "creation (Persistent), size=4"]`     | 470.612 ns (5%) |         |  912 bytes (1%) |          18 |
| `["HAMT", "creation (Persistent), size=4096"]`  | 760.931 μs (5%) |         |   3.56 MiB (1%) |       31229 |
| `["HAMT", "creation (Persistent), size=512"]`   |  70.720 μs (5%) |         | 347.98 KiB (1%) |        3249 |
| `["HAMT", "creation (Persistent), size=64"]`    |   7.670 μs (5%) |         |  34.41 KiB (1%) |         340 |
| `["HAMT", "creation (Persistent), size=8"]`     | 739.833 ns (5%) |         |   1.83 KiB (1%) |          34 |
| `["HAMT", "creation (Persistent), size=8192"]`  |   1.609 ms (5%) |         |   7.33 MiB (1%) |       65424 |
| `["HAMT", "creation, size=0"]`                  | 182.474 ns (5%) |         |   80 bytes (1%) |           2 |
| `["HAMT", "creation, size=1"]`                  | 244.151 ns (5%) |         |  192 bytes (1%) |           4 |
| `["HAMT", "creation, size=1024"]`               |  52.110 μs (5%) |         |  95.03 KiB (1%) |        2060 |
| `["HAMT", "creation, size=128"]`                |   5.897 μs (5%) |         |  11.05 KiB (1%) |         258 |
| `["HAMT", "creation, size=16"]`                 | 810.465 ns (5%) |         |   1.61 KiB (1%) |          32 |
| `["HAMT", "creation, size=16384"]`              |   1.029 ms (5%) |         |   1.45 MiB (1%) |       29653 |
| `["HAMT", "creation, size=2"]`                  | 259.176 ns (5%) |         |  224 bytes (1%) |           5 |
| `["HAMT", "creation, size=2048"]`               | 113.150 μs (5%) |         | 185.78 KiB (1%) |        4212 |
| `["HAMT", "creation, size=256"]`                |  10.650 μs (5%) |         |  21.92 KiB (1%) |         465 |
| `["HAMT", "creation, size=32"]`                 |   1.685 μs (5%) |         |   3.36 KiB (1%) |          72 |
| `["HAMT", "creation, size=4"]`                  | 296.564 ns (5%) |         |  288 bytes (1%) |           7 |
| `["HAMT", "creation, size=4096"]`               | 217.380 μs (5%) |         | 338.72 KiB (1%) |        7807 |
| `["HAMT", "creation, size=512"]`                |  22.540 μs (5%) |         |  46.30 KiB (1%) |         946 |
| `["HAMT", "creation, size=64"]`                 |   3.089 μs (5%) |         |   5.77 KiB (1%) |         131 |
| `["HAMT", "creation, size=8"]`                  | 379.755 ns (5%) |         |  416 bytes (1%) |          11 |
| `["HAMT", "creation, size=8192"]`               | 451.980 μs (5%) |         | 688.94 KiB (1%) |       14410 |
| `["HAMT", "delete, size=1"]`                    |  37.278 ns (5%) |         |   96 bytes (1%) |           2 |
| `["HAMT", "delete, size=1024"]`                 | 101.395 ns (5%) |         |  672 bytes (1%) |           6 |
| `["HAMT", "delete, size=128"]`                  |  99.421 ns (5%) |         |  544 bytes (1%) |           6 |
| `["HAMT", "delete, size=16"]`                   |  44.113 ns (5%) |         |  192 bytes (1%) |           2 |
| `["HAMT", "delete, size=16384"]`                | 147.541 ns (5%) |         |  944 bytes (1%) |           8 |
| `["HAMT", "delete, size=2"]`                    |  34.048 ns (5%) |         |   96 bytes (1%) |           2 |
| `["HAMT", "delete, size=2048"]`                 | 112.863 ns (5%) |         |  768 bytes (1%) |           6 |
| `["HAMT", "delete, size=256"]`                  |  72.956 ns (5%) |         |  480 bytes (1%) |           4 |
| `["HAMT", "delete, size=32"]`                   |  69.050 ns (5%) |         |  352 bytes (1%) |           4 |
| `["HAMT", "delete, size=4"]`                    |  43.717 ns (5%) |         |  112 bytes (1%) |           2 |
| `["HAMT", "delete, size=4096"]`                 | 116.517 ns (5%) |         |  816 bytes (1%) |           6 |
| `["HAMT", "delete, size=512"]`                  |  72.925 ns (5%) |         |  528 bytes (1%) |           4 |
| `["HAMT", "delete, size=64"]`                   |  74.421 ns (5%) |         |  416 bytes (1%) |           4 |
| `["HAMT", "delete, size=8"]`                    |  44.960 ns (5%) |         |  144 bytes (1%) |           2 |
| `["HAMT", "delete, size=8192"]`                 | 115.272 ns (5%) |         |  848 bytes (1%) |           6 |
| `["HAMT", "getindex, size=1"]`                  |   5.220 ns (5%) |         |                 |             |
| `["HAMT", "getindex, size=1024"]`               |   8.678 ns (5%) |         |                 |             |
| `["HAMT", "getindex, size=128"]`                |   8.669 ns (5%) |         |                 |             |
| `["HAMT", "getindex, size=16"]`                 |   5.209 ns (5%) |         |                 |             |
| `["HAMT", "getindex, size=16384"]`              |  11.572 ns (5%) |         |                 |             |
| `["HAMT", "getindex, size=2"]`                  |   5.209 ns (5%) |         |                 |             |
| `["HAMT", "getindex, size=2048"]`               |   8.669 ns (5%) |         |                 |             |
| `["HAMT", "getindex, size=256"]`                |   6.800 ns (5%) |         |                 |             |
| `["HAMT", "getindex, size=32"]`                 |   6.809 ns (5%) |         |                 |             |
| `["HAMT", "getindex, size=4"]`                  |   5.220 ns (5%) |         |                 |             |
| `["HAMT", "getindex, size=4096"]`               |   8.678 ns (5%) |         |                 |             |
| `["HAMT", "getindex, size=512"]`                |   6.780 ns (5%) |         |                 |             |
| `["HAMT", "getindex, size=64"]`                 |   6.800 ns (5%) |         |                 |             |
| `["HAMT", "getindex, size=8"]`                  |   5.270 ns (5%) |         |                 |             |
| `["HAMT", "getindex, size=8192"]`               |   8.678 ns (5%) |         |                 |             |
| `["HAMT", "insert, size=0"]`                    |  65.745 ns (5%) |         |  192 bytes (1%) |           4 |
| `["HAMT", "insert, size=1"]`                    |  67.357 ns (5%) |         |  208 bytes (1%) |           4 |
| `["HAMT", "insert, size=1024"]`                 | 108.485 ns (5%) |         |   1.31 KiB (1%) |           6 |
| `["HAMT", "insert, size=128"]`                  | 105.138 ns (5%) |         |  576 bytes (1%) |           6 |
| `["HAMT", "insert, size=16"]`                   |  70.619 ns (5%) |         |  624 bytes (1%) |           4 |
| `["HAMT", "insert, size=16384"]`                | 138.141 ns (5%) |         |   1.22 KiB (1%) |           8 |
| `["HAMT", "insert, size=2"]`                    |  64.571 ns (5%) |         |  208 bytes (1%) |           4 |
| `["HAMT", "insert, size=2048"]`                 | 110.125 ns (5%) |         |   1.45 KiB (1%) |           6 |
| `["HAMT", "insert, size=256"]`                  | 104.553 ns (5%) |         |  592 bytes (1%) |           6 |
| `["HAMT", "insert, size=32"]`                   | 101.398 ns (5%) |         |  464 bytes (1%) |           6 |
| `["HAMT", "insert, size=4"]`                    |  64.969 ns (5%) |         |  224 bytes (1%) |           4 |
| `["HAMT", "insert, size=4096"]`                 | 145.816 ns (5%) |         |  912 bytes (1%) |           8 |
| `["HAMT", "insert, size=512"]`                  | 145.457 ns (5%) |         |  672 bytes (1%) |           8 |
| `["HAMT", "insert, size=64"]`                   |  98.541 ns (5%) |         |  528 bytes (1%) |           6 |
| `["HAMT", "insert, size=8"]`                    |  70.832 ns (5%) |         |  512 bytes (1%) |           4 |
| `["HAMT", "insert, size=8192"]`                 | 172.619 ns (5%) |         |   1.20 KiB (1%) |           8 |
| `["HAMT", "setindex!, size=0"]`                 |  11.291 ns (5%) |         |   32 bytes (1%) |           1 |
| `["HAMT", "setindex!, size=1"]`                 |  11.411 ns (5%) |         |   32 bytes (1%) |           1 |
| `["HAMT", "setindex!, size=1024"]`              |  13.808 ns (5%) |         |   32 bytes (1%) |           1 |
| `["HAMT", "setindex!, size=128"]`               |  13.798 ns (5%) |         |   32 bytes (1%) |           1 |
| `["HAMT", "setindex!, size=16"]`                |  11.421 ns (5%) |         |   32 bytes (1%) |           1 |
| `["HAMT", "setindex!, size=16384"]`             |  16.212 ns (5%) |         |   32 bytes (1%) |           1 |
| `["HAMT", "setindex!, size=2"]`                 |  11.391 ns (5%) |         |   32 bytes (1%) |           1 |
| `["HAMT", "setindex!, size=2048"]`              |  13.828 ns (5%) |         |   32 bytes (1%) |           1 |
| `["HAMT", "setindex!, size=256"]`               |  13.818 ns (5%) |         |   32 bytes (1%) |           1 |
| `["HAMT", "setindex!, size=32"]`                |  13.788 ns (5%) |         |   32 bytes (1%) |           1 |
| `["HAMT", "setindex!, size=4"]`                 |  11.351 ns (5%) |         |   32 bytes (1%) |           1 |
| `["HAMT", "setindex!, size=4096"]`              |  16.172 ns (5%) |         |   32 bytes (1%) |           1 |
| `["HAMT", "setindex!, size=512"]`               |  16.273 ns (5%) |         |   32 bytes (1%) |           1 |
| `["HAMT", "setindex!, size=64"]`                |  13.757 ns (5%) |         |   32 bytes (1%) |           1 |
| `["HAMT", "setindex!, size=8"]`                 |  11.381 ns (5%) |         |   32 bytes (1%) |           1 |
| `["HAMT", "setindex!, size=8192"]`              |  16.303 ns (5%) |         |   32 bytes (1%) |           1 |

## Benchmark Group List
Here's a list of all the benchmark groups executed by this job:

- `["HAMT"]`

## Julia versioninfo
```
Julia Version 1.10.0-beta1
Commit 6616549950e (2023-07-25 17:43 UTC)
Platform Info:
  OS: Linux (x86_64-linux-gnu)
      "Arch Linux"
  uname: Linux 6.3.2-arch1-1 #1 SMP PREEMPT_DYNAMIC Thu, 11 May 2023 16:40:42 +0000 x86_64 unknown
  CPU: AMD Ryzen 7 3700X 8-Core Processor: 
                 speed         user         nice          sys         idle          irq
       #1-16  2200 MHz    1207939 s       2006 s      95736 s   12587763 s      20448 s
  Memory: 125.69889831542969 GB (84194.5859375 MB free)
  Uptime: 366181.67 sec
  Load Avg:  1.07  0.93  0.68
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-15.0.7 (ORCJIT, znver2)
  Threads: 1 on 16 virtual cores
```