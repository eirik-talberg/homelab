# Proxmox (PVE) disk I/O benchmarks

## Setup

## Provisioning


## Benchmarking suite
From https://arstechnica.com/gadgets/2020/02/how-fast-are-your-disks-find-out-the-open-source-way-with-fio/

The use case is pretty basic here, primarily using Longhorn for distributed block storage in Kubernetes.

### 1x 4KiB random write
``fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=4k --size=4g --numjobs=1 --iodepth=1 --runtime=60 --time_based --end_fsync=1``

### 16x 4KiB random write
``fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=64k --size=256m --numjobs=16 --iodepth=16 --runtime=60 --time_based --end_fsync=1``

### 1x 1MiB random write
``fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=60 --time_based --end_fsync=1``


## Results

| Storage type         | 1x 4KiB rand. w. | 16x 4Kib rand. w. | 1x 1MiB rand. w. |
|----------------------|-----------------:|------------------:|-----------------:|
| Host (PVE)           |              xxx |               xxx |              xxx |
| Ubuntu 22.04 VM SCSI |              xxx |               xxx |              xxx |