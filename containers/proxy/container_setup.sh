#!/bin/bash
TMPDIR=$1

apt-get -y update
sudo apt-get install -y haproxy fail2ban iptables
sudo rm -rf /var/lib/apt/lists/* && sudo rm /etc/fail2ban/filter.d/*.conf

mkdir -p /var/run/fail2ban
touch /var/log/patroneosd.log

printf ">>> Pushing HAProxy configuration files...\\n"
# Copy HAProxy configuration files
rsync -a $TMPDIR/haproxy_config.cfg /etc/haproxy/haproxy.cfg
#lxc file push $SCRIPTSDIR/ssl.pem proxy/usr/local/etc/haproxy/ssl.pem

printf ">>> Pushing Patroneos configuration files...\\n"
# Copy Patroneos files
rsync -a $TMPDIR/patroneosd /opt/patroneos/
rsync -a $TMPDIR/patroneos_config.json /etc/patroneos/config.json
sudo chmod u+x /opt/patroneos/patroneosd

printf ">>> Pushing fail2ban configuration files...\\n"
# Copy fail2ban configuration
rsync -a $TMPDIR/fail2ban/action.d /etc/fail2ban
rsync -a $TMPDIR/fail2ban/jail.d /etc/fail2ban
rsync -a $TMPDIR/fail2ban/filter.d /etc/fail2ban
rsync -a $TMPDIR/fail2ban/fail2ban.d /etc/fail2ban

# Run everything
echo "Reloading HAProxy"
sudo systemctl reload haproxy

echo "Reloading fail2ban"
fail2ban-client reload

echo "Starting patroneosd"
/opt/patroneos/patroneosd -configFile /etc/patroneos/config.json -mode fail2ban-relay &

#rm -rf $TMPDIR

printf ">>> Done.\\n"