#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: ./build.sh TAG"; exit
fi

IMAGE_NAME="registry.zeit.de/zon-drone-kubectl"

echo "Pushing docker image to registry tagged as $IMAGE_NAME:$1"
docker build -t $IMAGE_NAME:$1 .
docker push $IMAGE_NAME:$1
