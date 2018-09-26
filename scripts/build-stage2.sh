#!/usr/bin/env bash  
set -xe

REVISION=1

export PATH="${PATH}:/opt/app-root/src/installer/tectonic-dev/installer"

git clone --depth=1 --branch=master https://github.com/openshift/installer.git
pushd installer && bazel build tarball && bazel build smoke_tests
tar -zxf bazel-bin/tectonic-dev.tar.gz

GOBIN=~/.terraform.d/plugins go get github.com/dmacvicar/terraform-provider-libvirt
