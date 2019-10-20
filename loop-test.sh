#!/bin/bash

runInterval=5 # In seconds

loop() {

  # This is the loop.
  now=`date +%s`

  if [ -z $last ]; then
    last=`date +%s`
  fi

  # Do everything you need the daemon to do.
  # check if process exists

  #if not, run again
  #~/jetson-nano-ai-cam/select-camera.sh autorun
  
  # Check to see how long we actually need to sleep for. If we want this to run
  # once a minute and it's taken more than a minute, then we should just run it
  # anyway.
  last=`date +%s`

	#clear
	~/skip_sudo.sh
	echo "start loop"

	##Actual check
	darknet_pid=$(pgrep darknet)

	if [ "$darknet_pid" == "" ]; then
		##darknet not running, need to run again
		~/jetson-nano-ai-cam/select-camera.sh autorun
		exit 0	
	fi

	darknet_virt=$(cat /proc/$darknet_pid/stat | cut -d" " -f23)

	if [ $darknet_virt -ge 14000000000  ]; then

		echo "Consumed too much memory, restart!";
		
		sudo pgrep darknet | xargs sudo kill -9
		printf "All darknet process killed\n";
		sleep 3

		~/jetson-nano-ai-cam/select-camera.sh autorun

		exit 0
	fi

	loadavg_1m=$( cat /proc/loadavg | cut -d" " -f1)
	acceptable_cpuload=4

	if (( $(awk 'BEGIN {print ("'$loadavg_1m'" >= "'$acceptable_cpuload'")}') )); then

		echo "Overloading system, restart!";
		
		sudo pgrep darknet | xargs sudo kill -9
		printf "All darknet process killed\n";
		sleep 3

		~/jetson-nano-ai-cam/select-camera.sh autorun

		exit 0	
	fi


  # Set the sleep interval
  if [[ ! $((now-last+runInterval+1)) -lt $((runInterval)) ]]; then
    sleep $((now-last+runInterval))
  fi

  # Startover
  loop
}

loop