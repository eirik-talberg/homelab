# Proxmox (PVE) disk I/O benchmarks

See the article on my blog for details: https://eirik-talberg.github.io/homelab/2023/09/14/kvm-disk-benchmarks.html

**Disclaimer:** These settings and configurations and not necessarily best practice and production-ready. This is a homelab for messing around.

## Setup
``create.sh`` Uses Ansible and Terraform to set up the required environment.

## Running the benchmark
``run.py`` can be used to run the benchmark itself. It assumes SSH keys being copied and configured for each node. 