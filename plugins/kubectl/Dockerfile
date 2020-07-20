FROM google/cloud-sdk:alpine

ENV KUSTOMIZE_VER 3.8.1
ENV KUBECTL_VER 1.17.9

RUN curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/v${KUSTOMIZE_VER}/kustomize_${KUSTOMIZE_VER}_linux_amd64  -o /usr/bin/kustomize \
    && chmod +x /usr/bin/kustomize

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VER}/bin/linux/amd64/kubectl -o /usr/bin/kubectl \
    && chmod +x /usr/bin/kubectl

RUN mv /usr/bin/kubectl /usr/bin/kubectl.orig
COPY ./gcloud-auth-wrapper.sh /usr/bin/kubectl
