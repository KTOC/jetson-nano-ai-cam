#!/bin/bash

createTunnel() {
	#/usr/bin/ssh -R ras3b:10022:localhost:22 tunnel.mail2you.net -p 10022 -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" &

	##upgrade with autossh

	/usr/bin/autossh -M 0 -f -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" -R ras3b:10022:localhost:22 tunnel.mail2you.net -p 10022 
}
/bin/pidof autossh

if [[ $? -ne 0 ]]; then
echo "Create Tunnel"
	createTunnel
fi


