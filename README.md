# Drone.io plugin for kubectl and kustomize on GKE

Simple shell-based [Drone](https://www.drone.io/) plugin with kubectl and a configurable set of additional cloud-tools like kustomize and jsonnet.
The `gcloud` and `kubectl` commands are wrapped in a small script which generates K8s credentials on their first invocation.

For the available image tags see [DockerHub](https://hub.docker.com/r/zeitonline/drone-kubectl-gke/tags).

## Customization

The plugin tools are installed and versioned in `./Dockerfile`. There are examples for several tools with different installation methods.

## Usage

Use in Drone pipelines like this:

```yaml
steps:
- name: kubectl
  image: zeitonline/drone-kubectl-gke:2.11.0
  settings:
    gcp_credentials:
      from_secret: GCP_SERVICE_ACCOUNT
    project: my-gcp-project
    zone: europe-west3-a
    cluster: staging
    namespace: mynamespace
  commands:
    - kubectl get deployments
```
