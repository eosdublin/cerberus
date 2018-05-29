#!/bin/bash
TMPDIR=$1

printf ">>> Pushing Patroneos configuration files...\\n"
# Copy Patroneos files
sudo mkdir /opt/patroneos/
sudo cp $TMPDIR/patroneosd /opt/patroneos/
sudo chown ubuntu:ubuntu /opt/patroneos/patroneosd

sudo mkdir /etc/patroneos
sudo cp $TMPDIR/patroneos_filter_config.json /etc/patroneos/config.json
sudo chown ubuntu:ubuntu /etc/patroneos/config.json

# sudo chown ubuntu:ubuntu /opt/patroneos/patroneosd
sudo chmod u+x /opt/patroneos/patroneosd

echo ">>> Starting patroneosd"
/opt/patroneos/patroneosd -configFile /etc/patroneos/config.json &

#rm -rf $TMPDIR

printf ">>> Done.\\n"