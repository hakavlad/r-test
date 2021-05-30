
# r-test

Run I/O bound task under memory pressure.

`r-test` is a Python script that can: 
- create the specified number of mebibyte files in the specified directory;
- read the specified volume of files from the directory in random order and add the resulting volume to the list in memory;
- show time and average reading speed;
- log results in the specified file.

The script can be used, for example, to assess the impact of virtual memory settings (`vm.swappiness`, `vm.watermark_scale_factor`, multigen LRU Framework etc) on the efficiency of file caching, especially under memory pressure. The script allows you to evaluate the performance of I/O operations under memory pressure.

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

Output examples:
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
2021-05-30 15:34:20,932: setting self oom_score_adj=1000
2021-05-30 15:34:20,933: reading files from the directory testdir1
2021-05-30 15:34:20,969: read 1.0M (6.7%) in 0.0s; file 0.6762569307716757
2021-05-30 15:34:21,082: read 2.0M (13.3%) in 0.1s; file 0.9019402503691984
2021-05-30 15:34:21,323: read 3.0M (20.0%) in 0.4s; file 0.7066831728813696
2021-05-30 15:34:21,325: read 4.0M (26.7%) in 0.4s; file 0.6762569307716757
2021-05-30 15:34:21,326: read 5.0M (33.3%) in 0.4s; file 0.9019402503691984
2021-05-30 15:34:21,547: read 6.0M (40.0%) in 0.6s; file 0.06466405586214241
2021-05-30 15:34:21,549: read 7.0M (46.7%) in 0.6s; file 0.06466405586214241
2021-05-30 15:34:21,911: read 8.0M (53.3%) in 1.0s; file 0.6948490864718008
2021-05-30 15:34:21,912: read 9.0M (60.0%) in 1.0s; file 0.06466405586214241
2021-05-30 15:34:21,914: read 10.0M (66.7%) in 1.0s; file 0.06466405586214241
2021-05-30 15:34:21,915: read 11.0M (73.3%) in 1.0s; file 0.6948490864718008
2021-05-30 15:34:21,916: read 12.0M (80.0%) in 1.0s; file 0.6948490864718008
2021-05-30 15:34:21,918: read 13.0M (86.7%) in 1.0s; file 0.6762569307716757
2021-05-30 15:34:21,919: read 14.0M (93.3%) in 1.0s; file 0.7066831728813696
2021-05-30 15:34:21,920: read 15.0M (100.0%) in 1.0s; file 0.6948490864718008
2021-05-30 15:34:21,921: read 15.0 MiB in 1.0s; avg: 15.2 MiB/sec
2021-05-30 15:34:21,921: OK
```

At the end, `r-test `shows the reading time and average speed. 

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
