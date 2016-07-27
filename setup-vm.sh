#!/bin/bash

set -e

for i in "$@"; do
    name=vm-${i}
    virsh pool-refresh default
    virsh vol-clone --pool default trusty-server-cloudimg-amd64-disk1.img ${name}.img
    virsh vol-resize --pool default ${name}.img +10G
    virsh pool-refresh default
    virt-install -r 1024 \
    		 -n $name \
    		 --vcpus=1 \
    		 --noautoconsole \
    		 --memballoon virtio \
    		 --boot hd \
    		 --disk vol=default/${name}.img,format=qcow2,bus=virtio,cache=writeback,size=${DISK_SIZE:-10} \
    		 --disk vol=default/${name}-config.iso,bus=virtio \
                 --network network=maas,model=virtio

done
