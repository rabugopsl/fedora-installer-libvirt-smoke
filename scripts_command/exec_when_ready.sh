#!/usr/bin/env bash

# First argument is assigned to MAX_WAIT
# Second argument is assigned to EXEC_CMD

start_time=$(date -u +%s)
sleep_time=10s
elapsed=0
MAX_WAIT=300
BOOTSTRAPIP=''
EXEC_CMD=''

eval $(ssh-agent -s)
ssh-add ${HOME}/.ssh/id_rsa

if ! [[ -z $1 ]]; then
    MAX_WAIT=$1
fi

if ! [[ -z $2 ]]; then
    EXEC_CMD=$2
fi

while [[ elapsed -lt MAX_WAIT ]]
do
    if [[ -z $BOOTSTRAPIP ]]; then
        echo -ne "\rAwaiting cluster availability..."

        TEMPBOOTSTRAPIP=$(virsh --connect qemu+tcp://192.168.122.1/system domifaddr bootstrap 2> /dev/null | awk '/192/{print $4}')
        if ! [[ -z $TEMPBOOTSTRAPIP ]]; then
            BOOTSTRAPIP=${TEMPBOOTSTRAPIP::${#TEMPBOOTSTRAPIP}-3}
            echo ''
        fi
    fi

    if ! [[ -z $BOOTSTRAPIP ]]; then
        msg=$(ssh -oStrictHostKeyChecking=no core@${BOOTSTRAPIP} journalctl -n 1 -u bootkube -u tectonic)
        if ! [[ -z $(echo $msg | grep 'Tectonic installation is done') ]]; then
            if ! [[ -z $EXEC_CMD ]]; then
                bash -c "${EXEC_CMD}"
                exit 0
            fi
            bash -c "ssh -oStrictHostKeyChecking=no core@${BOOTSTRAPIP} journalctl -f -u bootkube -u tectonic"
            exit 0
        fi
        echo ${msg}
    fi
    elapsed=$(($(date -u +%s) - start_time))
    sleep $sleep_time
done
echo "Watch stopped after elapsed time: ${elapsed}"
exit 1
