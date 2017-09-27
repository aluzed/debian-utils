# debian-utils
Debian utils

### LXC

When you create a LXC, the container runs in a closed network with only a loopback interface.
You need to install different packages :

* lxc
* bridge-utils

Create a virtual bridge :

```
brctl add lxcbr0
```

Add the interface to bridge (you can replace eth0 by the name of your interface) :

```
brctl addif lxcbr0 eth0
```

I usually set my bridge on another IP range, to prevent bad stuff. In /etc/network/interfaces

```
auto lxcbr0
    iface lxcbr0 inet static
        address 10.0.0.1
        netmask 255.255.255.0
        gateway 192.168.1.1 # set your physical interface gateway
```

In the lxc config file : /var/lib/lxc/<name>/config :

```
lxc.network.type = veth
lxc.network.flags = up
lxc.network.link = lxcbr0
lxc.network.name = eth0
lxc.network.hwaddr = 00:FF:AA:00:00:01
lxc.network.ipv4 = 10.0.0.5/24
lxc.network.ipv4.gateway = 10.0.0.1
```

To set up iptables rules, as an administrator :

```
sh lxc-net.sh eth0 lxcbr0
```

### Mongo Restore

Put the file where there are all the .bson files :

```
sh restore_dbs.sh <db_name>
```
