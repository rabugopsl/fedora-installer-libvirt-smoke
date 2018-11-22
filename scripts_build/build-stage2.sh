#!/usr/bin/env bash
set -xe

export REVISION=1

# GIT
mkdir /opt/app-root/bin
mkdir /opt/app-root/pkg

# Terraform plugin
GOBIN=~/.terraform.d/plugins go get github.com/dmacvicar/terraform-provider-libvirt

# GINKGO
go get -u github.com/onsi/ginkgo/ginkgo
go get -u github.com/onsi/gomega/...
