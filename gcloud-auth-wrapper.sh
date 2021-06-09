#!/bin/sh
set -e

if [ ! -e ~/.kube/config ]; then

  [ -z "$PLUGIN_ZONE" ] && echo "Need to set 'zone'" && exit 1;
  [ -z "$PLUGIN_PROJECT" ] && echo "Need to set 'project'" && exit 1;
  [ -z "$PLUGIN_CLUSTER" ] && echo "Need to set 'cluster'" && exit 1;
  [ -z "$PLUGIN_GCP_CREDENTIALS" ] && echo "Need to set 'gcp_credentials'" && exit 1;

  echo "Generating K8s credentials..."

  /bin/echo -E ${PLUGIN_GCP_CREDENTIALS} > credentials.json
  gcloud auth activate-service-account --key-file=credentials.json
  gcloud container clusters get-credentials ${PLUGIN_CLUSTER} --project=${PLUGIN_PROJECT} --zone=${PLUGIN_ZONE}

  echo "... credentials written to ~/.kube/config"

  if [ -n "$PLUGIN_NAMESPACE" ]; then
    kubectl config set-context --current --namespace=${PLUGIN_NAMESPACE}
    echo "... namespace set to '${PLUGIN_NAMESPACE}."
  fi
fi

exec /usr/bin/kubectl.original "$@"
