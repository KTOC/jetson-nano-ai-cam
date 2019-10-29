#!/bin/bash

createTunnel() {
	#/usr/bin/ssh -R jetson1:10022:localhost:22 tunnel.mail2you.net -p 10022 -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" &

	##upgrade with autossh

	/usr/bin/autossh -M 0 -f -o "ServerAliveInterval 15" -o "ServerAliveCountMax 3" -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" -o "ConnectTimeout 10" -o "ExitOnForwardFailure yes" -R jetson1:10022:localhost:22 tunnel.mail2you.net -p 10022
}
/bin/pidof autossh

if [[ $? -ne 0 ]]; then
echo "Create Tunnel"
	createTunnel
fi


