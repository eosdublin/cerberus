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
CONTAINER_NAME=proxy
# </Constants>

# <Parameters>
CONTAINER_NAME=$1
PUBLIC_PROXY_PORT=$2 || 8081
PROXY_CONTAINER_PORT=$3 || 80
NIC=$4 || eth0
# </Parameters>

# <Body>
echo ">>> Launching container..."
lxc launch --verbose ubuntu:18.04 $CONTAINER_NAME

echo ">>> Pausing to let container start..."
wait_bar 0.5

printf "\\n>>> Containers started. Pushing setup files to container...\\n"
lxc file push -rp --verbose $SCRIPTS_DIR/containers/$CONTAINER_NAME $CONTAINER_NAME/tmp

echo ">>> Running container setup script..."
lxc exec $CONTAINER_NAME -- /bin/bash /tmp/$CONTAINER_NAME/$($CONTAINER_NAME)_container_setup.sh /tmp/$CONTAINER_NAME &>> /tmp/setup_log.txt

echo ">>> Configuring iptables routing..."
VMIP=$(hostname -I | awk '{print $1}')
CONTAINERIP=$(lxc list | grep proxy | egrep -o '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')

sudo iptables -t nat -I PREROUTING -i $NIC -p TCP -d $VMIP --dport $PUBLIC_PROXY_PORT -j DNAT --to-destination $CONTAINERIP:$PROXY_CONTAINER_PORT
#sudo iptables -A FORWARD -p tcp -d $CONTAINERIP --dport 80 -j ACCEPT

printf ">>> Done ($VMIP -> $CONTAINERIP)\\n"
# </Body>