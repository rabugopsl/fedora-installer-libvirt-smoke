#!/usr/bin/env bash  
set -x

chmod 700 /root/.ssh
chmod 600 /root/.ssh/*

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
server=/openshiftdemo.org/192.168.124.1
EOF

cp /etc/resolv.conf{,.bkp}
cat <<EOF > /etc/resolv.conf
nameserver 127.0.0.1
EOF

dnsmasq

dnf install -y kubernetes-client

libvirtd -d --listen
virtlockd -d 
virtlogd -d

export PATH="${PATH}:/opt/app-root/src/installer/tectonic-dev/installer"

{
    tectonic init --config=/opt/app-root/src/tectonic_config/tectonic.libvirt.yaml
    tectonic install --dir=tectoniccluster

    ./installer/bazel-bin/tests/smoke/linux_amd64_pure_stripped/go_default_test -test.v --cluster 
} || /bin/bash -i

