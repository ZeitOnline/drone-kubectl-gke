FROM google/cloud-sdk:slim

ENV KUBECTL_VERSION 1.18.18
ENV KUSTOMIZE_VERSION 4.1.3
ENV JSONNET_VERSION 0.17.0
ENV JSONNET_BUNDLER_VERSION 0.4.0
ENV KUBECFG_VERSION 0.20.0

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/bin/kubectl \
  && chmod +x /usr/bin/kubectl

ADD https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz /tmp/kustomize.tar.gz
RUN tar -C /tmp -xzf /tmp/kustomize.tar.gz \
  && mv /tmp/kustomize /usr/bin \
  && rm -f /tmp/kustomize*

RUN mkdir jsonnetdownload && cd jsonnetdownload && curl -fSL -o jsonnet.tar.gz https://github.com/google/jsonnet/releases/download/v${JSONNET_VERSION}/jsonnet-bin-v${JSONNET_VERSION}-linux.tar.gz && \
    tar xzf jsonnet.tar.gz && \
    mv jsonnet /usr/bin && \
    mv jsonnetfmt /usr/bin && \
    cd .. && \
    rm -rf jsonnetdownload

RUN curl -L https://github.com/bitnami/kubecfg/releases/download/v${KUBECFG_VERSION}/kubecfg-linux-amd64 -o /usr/bin/kubecfg \
  && chmod +x /usr/bin/kubecfg

RUN curl -fSL -o "/usr/bin/jb" "https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/v${JSONNET_BUNDLER_VERSION}/jb-linux-amd64" && chmod a+x "/usr/bin/jb"


RUN mv /usr/bin/kubectl /usr/bin/kubectl.original
COPY ./gcloud-auth-wrapper.sh /usr/bin/kubectl
