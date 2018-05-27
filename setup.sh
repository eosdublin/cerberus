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
declare -a containers=("proxy 8081 80 eth0" "filter 80 81 lxdbr0")
# </Constants>

# <Body>
for container in "${containers[@]}"
do
	echo ">>> Setting up $container container..."
	
	. $SCRIPT_PATH/setup_container.sh $container
	
	echo ">>> Done setting up $container container."
done

echo ">>> Persisting IP tables"

echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo apt update && sudo apt -y install iptables-persistent

echo ">>> Setup complete <<<"
# </Body>

