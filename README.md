
# r-test

Explore the impact of virtual memory settings on caching efficiency on Linux systems under memory pressure.

`r-test` is a Python script that can: 
- create the specified number of mebibyte files in the specified directory;
- read the specified volume of files from the directory in random order and add the resulting volume to the list in memory;
- show time and average reading speed;
- log results in the specified file.

The script can be used, for example, to assess the impact of virtual memory settings (`vm.swappiness`, `vm.watermark_scale_factor`, Multigenerational LRU Framework etc) on the efficiency of file caching, especially under memory pressure. The script allows you to evaluate the performance of I/O operations under memory pressure.

## Usage

Options:

```
$ r-test -h
usage: r-test [-h] [-p PATH] [-r READ] [-w WRITE] [-l LOG]

optional arguments:
  -h, --help            show this help message and exit
  -p PATH, --path PATH  path to the directory to write or read files
  -r READ, --read READ  how many mebibytes will be read from the files in the directory
  -w WRITE, --write WRITE
                        the number of mebibyte files to be written to the directory
  -l LOG, --log LOG     path to the log file
```

Create a directory with the specified number of mebibyte files. 
```
r-test -w 300
```
In this case, 300 mebibyte files will be created in the `testdir1` directory (this is the default name; you can specify a different directory with the `-p` option). 

Drop caches and write dirty cache:
```sh
$ drop-caches
#!/bin/sh -v
sudo sync
[sudo] password for user: 
echo 3 | sudo tee /proc/sys/vm/drop_caches
3
```

Next, run the test. Be careful when choosing a reading volume: the system can reach OOM or freeze. One useful option is to read as much as needed to move a significant amount of memory to the swap space. Read the files from the directory in random order.
```
r-test -r 20000
```
In this case, 20000 MiB files will be read in random order from the default directory. 

Optionally, you can specify the path to the log file. 

## Output examples

```
$ r-test -w 5
mkdir testdir1
written testdir1/0.9019402503691984; total size: 1M
written testdir1/0.6948490864718008; total size: 2M
written testdir1/0.7066831728813696; total size: 3M
written testdir1/0.06466405586214241; total size: 4M
written testdir1/0.6762569307716757; total size: 5M
OK
```

```
$ r-test -r 10
setting self oom_score_adj=1000
reading files from the directory testdir1
read 1.0M (10.0%) in 0.0s; file 0.06466405586214241
read 2.0M (20.0%) in 0.1s; file 0.6948490864718008
read 3.0M (30.0%) in 0.1s; file 0.6762569307716757
read 4.0M (40.0%) in 0.1s; file 0.7066831728813696
read 5.0M (50.0%) in 0.1s; file 0.7066831728813696
read 6.0M (60.0%) in 0.1s; file 0.06466405586214241
read 7.0M (70.0%) in 0.1s; file 0.9019402503691984
read 8.0M (80.0%) in 0.1s; file 0.6948490864718008
read 9.0M (90.0%) in 0.1s; file 0.6948490864718008
read 10.0M (100.0%) in 0.1s; file 0.9019402503691984
read 10.0 MiB in 0.1s; avg: 68.2 MiB/sec
OK
User defined signal 1
```

Log file example:
```
2021-05-30 16:56:56,307: mkdir testdir1
2021-05-30 16:56:56,378: written testdir1/0.7380872541587621; total size: 1M
2021-05-30 16:56:56,455: written testdir1/0.08128098820035623; total size: 2M
2021-05-30 16:56:56,533: written testdir1/0.522197186101786; total size: 3M
2021-05-30 16:56:56,611: written testdir1/0.38254948003417066; total size: 4M
2021-05-30 16:56:56,688: written testdir1/0.9967369046101179; total size: 5M
2021-05-30 16:56:56,688: OK
2021-05-30 16:57:33,766: setting self oom_score_adj=1000
2021-05-30 16:57:33,774: reading files from the directory testdir1
2021-05-30 16:57:33,858: read 1.0M (20.0%) in 0.1s; file 0.7380872541587621
2021-05-30 16:57:33,888: read 2.0M (40.0%) in 0.1s; file 0.9967369046101179
2021-05-30 16:57:33,914: read 3.0M (60.0%) in 0.1s; file 0.38254948003417066
2021-05-30 16:57:33,939: read 4.0M (80.0%) in 0.2s; file 0.522197186101786
2021-05-30 16:57:33,940: read 5.0M (100.0%) in 0.2s; file 0.7380872541587621
2021-05-30 16:57:33,940: read 5.0 MiB in 0.2s; avg: 30.3 MiB/sec
2021-05-30 16:57:33,940: OK
```

## Requirements

- Python 3.3+

## Install
```sh
$ git clone https://github.com/hakavlad/r-test.git
$ cd r-test
$ sudo make install
```
`r-test` and `drop-caches` scripts will be installed in `/usr/local/bin`.

## Uninstall
```sh
$ sudo make uninstall
```

## See also

These tools may be used to monitor memory and PSI metrics during stress tests:
- [mem2log](https://github.com/hakavlad/mem2log) may be used to log memory metrics from `/proc/meminfo`;
- [psi2log](https://github.com/hakavlad/nohang/blob/master/docs/psi2log.manpage.md) from [nohang](https://github.com/hakavlad/nohang) package may be used to log [PSI](https://facebookmicrosites.github.io/psi/docs/overview) metrics during tests.

Documentation for `/proc/sys/vm/`:
- https://www.kernel.org/doc/html/latest/admin-guide/sysctl/vm.html

Multigenerational LRU Framework at LKML:
- https://lore.kernel.org/lkml/20210313075747.3781593-1-yuzhao@google.com/
- https://lore.kernel.org/lkml/20210413065633.2782273-1-yuzhao@google.com/
- https://lore.kernel.org/lkml/20210520065355.2736558-1-yuzhao@google.com/
