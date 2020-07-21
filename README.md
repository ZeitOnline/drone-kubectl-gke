# Drone.io plugin for kubectl and kustomize on GKE

This is a basic drone plugin with kubectl and kustomize for
deployment steps to GKE. kubectl is wrapped in a small script
which generates k8s credentials on the first invocation.

Use like this:

```yaml
steps:
- name: kubectl
  image: eu.gcr.io/zeitonline-210413/zon-drone-kubectl:2.7.2
  settings:
    gcp_credentials:
      from_secret: GCP_SERVICE_ACCOUNT
    project: zeitonline-main
    zone: europe-west3-a
    cluster: staging
  commands:
    - kubectl -n spiele get deployments
```
