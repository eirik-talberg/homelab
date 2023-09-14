WAIT_TIME = 30
MACHINES = {
    "pve": {
        "host": "<ip>",
        "user": "root",
        "directory": "/path/to/zfs/mount"
    },
    "2gb": {
        "host": "<ip>",
        "user": "<username>",
        "directory": "/path/to/disk/mount"
    },
    "4gb": {
        "host": "<ip>",
        "user": "<username>",
        "directory": "/path/to/disk/mount"
    },
    "8gb": {
        "host": "<ip>",
        "user": "<username>",
        "directory": "/path/to/disk/mount"
    }
}

BENCHMARKS = [
    ("write-random-4kib-1x",
     "fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=4k --size=4g --numjobs=1 --iodepth=1 --runtime=60 --time_based --end_fsync=1 --output-format=json"),
    ("write-random-64kib-16x",
     "fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=64k --size=256m --numjobs=16 --iodepth=16 --runtime=60 --time_based --end_fsync=1 --output-format=json"),
    ("write-random-1mib-1x",
     "fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=60 --time_based --end_fsync=1 --output-format=json")
]