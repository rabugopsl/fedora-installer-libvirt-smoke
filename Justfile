# This file can be used with `just` (https://github.com/casey/just)
 
TAG = 'smoke-test-installer'
NET = 'bridge'
QEMU_IMG_PATH_RHCOS = "/opt/app-root/src/qemu-img/rhcos-qemu.qcow2"

build:
	# TODO: automate ssh key generation
	docker image build -t {{TAG}} .

run: build
	#!/usr/bin/env bash
	docker run --name {{TAG}} --net={{NET}} --privileged --rm -it \
		--volume "${PWD}"/ignore/rhcos-qemu.qcow2:{{QEMU_IMG_PATH_RHCOS}}:ro \
		{{TAG}} 

exec +args='/bin/bash':
	docker exec -it smoke-test-installer {{args}}

cleanup:
	docker image rm {{TAG}} $(docker image ls -a | grep '^<none>' | awk '{print $3}')
