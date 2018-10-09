FROM fedora:28

WORKDIR /opt/app-root/src

VOLUME /opt/app-root/src/qemu-img

ENV GOPATH=/opt/app-root
ENV GOBIN=/opt/app-root/bin

COPY ./ssh /root/.ssh
COPY ./scripts /scripts
COPY ./libvirt_config ./libvirt_config

RUN /scripts/build-stage0.sh 
RUN /scripts/build-stage1.sh 
RUN /scripts/build-stage2.sh

CMD [ "/scripts/cmd.sh" ]

