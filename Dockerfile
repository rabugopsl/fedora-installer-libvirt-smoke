FROM fedora

WORKDIR /opt/app-root/src


COPY ./libvirt_config ./libvirt_config
COPY ./tectonic_config ./tectonic_config
COPY ./qemu-img ./qemu-img


ENV PATH="${PATH}:/opt/app-root/src/installer/tectonic-dev/installer"
ENV SMOKE_KUBECONFIG=/opt/app-root/src/tectoniccluster/generated/auth/kubeconfig
ENV SMOKE_NODE_COUNT=3
ENV SMOKE_MANIFEST_EXPERIMENTAL=true
ENV SMOKE_MANIFEST_PATHS=/opt/app-root/src/tectoniccluster/generated/manifests

#docker container run --rm --privileged --net=bridge -it smoke-test-installer bash
#docker image rm smoke-test-installer $(docker image ls -a | grep '^<none>' | awk '{print $3}')
#docker image build -t smoke-test-installer .
#libvirtd -d -f /etc/libvirt/libvirtd.conf && virtlogd -d && virtlockd -d
#iptables -I INPUT -p tcp -s 192.168.124.0/24 -d 192.168.122.1 --dport 16509 -j ACCEPT -m comment --comment "Allow insecure libvirt clients"

RUN dnf update -y && \
      dnf install -y deltarpm && dnf install -y git wget gcc gcc-c++ libtool && \
      dnf install -y golang && \
      dnf install -y @virtualization && \
      dnf install -y qemu-img libvirt libvirt-python libvirt-client && \
      dnf install -y libvirt-devel && \
      echo ' polkit.addRule(function(action, subject) { if (action.id == "org.libvirt.unix.manage" && subject.local && subject.active && subject.isInGroup("wheel")) { return polkit.Result.YES; } }); }' >> /etc/polkit-1/rules.d/80-libvirt.rules && \
      echo "plugin_cache_dir = ${HOME}/.terraform.d/plugin-cache" > $HOME/.terraformrc && \
      dnf install -y 'dnf-command(copr)' && \
      dnf copr enable -y vbatts/bazel && \
      dnf install -y bazel && \
      sed -i 's/#user = "root"/user = "root"/' /etc/libvirt/qemu.conf && \
      sed -i 's/#group = "root"/group = "root"/' /etc/libvirt/qemu.conf && \
      sed -i 's/#listen_tls = 0/listen_tls = 0/' /etc/libvirt/libvirtd.conf && \
      sed -i 's/#listen_tcp = 1/listen_tcp = 1/' /etc/libvirt/libvirtd.conf && \
      sed -i 's/#tcp_port = "16509"/tcp_port = "16509"/' /etc/libvirt/libvirtd.conf && \
      sed -i 's/#auth_tcp = "sasl"/auth_tcp = "none"/' /etc/libvirt/libvirtd.conf && \
      sed -i 's%#LIBVIRTD_CONFIG=/etc/libvirt/libvirtd.conf%LIBVIRTD_CONFIG=/etc/libvirt/libvirtd.conf%' /etc/sysconfig/libvirtd && \
      sed -i 's/#LIBVIRTD_ARGS="--listen"/LIBVIRTD_ARGS="--listen"/' /etc/sysconfig/libvirtd && \
      mkdir /etc/NetworkManager/dnsmasq.d && \
      echo '[main]' >> /etc/NetworkManager/NetworkManager.conf && \
      echo 'dns=dnsmasq' >> /etc/NetworkManager/NetworkManager.conf && \
      echo server=/testing/192.168.124.1 | tee /etc/NetworkManager/dnsmasq.d/tectonic.conf && \
      echo 'wget http://aos-ostree.rhev-ci-vms.eng.rdu2.redhat.com/rhcos/images/cloud/latest/rhcos-qemu.qcow2.gz'> /dev/null && \
      echo "bunzip2 rhcos-qemu.qcow2.gz" > /dev/null && \
      echo 'qemu-img resize /opt/app-root/src/qemu-img/coreos_production_qemu_image.img +8G' && \
      GOBIN=~/.terraform.d/plugins go get github.com/dmacvicar/terraform-provider-libvirt && \
      git clone https://github.com/openshift/installer.git && \
      cd installer && bazel build tarball && bazel build smoke_tests && \
      tar -zxf bazel-bin/tectonic-dev.tar.gz && \
      cd /opt/app-root/src && \
      tectonic init --config=/opt/app-root/src/tectonic_config/tectonic.libvirt.yaml && \
      libvirtd -d && virsh --connect qemu:///system pool-create --file=/opt/app-root/src/libvirt_config/libvirt-storage-pool.xml
