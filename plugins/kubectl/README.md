# Drone.io plugin for kubectl and kustomize

This is a basic drone plugin with kubectl and kustomize for k8s deployment steps.
kubectl is wrapped in our gcloud auth wrapper which generates k8s credentials.

Use like this:

```yaml
steps:
- name: kubectl
  image: registry.zeit.de/zon-drone-kubectl:1.2.0
  settings:
    gcp_credentials:
      from_secret: GCP_SERVICE_ACCOUNT
    project: zeitonline-main
    zone: europe-west3-a
    cluster: staging
  commands:
    - kubectl -n spiele get deployments
```
