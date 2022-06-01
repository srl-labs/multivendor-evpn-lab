# Multivendor EVPN lab
This repository lets you deploy a multivendor lab by using [containerlab](https://containerlab.dev/) to build up the topology. With the files contained in this repository you are able to spin up a two-tier clos topology containing a L2 EVPN service distributed across the leaf switches (Nokia SR Linux, Arista cEOS and Juniper vQFX). OSPF is configured in the underlay to distribute the VTEP addresses and both spines (Nokia SROS and Juniper VMX) function as route reflectors to distribute EVPN routes with iBGP.

![](./img/topo.PNG)

## Deploy lab
With containerlab we can easily deploy a multivendor topology by defining all interlinks in one topology.yml file.
```
clab deploy -t topology.yml
```

## Destroy lab
```
clab destroy -t topology.yml
```
