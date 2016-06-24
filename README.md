# ubuntu-fan-hacks

## Create NoCloud config drives for each VM

```bash
for i in 1 2 3 ; do ./create-config-drive -h fan-vm-${i} -k ~/.ssh/id_rsa.pub -u ./user-data fan-vm-${i}-config.iso; done
```

## Copy config drives for libvirt access

```bash
sudo cp -v fan-vm*-config.iso /var/lib/libvirt/images
```

## Setup the VMs
```bash
./setup-vm.sh 1 2 3
```

Note: I copied and modified create-config-drive (missing attribution
because I don't recall where).
