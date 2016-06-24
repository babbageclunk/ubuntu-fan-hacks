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

## Make hostnames resolvable:

```
$ cat /etc/NetworkManager/dnsmasq.d/fan.conf 
server=/fan/172.30.0.1
```

## Network bridge

```xml
$ virsh net-dumpxml fan
<network connections='1'>
  <name>fan</name>
  <uuid>fedc1cbe-5ae1-4d7c-937e-4d79252fb98e</uuid>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr4' stp='on' delay='0'/>
  <mac address='52:54:00:00:54:d0'/>
  <domain name='fan' localOnly='yes'/>
  <dns>
    <forwarder addr='192.168.1.1'/>
  </dns>
  <ip address='172.30.0.1' netmask='255.255.0.0'>
    <dhcp>
      <range start='172.30.128.0' end='172.30.255.254'/>
    </dhcp>
  </ip>
</network>
```
