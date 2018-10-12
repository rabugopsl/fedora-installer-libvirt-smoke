#!/usr/bin/env bash
set -x

chmod 700 /root/.ssh
chmod 600 /root/.ssh/*

# DNSMASQ setup
cat <<EOF > /etc/dnsmasq.conf
bind-interfaces
interface=lo
strict-order
user=root
domain-needed
bogus-priv
filterwin2k
localise-queries
no-negcache
no-resolv
$(grep -oE 'nameserver.*' /etc/resolv.conf | sed -E 's/^nameserver (.*)/server=\1/')
# server=$(ip route get 1.1.1.1 | grep -oE 'via ([^ ]+)' | sed -E 's/via //')
 server=/tt.testing/192.168.124.1
EOF

cp /etc/resolv.conf{,.bkp}
cat <<EOF > /etc/resolv.conf
nameserver 127.0.0.1
EOF

dnsmasq

# Start LIBVIRT
libvirtd -d --listen -f /etc/libvirt/libvirtd.conf
virtlockd -d
virtlogd -d

# Run INSTALLER
export GOBIN='/opt/app-root/bin'
export OPENSHIFT_INSTALL_BASE_DOMAIN=tt.testing
export OPENSHIFT_INSTALL_CLUSTER_NAME=test1
export OPENSHIFT_INSTALL_EMAIL_ADDRESS=admin@openshiftdemo.org
export OPENSHIFT_INSTALL_PASSWORD=verysecure
export OPENSHIFT_INSTALL_PLATFORM=libvirt
export OPENSHIFT_INSTALL_PULL_SECRET="{\"auths\": {\"quay.io\": {\"auth\": \"Y29yZW9zK3RlYzJfaWZidWdsandoYTNkaW4yYmlqY2MybjJlaTpLMVNEQjNVWTlHMUZQUFpKTFg5VTFOWlJIQjRURjA1WllEOTZBMjdSWTRYRVcwSVVKVkxWRFZFSDFDSlZNQlNS\", \"email\": \"\" }}}"
export OPENSHIFT_INSTALL_SSH_PUB_KEY="$(cat /root/.ssh/id_rsa.pub)"
export OPENSHIFT_INSTALL_LIBVIRT_URI=qemu+tcp://192.168.122.1/system
#export OPENSHIFT_INSTALL_LIBVIRT_IMAGE=http://aos-ostree.rhev-ci-vms.eng.rdu2.redhat.com/rhcos/images/cloud/latest/rhcos-qemu.qcow2.gz
export OPENSHIFT_INSTALL_LIBVIRT_IMAGE=file:///opt/app-root/src/qemu-img/rhcos-qemu.qcow2

export KUBECONFIG=/opt/app-root/src/github.com/openshift/installer/auth/kubeconfig

{
    cd /opt/app-root/src/github.com/openshift || exit 1
    git clone https://github.com/openshift/installer.git

    cd /opt/app-root/src/github.com/openshift/installer || exit 1
    ./hack/build.sh
    ./bin/openshift-install cluster
    sleep 60s
    BOOTSTRAPIP=$(virsh --connect qemu+tcp://192.168.122.1/system domifaddr bootstrap | awk '/192/{print $4}')
    if [ -z "$BOOTSTRAPIP" ]; then
        exit 1
    fi
    BOOTSTRAPIP=${BOOTSTRAPIP::${#BOOTSTRAPIP}-3}
    eval $(ssh-agent -s) && ssh-add ${HOME}/.ssh/id_rsa
    ssh -oStrictHostKeyChecking=no core@${BOOTSTRAPIP} sudo journalctl -fu bootkube -u tectonic
} || /bin/bash -i
