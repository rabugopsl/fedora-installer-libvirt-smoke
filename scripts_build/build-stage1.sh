#!/usr/bin/env bash
set -xe

# LIBVIRT
cat <<EOF >> /etc/polkit-1/rules.d/80-libvirt.rules
polkit.addRule(function(action, subject) {
  if (action.id == "org.libvirt.unix.manage" && subject.local && subject.active && subject.isInGroup("wheel")) {
      return polkit.Result.YES;
  }
});
EOF

sed -i 's/#user = "root"/user = "root"/; s/#group = "root"/group = "root"/' /etc/libvirt/qemu.conf

cat <<EOF >>/etc/libvirt/libvirtd.conf
listen_tls = 0
listen_tcp = 1
auth_tcp="none"
tcp_port = "16509"
log_level = 4
EOF

cat <<EOF >>/etc/sysconfig/libvirtd
LIBVIRTD_ARGS="--listen"
EOF

libvirtd -d
virsh --connect qemu:///system pool-create --file=/opt/app-root/src/libvirt_config/libvirt-storage-pool.xml

# TERRAFORM
cat <<EOF > "${HOME}/.terraformrc"
plugin_cache_dir = "${HOME}/.terraform.d/plugin-cache"
EOF

# INSTALLER 
cat <<EOF >>"${HOME}/.bash_profile"
export GOBIN='/opt/app-root/bin'
export OPENSHIFT_INSTALL_BASE_DOMAIN=tt.testing
export OPENSHIFT_INSTALL_CLUSTER_NAME=test1
export OPENSHIFT_INSTALL_EMAIL_ADDRESS=admin@openshiftdemo.org
export OPENSHIFT_INSTALL_PASSWORD=verysecure
export OPENSHIFT_INSTALL_PLATFORM=libvirt
export OPENSHIFT_INSTALL_PULL_SECRET='{"auths": {"quay.io": {"auth": "Y29yZW9zK3RlYzJfaWZidWdsandoYTNkaW4yYmlqY2MybjJlaTpLMVNEQjNVWTlHMUZQUFpKTFg5VTFOWlJIQjRURjA1WllEOTZBMjdSWTRYRVcwSVVKVkxWRFZFSDFDSlZNQlNS", "email": "" }}}'
export OPENSHIFT_INSTALL_SSH_PUB_KEY="$(cat /root/.ssh/id_rsa.pub)"
export OPENSHIFT_INSTALL_LIBVIRT_URI=qemu+tcp://192.168.122.1/system
#export OPENSHIFT_INSTALL_LIBVIRT_IMAGE=http://aos-ostree.rhev-ci-vms.eng.rdu2.redhat.com/rhcos/images/cloud/latest/rhcos-qemu.qcow2.gz
export OPENSHIFT_INSTALL_LIBVIRT_IMAGE=file:///opt/app-root/src/qemu-img/rhcos-qemu.qcow2 
export KUBECONFIG=/opt/app-root/src/github.com/openshift/installer/auth/kubeconfig
EOF
