#!/bin/sh
set -e

command="$(basename -- $0)"
creds_dir=$(mktemp -d --tmpdir=/dev/shm)

# Write credentials to a location outside the Drone workspace to
# avoid collisions when steps run in parallel
export KUBECONFIG="${creds_dir}/.kube/config"
export CLOUDSDK_CONFIG="${creds_dir}/gcloud/"

if [ ! -e $CLOUDSDK_CONFIG ]; then

  [ -z "$PLUGIN_ZONE" ] && echo "Need to set 'zone'" && exit 1;
  [ -z "$PLUGIN_PROJECT" ] && echo "Need to set 'project'" && exit 1;
  [ -z "$PLUGIN_CLUSTER" ] && echo "Need to set 'cluster'" && exit 1;
  [ -z "$PLUGIN_GCP_CREDENTIALS" ] && echo "Need to set 'gcp_credentials'" && exit 1;

  echo "Activating GCP service account..."

  # Use standalone 'echo' to be able to suppress backslash-escape interpretation
  /bin/echo -E ${PLUGIN_GCP_CREDENTIALS} > ${creds_dir}/credentials.json
  
  /usr/bin/gcloud.original auth activate-service-account --key-file=${creds_dir}/credentials.json
fi

if [ $command = "kubectl" || $command = "linkerd" ] && [ ! -e $KUBECONFIG ]; then
  echo "Writing k8s credentials to ${KUBECONFIG}..."

  /usr/bin/gcloud.original container clusters get-credentials ${PLUGIN_CLUSTER} --project=${PLUGIN_PROJECT} --zone=${PLUGIN_ZONE}

  if [ -n "$PLUGIN_NAMESPACE" ]; then
    echo "Setting namespace of k8s context to '${PLUGIN_NAMESPACE}'..."

    kubectl.original config set-context --current --namespace=${PLUGIN_NAMESPACE}
  fi
fi

exec $0.original "$@"
