echo ">>> Stopping container..."
sudo lxc stop proxy
sudo lxc stop filter

echo ">>> Deleting container..."
lxc delete proxy
lxc delete filter

. delete_iptables.sh

echo ">>> Calling Setup..."
. setup.sh #&> /tmp/setup_log.txt

