#! /usr/bin/env python
import csv
import datetime
import json
import subprocess
import sys
import time

from config import MACHINES, WAIT_TIME, BENCHMARKS


def run_benchmarks() -> str:
    print("Running benchmarks")
    results = {}
    for node, values in MACHINES.items():
        results[node] = {}
        for name, command in BENCHMARKS:
            print(f"Running {name} on {node}")
            print(f"Command: {command}")
            proc = subprocess.run("ssh {user}@{host} \"cd {directory} && {command}\"".format(**values, command=command),
                                  capture_output=True, shell=True)
            results[node][name] = json.loads(proc.stdout)
            print(f"Finished {name} on {node}, sleeping for {WAIT_TIME}...")
            time.sleep(WAIT_TIME)  # TODO: Fix redundant wait period

    print("Writing results file")
    result_filename = f"results/{datetime.datetime.now()}.json"
    with open(result_filename, "w") as result_file:
        result_file.write(json.dumps(results, indent=2))

    print("Benchmark run complete")
    return result_filename


def compile_results(result_filename: str):
    print(f"Compiling results from {result_filename}")
    results = {}
    with open(result_filename, "r") as f:
        raw_results = json.loads(f.read())

    for node, benchmarks in raw_results.items():
        for benchmark, data in benchmarks.items():
            if benchmark not in results.keys():
                results[benchmark] = {}

            jobs = data["jobs"]
            results[benchmark][node] = {
                "iops": get_avg_value(jobs, "write", "iops"),
                "bandwidth": get_avg_value(jobs, "write", "bw_bytes") / 1024 / 1024,
                "io_written": get_avg_value(jobs, "write", "io_bytes") / 1024 / 1024
            }

    headers = ["node", "iops", "bandwidth", "io_written"]
    for benchmark, nodes in results.items():
        with open(f"{benchmark}.csv", "w") as f:
            datawriter = csv.writer(f, delimiter=",")
            datawriter.writerow(headers)
            for node, datapoints in nodes.items():
                datawriter.writerow([node, datapoints["iops"], datapoints["bandwidth"], datapoints["io_written"]])

    print("Done")


def get_avg_value(jobs: list[dict], operation: str, key: str) -> float:
    values = list(map(lambda x: x[operation][key], jobs))
    return sum(values) / len(values)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        result_filename = run_benchmarks()
    else:
        result_filename = sys.argv[1]
        print(f"Skipping benchmark, reading results from {result_filename}")

    compile_results(result_filename)
