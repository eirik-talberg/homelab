# Taldev Homelab

This project contains all my configurations, scripts and setup (almost, where possible) for my Homelab. See below for
details.

This is intended as a knowledge and learning repository, for me and others, while I setup my homelab for running
different kinds of workloads and applications.

## What's where?

| Directory                    | Description                                              |
|------------------------------|----------------------------------------------------------|
| [ansible](ansible)           | Root folder for ansible playbooks, roles and inventories |
| [benchmarking](benchmarking) | Benchmarks with results for different kinds of workloads |
| [k8s](k8s)                   | Root folder for Kubernetes configurations                |
| [tfmodules](tfmodules)       | Reusable Terraform modules for different configurations  |
| [docs](docs)                 | Diagrams, resources and stuff for the documentation      |

## Tools

I use a few different tools for managing my setup, depending on the use and its suitability.

| Name      | Version | Use case                                                                                    |
|-----------|--------:|---------------------------------------------------------------------------------------------|
| Python    |    3.10 | Some scripts, and core interpreter for Ansible                                              |
| Poetry    |     1.5 | Dependency management for Python, useful to separate and control libraries and requirements |
| Ansible   |     8.2 | Software and configuration automation on physical and virtual nodes in the lab              |
| Terraform |     1.5 | Orchestration automation for virtual nodes through the Proxmox Virtual Environment (PVE)    |
| Bash      |     N/A | Misc scripts and stuff                                                                      |

## Hardware

This diagram shows the physical nodes in the lab.
![Physical hardware](/docs/hardware.drawio.svg)

### Networking

| Name      | Product           |
|-----------|-------------------|
| pfSense   | NetGate SG-1100   |
| switch-01 | ZyXel XGS1250-12  |
| ap-01     | Ubiquity UniFi HD | 

### Server(s)

| Name   | Role       | OS           | CPU             | RAM  | SSDs                          | HDDs                          |
|--------|------------|--------------|-----------------|------|-------------------------------|-------------------------------|
| dis    | NAS        | UnRaid 6.12  | AMD Ryzen 5600  | 32GB | 1x256GB (Cache)               | 1x6TB (Parity), 3x4TB Storage |
| pve-01 | Hypervisor | Proxmox VE 8 | AMD Ryzen 5800X | 64GB | 2x256GB (OS), 2x1TB (Storage) | N/A                           |

## Software

Target software architecture will go here.

### Kubernetes

#### Sandbox

#### Prod

## Other stuff

