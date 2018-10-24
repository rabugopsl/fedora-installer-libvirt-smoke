# This file can be used with `just` (https://github.com/casey/just)
 
TAG = 'smoke-test-installer'
NET = 'bridge'
QEMU_IMG_PATH_RHCOS = "/opt/app-root/src/qemu-img/rhcos-qemu.qcow2"
SSH_KEY_PATH = "/root/.ssh"

dl-rhcos src='http://aos-ostree.rhev-ci-vms.eng.rdu2.redhat.com/rhcos/images/cloud/latest/rhcos-qemu.qcow2.gz' outputfile='rhcos-qemu.qcow2':
	#!/usr/bin/env bash
	mkdir -p ignore
	pushd ignore
	curl {{src}} | gunzip > .{{outputfile}}
	mv .{{outputfile}} {{outputfile}}

build:
	#!/usr/bin/env bash
	if [ ! -f ./ssh/id_rsa ]; then
	    mkdir -p ./ssh
	    ssh-keygen -t rsa -b 4096 -C "admin@openshiftdemo.org" -N '' -f ./ssh/id_rsa
	fi
	docker image build -t {{TAG}} .

run repo_owner='openshift' branch='master': build
	#!/usr/bin/env bash
	docker container run --name {{TAG}} --net={{NET}} --privileged --rm -d \
		--volume "${PWD}"/ignore/rhcos-qemu.qcow2:{{QEMU_IMG_PATH_RHCOS}}:ro \
		--env REPO_OWNER={{repo_owner}} --env BRANCH={{branch}} \
		{{TAG}} 

run-attach repo_owner='openshift' branch='master': build
	#!/usr/bin/env bash
	docker container run --name {{TAG}} --net={{NET}} --privileged --rm -it \
		--volume "${PWD}"/ignore/rhcos-qemu.qcow2:{{QEMU_IMG_PATH_RHCOS}}:ro \
		--env REPO_OWNER={{repo_owner}} --env BRANCH={{branch}} \
		{{TAG}} 

exec +args='/bin/bash':
	docker container exec -it {{TAG}} {{args}}

exec-ready max-wait='10' args='':
	#!/usr/bin/env bash
	docker container exec -it {{TAG}} bash -c "/scripts/exec_when_ready.sh {{max-wait}} {{args}}"

stop:
	docker container stop {{TAG}}

cleanup:
	docker image rm {{TAG}} $(docker image ls -a | grep '^<none>' | awk '{print $3}')
