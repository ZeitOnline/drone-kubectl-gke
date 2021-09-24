# Drone.io plugin for kubectl and kustomize on GKE

Simple shell-based Drone plugin with kubectl and a configurable set of additional cloud-tools like kustomize or jsonnet.
The `gcloud` and `kubectl` commands are wrapped in a small script which generates K8s credentials on their first invocation.

## Customization

The plugin tools are installed and versioned in `./Dockerfile`. There are examples for several tools with different installation methods.

## Usage

Use in Drone pipelines like this:

```yaml
steps:
- name: kubectl
  image: eu.gcr.io/zeitonline-210413/zon-drone-kubectl:2.9.1
  settings:
    gcp_credentials:
      from_secret: GCP_SERVICE_ACCOUNT
    project: zeitonline-main
    zone: europe-west3-a
    cluster: staging
    namespace: spiele
  commands:
    - kubectl get deployments
```
