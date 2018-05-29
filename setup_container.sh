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
VMIP=$(hostname -I | awk '{print $1}')
CONTAINERIP=$(lxc list | grep $CONTAINER_NAME | egrep -o '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')

# Iterate the port mappings
IFS=',' read -ra MAPPINGS <<< "$PORT_MAPPINGS"
for mapping in "${MAPPINGS[@]}"; do

    ext_port=cut $mapping -d ":" -f 1
    int_port=cut $mapping -d ":" -f 2
    nic=cut $mapping -d ":" -f 3

    sudo iptables -t nat -I PREROUTING -i $nic -p TCP -d $VMIP --dport $ext_port -j DNAT --to-destination $CONTAINERIP:$int_port
done

printf ">>> Done ($VMIP -> $CONTAINERIP)\\n"
# </Body>