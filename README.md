# Fedora libvirt environment for Smoke tests
Libvirt container to run installer smoke tests

## Building
Run `docker image build -t smoke-test-installer .`

## Running
Run `docker container --rm --net=host --privileged -it smoke-test-installer bash`

## Installing and Smoke testing
Within the container, run the following commands:
  1. `libvirtd -d && virtlockd -d && virtlogd -d`
  2. `tectonic install --dir=tectoniccluster`
  3. `./bazel-bin/tests/smoke/linux_amd64_pure_stripped/go_default_test`


## Status
  1. The installer completes without reporting errors. However, only the nodes `master0` and `bootstrap` are created.
  2. Running the smoke tests fails because of network timeout.
