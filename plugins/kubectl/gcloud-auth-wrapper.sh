#!/bin/bash
set -e

if [ ! -e ~/.kube/config ]; then

    if [ ! -z "$PLUGIN_ZONE" ]; then
      export CLOUDSDK_COMPUTE_ZONE=${PLUGIN_ZONE}
    fi

    if [ ! -z "$PLUGIN_PROJECT" ]; then
      export CLOUDSDK_CORE_PROJECT=${PLUGIN_PROJECT}
    fi

    echo "Generating K8s credentials..."

    echo ${PLUGIN_GCP_CREDENTIALS} > credentials.json
    gcloud auth activate-service-account --key-file=credentials.json
    gcloud container clusters get-credentials ${PLUGIN_CLUSTER}
    
    echo "done."
fi

exec /usr/bin/kubectl.orig "$@"
