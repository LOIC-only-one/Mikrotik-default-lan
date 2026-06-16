/ip dhcp-client add interface=ether1 disabled=no
/interface bridge add name="LAN - Bridge" vlan-filtering=yes protocol-mode=rstp
/interface bridge port add bridge="LAN - Bridge" interface=ether2
/interface bridge port add bridge="LAN - Bridge" interface=ether3
/interface bridge port add bridge="LAN - Bridge" interface=ether4
/interface bridge port add bridge="LAN - Bridge" interface=ether5
/interface bridge port add bridge="LAN - Bridge" interface=ether6
/interface bridge port add bridge="LAN - Bridge" interface=ether7
/interface bridge port add bridge="LAN - Bridge" interface=ether8
/interface bridge port add bridge="LAN - Bridge" interface=ether9
/interface bridge port add bridge="LAN - Bridge" interface=ether10
/interface bridge port add bridge="LAN - Bridge" interface=wlan1
/interface bridge vlan add bridge="LAN - Bridge" vlan-ids=10 untagged=ether6,ether7,ether8,ether9,ether10
/interface bridge vlan add bridge="LAN - Bridge" vlan-ids=20 untagged=ether2,ether3
/interface bridge vlan add bridge="LAN - Bridge" vlan-ids=30 untagged=ether4,ether5,wlan1
/interface bridge vlan set [find vlan-ids=10] comment="IoT"
/interface bridge vlan set [find vlan-ids=20] comment="Serveurs"
/interface bridge vlan set [find vlan-ids=30] comment="WiFi"
/interface bridge port set [find interface=ether2] pvid=20
/interface bridge port set [find interface=ether3] pvid=20
/interface bridge port set [find interface=ether4] pvid=30
/interface bridge port set [find interface=ether5] pvid=30
/interface bridge port set [find interface=ether6] pvid=10
/interface bridge port set [find interface=ether7] pvid=10
/interface bridge port set [find interface=ether8] pvid=10
/interface bridge port set [find interface=ether9] pvid=10
/interface bridge port set [find interface=ether10] pvid=10
/interface bridge port set [find interface=wlan1] pvid=30
/interface vlan add name="vlan10-IoT" interface="LAN - Bridge" vlan-id=10
/interface vlan add name="vlan20-Serveurs" interface="LAN - Bridge" vlan-id=20
/interface vlan add name="vlan30-WiFi" interface="LAN - Bridge" vlan-id=30
/ip address add address=192.168.10.1/24 interface="vlan10-IoT"
/ip address add address=192.168.20.1/24 interface="vlan20-Serveurs"
/ip address add address=192.168.30.1/24 interface="vlan30-WiFi"
/ip pool add name="pool-IoT" ranges=192.168.10.100-192.168.10.254
/ip pool add name="pool-Serveurs" ranges=192.168.20.100-192.168.20.254
/ip pool add name="pool-WiFi" ranges=192.168.30.100-192.168.30.254
/ip dhcp-server add name="dhcp-IoT" interface="vlan10-IoT" address-pool="pool-IoT" disabled=no
/ip dhcp-server add name="dhcp-Serveurs" interface="vlan20-Serveurs" address-pool="pool-Serveurs" disabled=no
/ip dhcp-server add name="dhcp-WiFi" interface="vlan30-WiFi" address-pool="pool-WiFi" disabled=no
/ip dhcp-server network add address=192.168.10.0/24 gateway=192.168.10.1 dns-server=1.1.1.1
/ip dhcp-server network add address=192.168.20.0/24 gateway=192.168.20.1 dns-server=1.1.1.1
/ip dhcp-server network add address=192.168.30.0/24 gateway=192.168.30.1 dns-server=1.1.1.1
