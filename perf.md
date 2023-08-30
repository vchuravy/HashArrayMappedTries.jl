# Benchmark Report for */home/vchuravy/src/HashArrayMappedTries*

## Job Properties
* Time of benchmark: 30 Aug 2023 - 16:13
* Package commit: d8045f
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

| ID                                                   | time            | GC time   | memory          | allocations |
|------------------------------------------------------|----------------:|----------:|----------------:|------------:|
| `["Base.Dict", "creation (Persistent), size=0"]`     | 255.304 ns (5%) |           |  544 bytes (1%) |           4 |
| `["Base.Dict", "creation (Persistent), size=1"]`     | 374.778 ns (5%) |           |   1.06 KiB (1%) |           8 |
| `["Base.Dict", "creation (Persistent), size=1024"]`  |   3.277 ms (5%) |           |  37.36 MiB (1%) |        5005 |
| `["Base.Dict", "creation (Persistent), size=128"]`   |  62.620 μs (5%) |           | 450.48 KiB (1%) |         522 |
| `["Base.Dict", "creation (Persistent), size=16"]`    |   2.348 μs (5%) |           |  14.27 KiB (1%) |          71 |
| `["Base.Dict", "creation (Persistent), size=16384"]` | 626.214 ms (5%) | 18.319 ms |   7.94 GiB (1%) |      110830 |
| `["Base.Dict", "creation (Persistent), size=2"]`     | 503.763 ns (5%) |           |   1.59 KiB (1%) |          12 |
| `["Base.Dict", "creation (Persistent), size=2048"]`  |   9.043 ms (5%) |           | 105.71 MiB (1%) |       11149 |
| `["Base.Dict", "creation (Persistent), size=256"]`   | 239.100 μs (5%) |           |   2.10 MiB (1%) |        1037 |
| `["Base.Dict", "creation (Persistent), size=32"]`    |   4.100 μs (5%) |           |  35.52 KiB (1%) |         135 |
| `["Base.Dict", "creation (Persistent), size=4"]`     | 679.338 ns (5%) |           |   2.66 KiB (1%) |          20 |
| `["Base.Dict", "creation (Persistent), size=4096"]`  |  42.308 ms (5%) |  1.878 ms | 514.53 MiB (1%) |       24808 |
| `["Base.Dict", "creation (Persistent), size=512"]`   | 646.271 μs (5%) |           |   6.44 MiB (1%) |        2062 |
| `["Base.Dict", "creation (Persistent), size=64"]`    |  20.440 μs (5%) |           | 152.48 KiB (1%) |         266 |
| `["Base.Dict", "creation (Persistent), size=8"]`     |   1.118 μs (5%) |           |   4.78 KiB (1%) |          36 |
| `["Base.Dict", "creation (Persistent), size=8192"]`  | 127.359 ms (5%) |  6.986 ms |   1.57 GiB (1%) |       53480 |
| `["Base.Dict", "creation, size=0"]`                  | 247.473 ns (5%) |           |  544 bytes (1%) |           4 |
| `["Base.Dict", "creation, size=1"]`                  | 282.435 ns (5%) |           |  544 bytes (1%) |           4 |
| `["Base.Dict", "creation, size=1024"]`               |  17.670 μs (5%) |           |  91.97 KiB (1%) |          19 |
| `["Base.Dict", "creation, size=128"]`                |   2.403 μs (5%) |           |   6.36 KiB (1%) |          10 |
| `["Base.Dict", "creation, size=16"]`                 | 613.807 ns (5%) |           |   1.78 KiB (1%) |           7 |
| `["Base.Dict", "creation, size=16384"]`              | 362.030 μs (5%) |           |   1.42 MiB (1%) |          31 |
| `["Base.Dict", "creation, size=2"]`                  | 285.192 ns (5%) |           |  544 bytes (1%) |           4 |
| `["Base.Dict", "creation, size=2048"]`               |  31.311 μs (5%) |           |  91.97 KiB (1%) |          19 |
| `["Base.Dict", "creation, size=256"]`                |   5.742 μs (5%) |           |  23.67 KiB (1%) |          13 |
| `["Base.Dict", "creation, size=32"]`                 | 728.347 ns (5%) |           |   1.78 KiB (1%) |           7 |
| `["Base.Dict", "creation, size=4"]`                  | 309.417 ns (5%) |           |  544 bytes (1%) |           4 |
| `["Base.Dict", "creation, size=4096"]`               |  74.740 μs (5%) |           | 364.17 KiB (1%) |          25 |
| `["Base.Dict", "creation, size=512"]`                |   8.280 μs (5%) |           |  23.69 KiB (1%) |          14 |
| `["Base.Dict", "creation, size=64"]`                 |   1.807 μs (5%) |           |   6.36 KiB (1%) |          10 |
| `["Base.Dict", "creation, size=8"]`                  | 334.912 ns (5%) |           |  544 bytes (1%) |           4 |
| `["Base.Dict", "creation, size=8192"]`               | 139.150 μs (5%) |           | 364.17 KiB (1%) |          25 |
| `["Base.Dict", "delete, size=1"]`                    |  95.457 ns (5%) |           |  544 bytes (1%) |           4 |
| `["Base.Dict", "delete, size=1024"]`                 |   4.631 μs (5%) |           |  68.36 KiB (1%) |           6 |
| `["Base.Dict", "delete, size=128"]`                  | 667.898 ns (5%) |           |   4.66 KiB (1%) |           4 |
| `["Base.Dict", "delete, size=16"]`                   | 117.146 ns (5%) |           |   1.33 KiB (1%) |           4 |
| `["Base.Dict", "delete, size=16384"]`                |  73.270 μs (5%) |           |   1.06 MiB (1%) |           7 |
| `["Base.Dict", "delete, size=2"]`                    | 100.231 ns (5%) |           |  544 bytes (1%) |           4 |
| `["Base.Dict", "delete, size=2048"]`                 |   4.536 μs (5%) |           |  68.36 KiB (1%) |           6 |
| `["Base.Dict", "delete, size=256"]`                  |   1.396 μs (5%) |           |  17.39 KiB (1%) |           4 |
| `["Base.Dict", "delete, size=32"]`                   | 134.466 ns (5%) |           |   1.33 KiB (1%) |           4 |
| `["Base.Dict", "delete, size=4"]`                    | 100.926 ns (5%) |           |  544 bytes (1%) |           4 |
| `["Base.Dict", "delete, size=4096"]`                 |  18.240 μs (5%) |           | 272.28 KiB (1%) |           7 |
| `["Base.Dict", "delete, size=512"]`                  |   1.429 μs (5%) |           |  17.39 KiB (1%) |           4 |
| `["Base.Dict", "delete, size=64"]`                   | 662.026 ns (5%) |           |   4.66 KiB (1%) |           4 |
| `["Base.Dict", "delete, size=8"]`                    | 101.535 ns (5%) |           |  544 bytes (1%) |           4 |
| `["Base.Dict", "delete, size=8192"]`                 |  19.360 μs (5%) |           | 272.28 KiB (1%) |           7 |
| `["Base.Dict", "getindex, size=1"]`                  |   6.450 ns (5%) |           |                 |             |
| `["Base.Dict", "getindex, size=1024"]`               |   6.449 ns (5%) |           |                 |             |
| `["Base.Dict", "getindex, size=128"]`                |   7.297 ns (5%) |           |                 |             |
| `["Base.Dict", "getindex, size=16"]`                 |   6.450 ns (5%) |           |                 |             |
| `["Base.Dict", "getindex, size=16384"]`              |   6.900 ns (5%) |           |                 |             |
| `["Base.Dict", "getindex, size=2"]`                  |   6.460 ns (5%) |           |                 |             |
| `["Base.Dict", "getindex, size=2048"]`               |   6.880 ns (5%) |           |                 |             |
| `["Base.Dict", "getindex, size=256"]`                |   6.449 ns (5%) |           |                 |             |
| `["Base.Dict", "getindex, size=32"]`                 |   7.688 ns (5%) |           |                 |             |
| `["Base.Dict", "getindex, size=4"]`                  |   6.449 ns (5%) |           |                 |             |
| `["Base.Dict", "getindex, size=4096"]`               |   6.449 ns (5%) |           |                 |             |
| `["Base.Dict", "getindex, size=512"]`                |   6.880 ns (5%) |           |                 |             |
| `["Base.Dict", "getindex, size=64"]`                 |   6.450 ns (5%) |           |                 |             |
| `["Base.Dict", "getindex, size=8"]`                  |   6.469 ns (5%) |           |                 |             |
| `["Base.Dict", "getindex, size=8192"]`               |   7.247 ns (5%) |           |                 |             |
| `["Base.Dict", "insert, size=0"]`                    |  99.852 ns (5%) |           |  544 bytes (1%) |           4 |
| `["Base.Dict", "insert, size=1"]`                    | 102.223 ns (5%) |           |  544 bytes (1%) |           4 |
| `["Base.Dict", "insert, size=1024"]`                 |   4.496 μs (5%) |           |  68.36 KiB (1%) |           6 |
| `["Base.Dict", "insert, size=128"]`                  | 665.629 ns (5%) |           |   4.66 KiB (1%) |           4 |
| `["Base.Dict", "insert, size=16"]`                   | 117.989 ns (5%) |           |   1.33 KiB (1%) |           4 |
| `["Base.Dict", "insert, size=16384"]`                |  71.400 μs (5%) |           |   1.06 MiB (1%) |           7 |
| `["Base.Dict", "insert, size=2"]`                    | 103.795 ns (5%) |           |  544 bytes (1%) |           4 |
| `["Base.Dict", "insert, size=2048"]`                 |   4.680 μs (5%) |           |  68.36 KiB (1%) |           6 |
| `["Base.Dict", "insert, size=256"]`                  |   1.459 μs (5%) |           |  17.39 KiB (1%) |           4 |
| `["Base.Dict", "insert, size=32"]`                   | 139.318 ns (5%) |           |   1.33 KiB (1%) |           4 |
| `["Base.Dict", "insert, size=4"]`                    | 103.823 ns (5%) |           |  544 bytes (1%) |           4 |
| `["Base.Dict", "insert, size=4096"]`                 |  17.740 μs (5%) |           | 272.28 KiB (1%) |           7 |
| `["Base.Dict", "insert, size=512"]`                  |   1.391 μs (5%) |           |  17.39 KiB (1%) |           4 |
| `["Base.Dict", "insert, size=64"]`                   | 665.833 ns (5%) |           |   4.66 KiB (1%) |           4 |
| `["Base.Dict", "insert, size=8"]`                    | 103.949 ns (5%) |           |  544 bytes (1%) |           4 |
| `["Base.Dict", "insert, size=8192"]`                 |  17.050 μs (5%) |           | 272.28 KiB (1%) |           7 |
| `["HAMT", "creation (Persistent), size=0"]`          | 185.255 ns (5%) |           |   80 bytes (1%) |           2 |
| `["HAMT", "creation (Persistent), size=1"]`          | 278.759 ns (5%) |           |  272 bytes (1%) |           6 |
| `["HAMT", "creation (Persistent), size=1024"]`       | 175.580 μs (5%) |           | 820.34 KiB (1%) |        6883 |
| `["HAMT", "creation (Persistent), size=128"]`        |  16.320 μs (5%) |           |  71.72 KiB (1%) |         730 |
| `["HAMT", "creation (Persistent), size=16"]`         |   1.576 μs (5%) |           |   5.77 KiB (1%) |          75 |
| `["HAMT", "creation (Persistent), size=16384"]`      |   3.787 ms (5%) |           |  16.18 MiB (1%) |      136157 |
| `["HAMT", "creation (Persistent), size=2"]`          | 340.231 ns (5%) |           |  480 bytes (1%) |          10 |
| `["HAMT", "creation (Persistent), size=2048"]`       | 388.410 μs (5%) |           |   1.75 MiB (1%) |       14694 |
| `["HAMT", "creation (Persistent), size=256"]`        |  33.030 μs (5%) |           | 150.27 KiB (1%) |        1545 |
| `["HAMT", "creation (Persistent), size=32"]`         |   3.996 μs (5%) |           |  15.91 KiB (1%) |         158 |
| `["HAMT", "creation (Persistent), size=4"]`          | 460.765 ns (5%) |           |  912 bytes (1%) |          18 |
| `["HAMT", "creation (Persistent), size=4096"]`       | 788.390 μs (5%) |           |   3.56 MiB (1%) |       31229 |
| `["HAMT", "creation (Persistent), size=512"]`        |  74.200 μs (5%) |           | 347.98 KiB (1%) |        3249 |
| `["HAMT", "creation (Persistent), size=64"]`         |   7.937 μs (5%) |           |  34.41 KiB (1%) |         340 |
| `["HAMT", "creation (Persistent), size=8"]`          | 734.729 ns (5%) |           |   1.83 KiB (1%) |          34 |
| `["HAMT", "creation (Persistent), size=8192"]`       |   1.663 ms (5%) |           |   7.33 MiB (1%) |       65424 |
| `["HAMT", "creation, size=0"]`                       | 185.782 ns (5%) |           |   80 bytes (1%) |           2 |
| `["HAMT", "creation, size=1"]`                       | 251.596 ns (5%) |           |  192 bytes (1%) |           4 |
| `["HAMT", "creation, size=1024"]`                    |  59.650 μs (5%) |           |  95.03 KiB (1%) |        2060 |
| `["HAMT", "creation, size=128"]`                     |   6.528 μs (5%) |           |  11.05 KiB (1%) |         258 |
| `["HAMT", "creation, size=16"]`                      | 862.414 ns (5%) |           |   1.61 KiB (1%) |          32 |
| `["HAMT", "creation, size=16384"]`                   |   1.209 ms (5%) |           |   1.45 MiB (1%) |       29653 |
| `["HAMT", "creation, size=2"]`                       | 261.588 ns (5%) |           |  224 bytes (1%) |           5 |
| `["HAMT", "creation, size=2048"]`                    | 129.710 μs (5%) |           | 185.78 KiB (1%) |        4212 |
| `["HAMT", "creation, size=256"]`                     |  12.080 μs (5%) |           |  21.92 KiB (1%) |         465 |
| `["HAMT", "creation, size=32"]`                      |   1.758 μs (5%) |           |   3.36 KiB (1%) |          72 |
| `["HAMT", "creation, size=4"]`                       | 301.825 ns (5%) |           |  288 bytes (1%) |           7 |
| `["HAMT", "creation, size=4096"]`                    | 255.860 μs (5%) |           | 338.72 KiB (1%) |        7807 |
| `["HAMT", "creation, size=512"]`                     |  25.810 μs (5%) |           |  46.30 KiB (1%) |         946 |
| `["HAMT", "creation, size=64"]`                      |   3.331 μs (5%) |           |   5.77 KiB (1%) |         131 |
| `["HAMT", "creation, size=8"]`                       | 384.089 ns (5%) |           |  416 bytes (1%) |          11 |
| `["HAMT", "creation, size=8192"]`                    | 524.360 μs (5%) |           | 688.94 KiB (1%) |       14410 |
| `["HAMT", "delete, size=1"]`                         |  37.892 ns (5%) |           |   96 bytes (1%) |           2 |
| `["HAMT", "delete, size=1024"]`                      | 118.309 ns (5%) |           |  672 bytes (1%) |           6 |
| `["HAMT", "delete, size=128"]`                       | 107.785 ns (5%) |           |  544 bytes (1%) |           6 |
| `["HAMT", "delete, size=16"]`                        |  46.785 ns (5%) |           |  192 bytes (1%) |           2 |
| `["HAMT", "delete, size=16384"]`                     | 165.375 ns (5%) |           |  944 bytes (1%) |           8 |
| `["HAMT", "delete, size=2"]`                         |  35.880 ns (5%) |           |   96 bytes (1%) |           2 |
| `["HAMT", "delete, size=2048"]`                      | 123.589 ns (5%) |           |  768 bytes (1%) |           6 |
| `["HAMT", "delete, size=256"]`                       |  84.870 ns (5%) |           |  480 bytes (1%) |           4 |
| `["HAMT", "delete, size=32"]`                        |  76.111 ns (5%) |           |  352 bytes (1%) |           4 |
| `["HAMT", "delete, size=4"]`                         |  44.444 ns (5%) |           |  112 bytes (1%) |           2 |
| `["HAMT", "delete, size=4096"]`                      | 128.149 ns (5%) |           |  816 bytes (1%) |           6 |
| `["HAMT", "delete, size=512"]`                       |  86.323 ns (5%) |           |  528 bytes (1%) |           4 |
| `["HAMT", "delete, size=64"]`                        |  83.161 ns (5%) |           |  416 bytes (1%) |           4 |
| `["HAMT", "delete, size=8"]`                         |  47.358 ns (5%) |           |  144 bytes (1%) |           2 |
| `["HAMT", "delete, size=8192"]`                      | 130.148 ns (5%) |           |  848 bytes (1%) |           6 |
| `["HAMT", "getindex, size=1"]`                       |   6.210 ns (5%) |           |                 |             |
| `["HAMT", "getindex, size=1024"]`                    |  13.938 ns (5%) |           |                 |             |
| `["HAMT", "getindex, size=128"]`                     |  13.948 ns (5%) |           |                 |             |
| `["HAMT", "getindex, size=16"]`                      |   6.269 ns (5%) |           |                 |             |
| `["HAMT", "getindex, size=16384"]`                   |  18.305 ns (5%) |           |                 |             |
| `["HAMT", "getindex, size=2"]`                       |   6.249 ns (5%) |           |                 |             |
| `["HAMT", "getindex, size=2048"]`                    |  13.978 ns (5%) |           |                 |             |
| `["HAMT", "getindex, size=256"]`                     |   9.979 ns (5%) |           |                 |             |
| `["HAMT", "getindex, size=32"]`                      |   9.960 ns (5%) |           |                 |             |
| `["HAMT", "getindex, size=4"]`                       |   6.260 ns (5%) |           |                 |             |
| `["HAMT", "getindex, size=4096"]`                    |  13.958 ns (5%) |           |                 |             |
| `["HAMT", "getindex, size=512"]`                     |   9.980 ns (5%) |           |                 |             |
| `["HAMT", "getindex, size=64"]`                      |  10.050 ns (5%) |           |                 |             |
| `["HAMT", "getindex, size=8"]`                       |   6.200 ns (5%) |           |                 |             |
| `["HAMT", "getindex, size=8192"]`                    |  13.957 ns (5%) |           |                 |             |
| `["HAMT", "insert, size=0"]`                         |  60.827 ns (5%) |           |  192 bytes (1%) |           4 |
| `["HAMT", "insert, size=1"]`                         |  62.025 ns (5%) |           |  208 bytes (1%) |           4 |
| `["HAMT", "insert, size=1024"]`                      | 113.201 ns (5%) |           |   1.31 KiB (1%) |           6 |
| `["HAMT", "insert, size=128"]`                       | 107.300 ns (5%) |           |  576 bytes (1%) |           6 |
| `["HAMT", "insert, size=16"]`                        |  65.950 ns (5%) |           |  624 bytes (1%) |           4 |
| `["HAMT", "insert, size=16384"]`                     | 162.005 ns (5%) |           |   1.22 KiB (1%) |           8 |
| `["HAMT", "insert, size=2"]`                         |  63.092 ns (5%) |           |  208 bytes (1%) |           4 |
| `["HAMT", "insert, size=2048"]`                      | 194.514 ns (5%) |           |   1.45 KiB (1%) |           6 |
| `["HAMT", "insert, size=256"]`                       | 103.649 ns (5%) |           |  592 bytes (1%) |           6 |
| `["HAMT", "insert, size=32"]`                        | 104.489 ns (5%) |           |  464 bytes (1%) |           6 |
| `["HAMT", "insert, size=4"]`                         |  69.284 ns (5%) |           |  224 bytes (1%) |           4 |
| `["HAMT", "insert, size=4096"]`                      | 145.424 ns (5%) |           |  912 bytes (1%) |           8 |
| `["HAMT", "insert, size=512"]`                       | 162.173 ns (5%) |           |  672 bytes (1%) |           8 |
| `["HAMT", "insert, size=64"]`                        | 103.167 ns (5%) |           |  528 bytes (1%) |           6 |
| `["HAMT", "insert, size=8"]`                         |  69.178 ns (5%) |           |  512 bytes (1%) |           4 |
| `["HAMT", "insert, size=8192"]`                      | 176.745 ns (5%) |           |   1.20 KiB (1%) |           8 |

## Benchmark Group List
Here's a list of all the benchmark groups executed by this job:

- `["Base.Dict"]`
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
       #1-16  4049 MHz    2045929 s      51876 s     167338 s    4479886 s      32795 s
  Memory: 125.69889831542969 GB (92818.33984375 MB free)
  Uptime: 713148.87 sec
  Load Avg:  2.35  2.21  1.99
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-15.0.7 (ORCJIT, znver2)
  Threads: 1 on 16 virtual cores
```