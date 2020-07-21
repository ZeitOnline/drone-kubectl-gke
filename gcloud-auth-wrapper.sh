#!/bin/sh
set -e

if [ ! -e ~/.kube/config ]; then

  [ -z "$PLUGIN_ZONE" ] && echo "Need to set 'zone'" && exit 1;
  [ -z "$PLUGIN_PROJECT" ] && echo "Need to set 'project'" && exit 1;
  [ -z "$PLUGIN_CLUSTER" ] && echo "Need to set 'cluster'" && exit 1;
  [ -z "$PLUGIN_GCP_CREDENTIALS" ] && echo "Need to set 'gcp_credentials'" && exit 1;

  echo "Generating K8s credentials..."

  echo ${PLUGIN_GCP_CREDENTIALS} > credentials.json
  gcloud auth activate-service-account --key-file=credentials.json
  gcloud container clusters get-credentials ${PLUGIN_CLUSTER}
    
  echo "... credentials written to ~/.kube/config"
fi

exec /usr/bin/kubectl.original "$@"
