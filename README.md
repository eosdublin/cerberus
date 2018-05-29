# Cerberus
A collection of scripts and binaries used to automate the setup of servers that act as a the gateway to the underworld, i.e. block producer internal infrastructure 

The scripts here are based on the official EOS.IO Patroneos repository whereby Docker has been replaced with LXC. https://github.com/EOSIO/patroneos

The scripts here enable the user to deploy two LXC containers to a single machine, establishing the advanced setup scenario from the Patroneos repository. One running proxy mode (:443 for HAProxy and :9998 for Patroneos in log mode) and another running filter mode (:9999 for Patroneos in filter mode).

The following diagram shows the result of running the scripts (apologies for the child like scrawling, this will be replaced with an easier to read version):

*Note:* The ports in red are what's defined in the default repo. Ignore the ones in blue. The ones in green are what's in use here.

![Layout Diagram](https://github.com/eosdublin/cerberus/raw/master/diagram.png "Sketch")

## TODO

- Review IP tables rules and lock them down (@jemexpat is working on this in parallel)
- Fix permissions issue with start patroneos (currently running as root)

## Usage

### Dependencies
The repository contains a pre-combiled version of Patroneos, however it is advised that you build your own. To do so, fetch the code from the Patroneos repository and compile using:

`go build -o patroneosd *.go`

Note: You need to have go installed. `$apt install golang` for you Ubuntu users.

LXC should already be initialised prior to running setup.

### Running

Invoke setup.sh to create and launch the LXC containers. To modify the ports that are used, simply edit setup.sh, line 17.

./setup.sh

### Configuration

To point to your nodeos API, change the values in containers/filter/patroneos_filter_config.