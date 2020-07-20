FROM google/cloud-sdk:alpine

ENV KUSTOMIZE_VERSION 3.8.1
ENV KUBECTL_VERSION 1.17.9

ADD https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz /tmp/kustomize.tar.gz
RUN tar -C /tmp -xzf /tmp/kustomize.tar.gz \
  && mv /tmp/kustomize /usr/bin \
  && rm -f /tmp/kustomize*

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/bin/kubectl \
    && chmod +x /usr/bin/kubectl

RUN mv /usr/bin/kubectl /usr/bin/kubectl.orig
COPY ./gcloud-auth-wrapper.sh /usr/bin/kubectl
