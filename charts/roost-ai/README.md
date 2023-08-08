# Roost.ai
An End-to-End Testing platform using Generative AI.
## Roost.ai helm chart
This repository contains Helm Chart for roost-ai stack.

## Prerequisites
* [Helm](https://helm.sh) must be installed to use the charts. Please refer to Helm's [documentation](https://helm.sh/docs) to get started.
* Dynamic Volume Provisioning needs to be enabled in your cluster(for PV creation).
* Amazon EFS CSI driver (https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html) needs to be enabled for eks cluster.
* Follow this documentation (https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/docs/efs-create-filesystem.md) to configure efs with eks cluster to create valid mount points.
* FileStore csi driver needs to be enabled for gke cluster. <br />
## Roost Microservices
- approostio :- UI component to roost
- mysql :- local mysql DB (optional)
- nest-server :- roost-server
- roost-nginx :- for microservices routing
- release-server :- roost eaas backend
- ai-server :- roost gpt ai server
## Install Steps
* set and edit field of `values.yaml` according to the requirements.
* go to charts/ directory
```sh
helm upgrade roost-ai roost-ai --create-namespace --namespace roost-ai  --install 
```
NOTE:
helm upgrade [release-name] [roost-ai-chart-path] --create-namespace --namespace [ns] --install 
[release-name] and [ns] can be dynamic
roost-ai-chart-path would be relative path of roost-ai from current dir.
This installation requires having cluster administrative rights.

## Access
* You can add roost ai loadbalancer entry to route 53 domain entry.
* Roost UI can be accessed on http://$load_balancer_external_ip or https://$domain 
* Login and follow the documentaion to use roost features.
## Uninstall
```sh
helm uninstall roost-ai -n roost-ai 
kubectl delete namespace roost-ai
```