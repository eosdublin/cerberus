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
PORT_MAPPINGS=$2
BASE_IMAGE=${3:-"ubuntu:18.04"}
# </Parameters>

# <Body>
echo ">>> Launching container..."
lxc launch $BASE_IMAGE $CONTAINER_NAME

echo ">>> Pausing to let container start..."
wait_bar 0.5

printf "\\n>>> Container started. Pushing setup files to container...\\n"
lxc file push -rp --verbose $SCRIPT_PATH/containers/$CONTAINER_NAME $CONTAINER_NAME/tmp

echo ">>> Running container setup script..."
lxc exec $CONTAINER_NAME -- /bin/bash /tmp/$CONTAINER_NAME/container_setup.sh /tmp/$CONTAINER_NAME &>> /tmp/setup_log.txt

echo ">>> Configuring iptables routing..."
HOST_IP=$(hostname -I | awk '{print $1}')
CONTAINER_IP=$(lxc list | grep $CONTAINER_NAME | egrep -o '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')

# Iterate the port mappings
IFS=',' read -ra MAPPINGS <<< "$PORT_MAPPINGS"
for mapping in "${MAPPINGS[@]}"; do
 
    EXT_PORT=$(echo $mapping | cut -d ":" -f 1)
    INT_PORT=$(echo $mapping | cut -d ":" -f 2)
    INTERFACE=$(echo $mapping | cut -d ":" -f 3)

    echo "Creating a mapping from $HOST_IP:$EXT_PORT -> $CONTAINER_IP:$INT_PORT on $NIC"

    sudo iptables -t nat -I PREROUTING -i $INTERFACE -p TCP -d $HOST_IP --dport $EXT_PORT -j DNAT --to-destination $CONTAINER_IP:$INT_PORT
done

printf ">>> Done ($HOST_IP -> $CONTAINER_IP)\\n"
# </Body>