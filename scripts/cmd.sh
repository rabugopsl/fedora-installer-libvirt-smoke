#!/usr/bin/env bash
set -x

chmod 700 /root/.ssh
chmod 600 /root/.ssh/*
source "${HOME}/.bash_profile"

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
 server=/tt.testing/192.168.126.1
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
