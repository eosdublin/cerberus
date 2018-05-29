# Cerberus
A collection of scripts and binaries used to automate the setup of servers that act as a the gateway to the underworld, i.e. block producer internal infrastructure 

The scripts here are based on the official EOS.IO Patroneos repository whereby Docker has been replaced with LXC. https://github.com/EOSIO/patroneos

The scripts here enable the user to deploy two LXC containers to a single machine, establishing the advanced setup scenario from the Patroneos repository. 

The following diagram shows the result of running the scripts:



## TODO

- Allow the nodeos URL to be set dynamically. This will be sitting on a different box, so pass it as a param
- The proxy node requires multiple iptable entries as it also hosts the log listener

## Usage

### Dependencies
The repository contains a pre-combiled version of Patroneos, however it is advised that you build your own. To do so, fetch the code from the Patroneos repository and compile using:

`go build -o patroneosd *.go`

Note: You need to have go installed. `$apt install golang` for you Ubuntu users.

### Running

Invoke setup.sh to create and launch the LXC containers. To modify the ports that are used, simply edit setup.sh, line 17.

./setup.sh node_os_protocol node_os_address node_os_port

### Configuration