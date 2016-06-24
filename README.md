# ubuntu-fan-hacks

Some notes on for experimenting with the `ubuntu-fan` package.

## Network bridge

Create a network bridge for the fan VMs

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

## Make hostnames resolvable

Add this on the VM host machine:

```
$ cat /etc/NetworkManager/dnsmasq.d/fan.conf
server=/fan/172.30.0.1
```

## Create NoCloud config drives for each VM

```bash
for i in 1 2 3 ; do ./create-config-drive -h fan-vm-${i} -k ~/.ssh/id_rsa.pub -u ./user-data fan-vm-${i}-config.iso; done
```

Note: I copied and modified create-config-drive (missing attribution
because I don't recall where).

## Copy config drives for libvirt access

```bash
sudo cp -v fan-vm*-config.iso /var/lib/libvirt/images
```

## Create the VMs
```bash
./setup-vm.sh 1 2 3
```

## Verify VMs are running

This will take a little time because of cloud-init installing packages
and updates, et al.

```
$ virsh list
 Id    Name                           State
----------------------------------------------------
 27    fan-vm-1                       running
 28    fan-vm-2                       running
 29    fan-vm-3                       running
```

# /usr/sbin/fanatic testing

## Docker images (including network utilities)

```
$ docker pull frobware/ubuntu
$ docker tag frobware/ubuntu ubuntu
```

We tag that as `ubuntu` so that `fanatic` will just work. The
`frobware/ubuntu` image has the following networking utilities
installed:

```
apt-get -y update
apt-get -y install iputils-ping traceroute net-tools iproute2
```
