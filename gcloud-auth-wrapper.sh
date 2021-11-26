#!/bin/sh
set -e

command="$(basename -- $0)"
creds_dir=$(mktemp -d --tmpdir=/dev/shm)

# Write credentials to a location outside the Drone workspace to
# avoid collisions when steps run in parallel
export kubeconfig="${creds_dir}/.kube/config"
export cloudsdk_config="${creds_dir}/gcloud/"

case $command in
  # List of commands that need Kubernetes authentication
  kubectl|kubecfg|linkerd) cmd_needs_kube_auth=true;;
  # List of commands that need GCP authentication
  gcloud|gsutil) cmd_needs_gcp_auth=true;;
esac

if [ "$cmd_needs_kube_auth" = true -o $cmd_needs_gcp_auth = true ] && [ ! -e $cloudsdk_config ]; then

  [ -z "$PLUGIN_ZONE" ]            && echo "Missing plugin setting 'zone'" && exit 1;
  [ -z "$PLUGIN_PROJECT" ]         && echo "Missing plugin setting 'project'" && exit 1;
  [ -z "$PLUGIN_CLUSTER" ]         && echo "Missing plugin setting 'cluster'" && exit 1;
  [ -z "$PLUGIN_GCP_CREDENTIALS" ] && echo "Missing plugin setting 'gcp_credentials'" && exit 1;

  echo "Activating GCP service account..."

  # Use standalone 'echo' to be able to suppress backslash-escape interpretation
  /bin/echo -E ${PLUGIN_GCP_CREDENTIALS} > ${creds_dir}/credentials.json
  
  /usr/bin/gcloud.original auth activate-service-account --key-file=${creds_dir}/credentials.json
fi

if [ "$cmd_needs_kube_auth" = true] && [ ! -e $kubeconfig ]; then

  echo "Writing k8s credentials to ${kubeconfig}..."

  /usr/bin/gcloud.original container clusters get-credentials ${PLUGIN_CLUSTER} --project=${PLUGIN_PROJECT} --zone=${PLUGIN_ZONE}

  if [ -n "$PLUGIN_NAMESPACE" ]; then
    echo "Setting namespace of k8s context to '${PLUGIN_NAMESPACE}'..."

    kubectl.original config set-context --current --namespace=${PLUGIN_NAMESPACE}
  fi
fi

# ArgoCD Token Environment variable
if [ "$command" = "argocd" ]; then
  [ -z "$PLUGIN_ARGOCD_TOKEN" ]  && echo "Missing plugin setting 'argocd_token'" && exit 1;
  [ -z "$PLUGIN_ARGOCD_SERVER" ] && echo "Missing plugin setting 'argocd_server'" && exit 1;
  
  export ARGOCD_AUTH_TOKEN="${PLUGIN_ARGOCD_TOKEN}"
  export ARGOCD_SERVER="${PLUGIN_ARGOCD_SERVER}"
fi

exec $0.original "$@"
