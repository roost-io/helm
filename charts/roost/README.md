# Roost.ai

An End-to-End Testing platform using Generative AI.

## Roost.ai helm chart

This repository contains Helm Chart for roost-ai stack.

## Prerequisites

- [Helm](https://helm.sh) must be installed to use the charts. Please refer to
  Helm's [documentation](https://helm.sh/docs) to get started.
- Dynamic Volume Provisioning needs to be enabled in your cluster(for PV
  creation).
- Amazon EFS CSI driver
  (https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html) needs to be
  enabled for eks cluster.
- Follow this documentation
  (https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/docs/efs-create-filesystem.md)
  to configure efs with eks cluster to create valid mount points.
- FileStore csi driver needs to be enabled for gke cluster.
- azurefile-csi needs to be enabled for aks cluster.<br />

## Roost Microservices
<img width="1116" alt="image" src="https://github.com/user-attachments/assets/7f8fdbd9-b623-4f62-91ee-cd137d77215c">

- roost-web :- UI component to roost
- roost-mysql-db :- local mysql DB (optional)
- roost-postgres-db :- local postgres DB (optional)
- roost-app :- roost api server
- roost-nginx :- for microservices routing
- roost-eaas :- roost-eaas backend
- roost-ai-server :- roost-gpt ai server
- roost-launcher :- roost cluster launcher
- roost-jump :- roost jumphost for managed cluster

## Install Steps

- add the roostai repo as follows:

```sh
helm repo add roostai https://roost-io.github.io/helm/releases
```

If you had already added this repo earlier, run helm repo update to retrieve the
latest versions of the packages. You can then run helm search repo roostai to
see the charts.

- set and edit field of `values.yaml` according to the requirements.

```sh
helm upgrade roostai roostai/roost --create-namespace --namespace roost-ai --install --values values.yaml
```

NOTE: helm upgrade [release-name] [roost-ai-chart-path] --create-namespace
--namespace [ns] --install [release-name] and [ns] can be dynamic This
installation requires having cluster administrative rights.

## Access

- In case of eks cluster, you need to add roostai loadbalancer entry to route 53
  domain entry.
- Roost UI can be accessed on
  http://$load_balancer_external_ip or https://$domain
- Login and follow the documentaion to use roost features.

## Uninstall

```sh
helm uninstall roostai -n roost-ai
kubectl delete namespace roost-ai
```

## Using EFS on EKS cluster

Based on this doc https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html

1. Create eks cluster - use myAmazonEKSClusterRole
2. Add nodegroups - use myAmazonEKSNodeRole
3. Make sure node(s) IAM role has AmazonEBSCSIDriverPolicy attached
4. Install add-ons - Amazon EFS CSI Driver - Inherit node IAM role
5. Create EFS and get its File System ID

   1. Using console

   - Create new EFS by selecting same VPC as eks cluster
   - Create security group that allows inbound NFS traffic (port 2049)
   - Go to EFS -> Network -> Manage. Add the created security group to all
     subnets.

   2. Using CLI - follow this doc \
      https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/docs/efs-create-filesystem.md

6. Now, enable efs in values.yaml and specify the File System ID

## Using GCP File storage with gke

1. Create cluster
2. Enable the Cloud Filestore API and the Google Kubernetes Engine API.
3. Features -> Enable Filestore CSI driver -> Select Checkbox

## Using azure key vault certificate with aks

1. Create aks cluster.
2. Enable Web Application Routing and Azure Key Vault Secret Provider add-on (https://learn.microsoft.com/en-us/azure/aks/app-routing)
```sh
az extension add --name aks-preview
az aks enable-addons -g [ResourceGroupName] -n [ClusterName] --addons azure-keyvault-secrets-provider,web_application_routing --enable-secret-rotation
```
3. Ensure that key vault's Access policy have Get Permission for both Secret and Certificate for that kubernetes RBAC/object-principal-id.
4. Enabled azure certs and specify certificate identifier in values.yaml.

NOTE: Alternatively azure console ui can be used to create ingress for roost-nginx-svc.
