#!/bin/sh

DIR=$(pwd)

docker-compose down
sudo kill -9 $(pgrep hyperkube)

docker rm -f calico-node

kill -9 $(pgrep etcd)

sudo ip addr del 10.111.0.1/8 dev virtlet
sudo ip link set virtlet down
sudo brctl delbr virtlet
