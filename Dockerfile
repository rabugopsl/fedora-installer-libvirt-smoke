FROM fedora

WORKDIR /opt/app-root/src

COPY ./libvirt_config ./libvirt_config
COPY ./tectonic_config ./tectonic_config
COPY ./qemu-img ./qemu-img

ENV PATH="${PATH}:/opt/app-root/src/installer/tectonic-dev/installer"

RUN dnf update -y && \
      dnf install -y deltarpm && dnf install -y git wget gcc gcc-c++ libtool && \
      dnf install -y golang && \
      dnf install -y @virtualization && \
      dnf install -y qemu-img libvirt libvirt-python libvirt-client && \
      dnf install -y libvirt-devel && \
      echo ' polkit.addRule(function(action, subject) { if (action.id == "org.libvirt.unix.manage" && subject.local && subject.active && subject.isInGroup("wheel")) { return polkit.Result.YES; } }); }' >> /etc/polkit-1/rules.d/80-libvirt.rules && \
      echo "plugin_cache_dir = ${HOME}/.terraform.d/plugin-cache" > $HOME/.terraformrc && \
      echo 'wget -O /etc/yum.repos.d/vbatts-bazel-epel-7.repo https://copr.fedorainfracloud.org/coprs/vbatts/bazel/repo/epel-7/vbatts-bazel-epel-7.repo' && \
      sed -i 's/#user = "root"/user = "root"/' /etc/libvirt/qemu.conf && \
      sed -i 's/#group = "root"/group = "root"/' /etc/libvirt/qemu.conf && \
      echo 'listen_tls = 0' >> /etc/libvirt/libvirt.conf && \
      echo 'listen_tcp = 1' >> /etc/libvirt/libvirt.conf && \
      echo 'auth_tcp="none"' >> /etc/libvirt/libvirt.conf && \
      echo 'tcp_port = "16509"' >> /etc/libvirt/libvirt.conf && \
      echo 'LIBVIRTD_ARGS="--listen"' >> /etc/sysconfig/libvirtd && \
      dnf install -y 'dnf-command(copr)' && \
      dnf copr enable -y vbatts/bazel && \
      dnf install -y bazel && \
      echo "wget https://stable.release.core-os.net/amd64-usr/current/coreos_production_qemu_image.img.bz2" > /dev/null && \
      echo "bunzip2 coreos_production_qemu_image.img.bz2" > /dev/null && \
      echo "qemu-img resize coreos_production_qemu_image.img +8G" > /dev/null && \
      qemu-img resize /opt/app-root/src/qemu-img/coreos_production_qemu_image.img +8G && \
      GOBIN=~/.terraform.d/plugins go get github.com/dmacvicar/terraform-provider-libvirt && \
      git clone https://github.com/openshift/installer.git && \
      cd installer && bazel build tarball && \
      tar -zxf bazel-bin/tectonic-dev.tar.gz && \
      libvirtd -d && virsh --connect qemu:///system pool-create --file=/opt/app-root/src/libvirt_config/libvirt-storage-pool.xml
