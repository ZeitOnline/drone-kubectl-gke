FROM google/cloud-sdk:alpine

ENV KUBECTL_VERSION 1.17.9
ENV KUSTOMIZE_VERSION 3.8.1

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/bin/kubectl \
  && chmod +x /usr/bin/kubectl

ADD https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz /tmp/kustomize.tar.gz
RUN tar -C /tmp -xzf /tmp/kustomize.tar.gz \
  && mv /tmp/kustomize /usr/bin \
  && rm -f /tmp/kustomize*

RUN mv /usr/bin/kubectl /usr/bin/kubectl.original
COPY ./gcloud-auth-wrapper.sh /usr/bin/kubectl
