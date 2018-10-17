# This file can be used with `just` (https://github.com/casey/just)
 
TAG = 'smoke-test-installer'
NET = 'bridge'
QEMU_IMG_PATH_RHCOS = "/opt/app-root/src/qemu-img/rhcos-qemu.qcow2"

dl-rhcos src='http://aos-ostree.rhev-ci-vms.eng.rdu2.redhat.com/rhcos/images/cloud/latest/rhcos-qemu.qcow2.gz' outputfile='rhcos-qemu.qcow2':
	#!/usr/bin/env bash
	mkdir -p ignore
	pushd ignore
	curl {{src}} | gunzip > .{{outputfile}}
	mv .{{outputfile}} {{outputfile}}

build:
	mkdir -p ./ssh
	ssh-keygen -t rsa -b 4096 -C "admin@openshiftdemo.org" -N '' -f ./ssh/id_rsa
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
