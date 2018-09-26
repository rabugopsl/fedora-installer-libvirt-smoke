FROM fedora:28

WORKDIR /opt/app-root/src

COPY ./scripts/build-stage0.sh /scripts/
RUN /scripts/build-stage0.sh

COPY ./libvirt_config ./libvirt_config
COPY ./scripts/build-stage1.sh /scripts/
RUN /scripts/build-stage1.sh

COPY ./scripts/build-stage2.sh /scripts/
RUN /scripts/build-stage2.sh

ENV SMOKE_KUBECONFIG=/opt/app-root/src/tectoniccluster/generated/auth/kubeconfig
ENV SMOKE_NODE_COUNT=3
ENV SMOKE_MANIFEST_EXPERIMENTAL=true
ENV SMOKE_MANIFEST_PATHS=/opt/app-root/src/tectoniccluster/generated/manifests

COPY ./tectonic_config ./tectonic_config
COPY ./ssh /root/.ssh
COPY ./scripts/cmd.sh /scripts/
CMD [ "/scripts/cmd.sh" ]
