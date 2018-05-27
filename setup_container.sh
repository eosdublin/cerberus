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

# <Parameters>
CONTAINER_NAME=$1
PUBLIC_PROXY_PORT=$2
PROXY_CONTAINER_PORT=$3
NIC=$4 || eth0
# </Parameters>

# <Body>
echo ">>> Launching container..."
lxc launch --verbose ubuntu:18.04 $CONTAINER_NAME

echo ">>> Pausing to let container start..."
wait_bar 0.5

printf "\\n>>> Containers started. Pushing setup files to container...\\n"
lxc file push -rp --verbose $SCRIPT_PATH/containers/$CONTAINER_NAME $CONTAINER_NAME/tmp

echo ">>> Running container setup script..."
lxc exec $CONTAINER_NAME -- /bin/bash /tmp/$CONTAINER_NAME/container_setup.sh /tmp/$CONTAINER_NAME &>> /tmp/setup_log.txt

echo ">>> Configuring iptables routing..."
VMIP=$(hostname -I | awk '{print $1}')
CONTAINERIP=$(lxc list | grep $CONTAINER_NAME | egrep -o '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')

sudo iptables -t nat -I PREROUTING -i $NIC -p TCP -d $VMIP --dport $PUBLIC_PROXY_PORT -j DNAT --to-destination $CONTAINERIP:$PROXY_CONTAINER_PORT

printf ">>> Done ($VMIP -> $CONTAINERIP)\\n"
# </Body>