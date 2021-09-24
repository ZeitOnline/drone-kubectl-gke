#!/bin/sh
set -e

b="$(basename -- $0)"

export KUBECONFIG="/tmp/.kube/config"

if [ "$b" = "kubectl" ] && [ ! -e ~/.kube/config ] || [ ! -e ~/.config/gcloud/application_default_credentials.json ]; then

  [ -z "$PLUGIN_ZONE" ] && echo "Need to set 'zone'" && exit 1;
  [ -z "$PLUGIN_PROJECT" ] && echo "Need to set 'project'" && exit 1;
  [ -z "$PLUGIN_CLUSTER" ] && echo "Need to set 'cluster'" && exit 1;
  [ -z "$PLUGIN_GCP_CREDENTIALS" ] && echo "Need to set 'gcp_credentials'" && exit 1;

  echo "Generating K8s credentials..."

  # Use standalone 'echo' to be able to suppress backslash-escape interpretation
  /bin/echo -E ${PLUGIN_GCP_CREDENTIALS} > /tmp/credentials.json
  
  /usr/bin/gcloud.original auth activate-service-account --key-file=/tmp/credentials.json

  if [ "$b" = "kubectl" ]; then
    /usr/bin/gcloud.original container clusters get-credentials ${PLUGIN_CLUSTER} --project=${PLUGIN_PROJECT} --zone=${PLUGIN_ZONE}

    echo "... credentials written to ${KUBECONFIG}"

    if [ -n "$PLUGIN_NAMESPACE" ]; then
      kubectl config set-context --current --namespace=${PLUGIN_NAMESPACE}
      echo "... namespace set to '${PLUGIN_NAMESPACE}'."
    fi
  fi
fi

exec $0.original "$@"
