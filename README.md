# Windows Daemon Configuration

This project contains the configuration files for DaemonSet and Pod running in Windows environment, suitable for Windows nodes in Kubernetes cluster.

## windows-daemonset-configmap.yaml

This file contains the configuration for DaemonSet that runs on Windows nodes in Kubernetes cluster. The DaemonSet runs a Pod that mounts the ConfigMap volume and run the script `cronjob.ps1` to configure the Windows node.

![](images/windows-daemonset.png)

## AKS Overprovisioning

- [Azure Kubernetes Service (AKS): How to over-provision node pools][1]

[1]: https://pixelrobots.co.uk/2021/03/aks-how-to-over-provision-node-pools/
