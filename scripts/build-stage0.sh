#!/usr/bin/env bash
set -xe

dnf install -y 'dnf-command(copr)'
dnf copr enable -y vbatts/bazel
dnf update -y
dnf install -y \
    deltarpm pki-ca \
    git gcc gcc-c++ libtool bazel golang \
    qemu-img libvirt libvirt-python libvirt-client libvirt-devel @virtualization \
    dnsmasq kubernetes-client

dnf clean all
rm -rf /var/cache/dnf/*
