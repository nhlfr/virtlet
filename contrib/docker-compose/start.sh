#!/bin/sh

DIR=$(pwd)
KUBERNETES_DIR=$GOPATH/src/k8s.io/kubernetes

if [ ! -d $KUBERNETES_DIR ]; then
	>&2 echo "Cannot find kubernetes source dir. Please clone its repo with the following steps: https://github.com/kubernetes/kubernetes/blob/master/docs/devel/development.md#workflow"
	exit 1
fi

CONTAINER_RUNTIME_ENDPOINT=/run/virtlet.sock ENABLE_DAEMON=true $KUBERNETES_DIR/hack/local-up-cluster.sh

sudo brctl addbr virtlet
sudo ip addr add 10.111.0.1/8 dev virtlet

if [ ! -f ./calicoctl ]; then
	wget http://www.projectcalico.org/latest/calicoctl
	chmod +x calicoctl
fi
sudo $DIR/calicoctl node
sudo $DIR/calicoctl pool add 10.111.0.0/24

docker-compose up
