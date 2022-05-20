ip link add link eth1 name eth1.10 type vlan id 10
ip link set eth1.10 address 00:00:00:0:10:01
ip a add 192.168.10.11/24 dev eth1.10
ip link set dev eth1.10 up
