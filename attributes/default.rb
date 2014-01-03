
# Net Name to where all config files are written to
default['tinc']['net_name'] = "tinc"
default['tinc']['hostname'] = node['hostname']

# Per Node interface ips
default['tinc']['interface_ip'] = "127.0.0.45"
default['tinc']['interface_netmask'] = "255.255.255.255"

# array of hosts this node should connect to
default['tinc']['connect_to'] = []

