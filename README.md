# Multivendor EVPN lab
This repository lets you deploy a multivendor lab by using [containerlab](https://containerlab.dev/) to build up the topology. With the files contained in this repository you are able to spin up a two-tier clos topology containing a L2 EVPN service distributed across the leaf switches (Nokia SR Linux, Arista cEOS and Juniper vQFX). OSPF is configured in the underlay to distribute the VTEP addresses and both spines (Nokia SROS and Juniper VMX) function as route reflectors to distribute EVPN routes with iBGP.

![](./img/topo.PNG)

## Lab lifecycle
With containerlab we can easily deploy a multivendor topology by defining all interlinks in one YAML [file](https://github.com/srl-labs/multivendor-evpn-lab/blob/master/multivendor-evpn.clab.yml). This file can be used to deploy our topology by passing it as an argument with the `deploy` command.
```
clab deploy -t multivendor-evpn.clab.yml
```
Same goes for destroying the lab
```
clab destroy -t multivendor-evpn.clab.yml
```
## Accessing the network elements
After deploying the lab you will see a nice summary of the deployed nodes in table format like below. To access a network element with SSH simply use the hostname as described in the table.
```
ssh admin@clab-multivendor-srl
```
The linux CE clients can be accessed as regular containers, you can connect to them just like to any other container
```
docker exec -it clab-multivendor-client-1 bash
```
```
+---+---------------------------+--------------+--------------------------------------------+---------+---------+-----------------+-----------------------+
| # |           Name            | Container ID |                   Image                    |  Kind   |  State  |  IPv4 Address   |     IPv6 Address      |
+---+---------------------------+--------------+--------------------------------------------+---------+---------+-----------------+-----------------------+
| 1 | clab-multivendor-ceos     | 8a0e11627564 | registry.srlinux.dev/pub/ceos:4.26.2.1F    | ceos    | running | 172.20.20.5/24  | 2001:172:20:20::5/64  |
| 2 | clab-multivendor-client-1 | dd87e9c05565 | ghcr.io/hellt/network-multitool            | linux   | running | 172.20.20.12/24 | 2001:172:20:20::c/64  |
| 3 | clab-multivendor-client-2 | ec21d39903e8 | ghcr.io/hellt/network-multitool            | linux   | running | 172.20.20.16/24 | 2001:172:20:20::10/64 |
| 4 | clab-multivendor-client-3 | 1c3fe19ddfde | ghcr.io/hellt/network-multitool            | linux   | running | 172.20.20.6/24  | 2001:172:20:20::6/64  |
| 5 | clab-multivendor-srl      | eb972bd68927 | ghcr.io/nokia/srlinux:21.11.3              | srl     | running | 172.20.20.31/24 | 2001:172:20:20::1f/64 |
| 6 | clab-multivendor-sros     | 5f44a208553e | registry.srlinux.dev/pub/vr-sros:22.5.R1   | vr-sros | running | 172.20.20.28/24 | 2001:172:20:20::1c/64 |
| 7 | clab-multivendor-vmx      | c5a3622dae2f | registry.srlinux.dev/pub/vr-vmx:21.1R1.11  | vr-vmx  | running | 172.20.20.30/24 | 2001:172:20:20::1e/64 |
| 8 | clab-multivendor-vqfx     | 9dd9cbcb3270 | registry.srlinux.dev/pub/vr-vqfx:19.4R1.10 | vr-vqfx | running | 172.20.20.29/24 | 2001:172:20:20::1d/64 |
+---+---------------------------+--------------+--------------------------------------------+---------+---------+-----------------+-----------------------+
```

## Configuration
All nodes come preconfigured thanks to startup-config setting in the topology file multivendor-evpn.clab.yml. The only node that needs extra configuration after deployment is the Juniper VMX spine. You can find the configuration [here](https://github.com/srl-labs/multivendor-evpn-lab/blob/master/config/vmx.cfg). Connect to the VMX spine, enter configuration mode by typing `configure`. Copy paste the configuration in the terminal and `commit` the changes.

## Sending traffic
The three linux clients share the same broadcast domain (192.168.10.0/24) as defined by a L2 EVPN service distributed over the leaves. Each client is already assigned with an IP and MAC address as shown in the topology image above.
- client-1 = 192.168.10.11
- client-2 = 192.168.10.12
- client-3 = 192.168.10.13

For functional testing we can start sending a ping between clients
```
# docker exec -it clab-multivendor-client-1 bash
bash-5.0# ping -c 5 192.168.10.13
PING 192.168.10.13 (192.168.10.13) 56(84) bytes of data.
64 bytes from 192.168.10.13: icmp_seq=1 ttl=64 time=307 ms
64 bytes from 192.168.10.13: icmp_seq=2 ttl=64 time=103 ms
64 bytes from 192.168.10.13: icmp_seq=3 ttl=64 time=106 ms
64 bytes from 192.168.10.13: icmp_seq=4 ttl=64 time=103 ms
64 bytes from 192.168.10.13: icmp_seq=5 ttl=64 time=104 ms

--- 192.168.10.13 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4003ms
rtt min/avg/max/mdev = 102.920/144.541/306.975/81.223 ms
bash-5.0#

```

## Verification

