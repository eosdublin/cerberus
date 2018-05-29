#!/bin/bash
################################################################################
#
# Script created by @samnoble
#
# Visit https://github.com/eosdublin/cerberus for details.
#
################################################################################

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"

# <Imports>
. utilities.sh
# </Imports>

# <Constants>
# The format of each entry is:
#
#   container_name port_mapping+
#
# Where
#
#    port_mapping: lxc_external_port:lxc_internal_port:interface
#
declare -a containers=("proxy 443:443:eth0,9998:9998:eth0" "filter 9999:9999:eth0")
# </Constants>

# <Body>
for container in "${containers[@]}"
do
	echo ">>> Setting up $container container..."
	
	. $SCRIPT_PATH/setup_container.sh $container
	
	echo ">>> Done setting up $container container."
done

echo ">>> Persisting host IP table entries"

echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo apt update && sudo apt -y install iptables-persistent

echo ">>> Setup complete <<<"
# </Body>

