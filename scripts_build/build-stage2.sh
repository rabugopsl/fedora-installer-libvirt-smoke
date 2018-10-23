#!/usr/bin/env bash
set -xe

REVISION=1

# GIT
mkdir /opt/app-root/bin
mkdir /opt/app-root/pkg

GOBIN=~/.terraform.d/plugins go get github.com/dmacvicar/terraform-provider-libvirt
