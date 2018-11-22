
export GOBIN='/opt/app-root/bin'
export OPENSHIFT_INSTALL_BASE_DOMAIN=tt.testing
export OPENSHIFT_INSTALL_CLUSTER_NAME=test1
export OPENSHIFT_INSTALL_EMAIL_ADDRESS=admin@openshiftdemo.org
export OPENSHIFT_INSTALL_PASSWORD=verysecure
export OPENSHIFT_INSTALL_PLATFORM=libvirt
export OPENSHIFT_INSTALL_PULL_SECRET='{"auths": {"quay.io": {"auth": "Y29yZW9zK3RlYzJfaWZidWdsandoYTNkaW4yYmlqY2MybjJlaTpLMVNEQjNVWTlHMUZQUFpKTFg5VTFOWlJIQjRURjA1WllEOTZBMjdSWTRYRVcwSVVKVkxWRFZFSDFDSlZNQlNS", "email": "" }}}'
#export OPENSHIFT_INSTALL_SSH_PUB_KEY="$(cat /root/.ssh/id_rsa.pub)"
OPENSHIFT_INSTALL_SSH_PUB_KEY="$(cat /root/.ssh/id_rsa.pub)"
export OPENSHIFT_INSTALL_SSH_PUB_KEY
export OPENSHIFT_INSTALL_LIBVIRT_URI=qemu+tcp://192.168.122.1/system
export OPENSHIFT_INSTALL_LIBVIRT_IMAGE=file:///opt/app-root/src/qemu-img/rhcos-qemu.qcow2 
export KUBECONFIG=/opt/app-root/src/github.com/openshift/installer/auth/kubeconfig
export PATH="${PATH}:${GOBIN}"
