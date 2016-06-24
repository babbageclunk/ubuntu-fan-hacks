#!/bin/bash

virsh pool-refresh default

for i in "$@"; do
    virsh pool-refresh default

    name=fan-vm-${i}
    virsh destroy $name || true
    virsh undefine $name || true
    virsh pool-refresh default
    virsh vol-delete --pool default ${name}.img
    virsh pool-refresh default

    virsh vol-clone --pool default xenial-server-cloudimg-amd64-disk1.img ${name}.img
    virsh pool-refresh default
    
    virt-install -r 1024 \
    		 -n $name \
    		 --vcpus=1 \
    		 --autostart \
    		 --noautoconsole \
    		 --memballoon virtio \
    		 --network network=fan \
    		 --boot hd \
    		 --disk vol=default/${name}.img,format=qcow2,bus=virtio,cache=writeback,sparse=true,size=${DISK_SIZE:-10} \
    		 --disk vol=default/${name}-config.iso,bus=virtio
done
