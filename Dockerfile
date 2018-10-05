FROM fedora:28

WORKDIR /opt/app-root/src

VOLUME /opt/app-root/src/qemu-img

COPY ./scripts/build-stage0.sh /scripts/
RUN /scripts/build-stage0.sh

COPY ./libvirt_config ./libvirt_config
COPY ./scripts/build-stage1.sh /scripts/
RUN /scripts/build-stage1.sh

COPY ./scripts/build-stage2.sh /scripts/
RUN /scripts/build-stage2.sh

ENV GOPATH=/opt/app-root
ENV GOBIN=/opt/app-root/bin

#ENV SMOKE_KUBECONFIG=/opt/app-root/src/tectoniccluster/generated/auth/kubeconfig
#ENV SMOKE_NODE_COUNT=3
#ENV SMOKE_MANIFEST_EXPERIMENTAL=true
#ENV SMOKE_MANIFEST_PATHS=/opt/app-root/src/tectoniccluster/generated/manifests

#COPY ./tectonic_config ./tectonic_config
COPY ./ssh /root/.ssh
COPY ./scripts/cmd.sh /scripts/
#COPY ./qemu-img ./qemu-img
CMD [ "/scripts/cmd.sh" ]

