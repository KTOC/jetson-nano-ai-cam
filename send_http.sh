#/bin/bash 


##need to implement a checl for existing files for $2

today=`date +%Y-%m-%d.%H.%M.%S`

clear
#~/skip_sudo.sh

connection_successful=false
retry_count=0
modem_id=0

##set -x for debug
#set -x

while [  "$retry_count" -le 5  -a !"$connection_successful"  ]
#while ! [[ ( "${camera_num}" =~ ${regex} ) && ("$camera_num" -ge 0) && ("$camera_num" -lt ${#video_camera_array[@]})  ]];
do
	#Check if poing 1.1.1.1 is successful
	if ping -q -c 1 -W 1 1.1.1.1 >/dev/null; then
		echo "IPv4 is up"
		connection_successful=true
		break;

	else
		echo "IPv4 is down"


		##check modem
		#sudo mmcli -m 0 -r ##hardware pin is broken
		if [[ $( mmcli -m $modem_id --output-keyvalue | awk ' /power/ { print $3 } ') == 'on' ]]; then
			if [[ $( mmcli -m $modem_id --output-keyvalue | awk ' /modem.generic.state / { print $3 } ') == 'connected' ]]; then

				#check signal strength
				signal_quality=$(mmcli -m $modem_id --output-keyvalue | awk ' /signal-quality.value/ { print $3 } ')
				echo "Signal Quality: $signal_quality"

				sudo nmcli con down mobile_network
				sudo nmcli con up mobile_network

				sleep 20
				#recheck
				if ping -q -c 1 -W 1 1.1.1.1 >/dev/null; then
					echo "IPv4 is up"
					connection_successful=true
					continue
				else
					echo "nmcli con up fail, trying reset USB"
					if [[ -e $(lsusb | grep Modem) ]]; then
						lsusb | awk ' /Modem/ {gsub(/:/,""); system("sudo ~/jetson-nano-ai-cam/usbreset /dev/bus/usb/"$2 "/" $4)}'
						#modem_id would change as well
						((modem_id++))

						sleep 20

						sudo nmcli con up mobile_network

						if ping -q -c 1 -W 1 1.1.1.1 >/dev/null; then
							echo "IPv4 is up"
							connection_successful=true
							continue
						else
							echo "ERROR, cannot resolve issue";
						fi

					else
						printf "Modem Not found, maybe need to replug or maybe you need reboot\n"
					fi
				fi

			else
				echo "Not connected, trying disable and re-enable"

				#DISABLE AND RE-ENABLE MODEM
				sudo mmcli -m 0 -d
				sudo mmcli -m 0 -e
			fi

			#restart ngrok if needed
			sudo pgrep ngrok | xargs sudo kill -9
			sudo /root/ngrok/ngrok start -all &	
			#sleep 1
			ngrok_domains=$(sudo tail -4 /root/ngrok/log.txt | awk ' /addr\=/ { gsub(/url=tcp\:\/\/|url=/, ""); print $NF}' )
			sudo python3 ~/jetson-nano-ai-cam/show.py $ngrok_domains

			printf "ngrok restarted\n";

		else
			echo "Modem poweroff"
		fi

		
	fi


	((retry_count+=1))
	((modem_id+=1))
done



#-X for debug
curl_str=$(cat <<EOF
curl \
-s -X POST -H 'Content-Type: multipart/form-data' \
	-F 'gps=0.0,0.0' \
	-F 'detected_object=$1' \
	-F 'app_id=1234' \
	-F 'app_token=42134' \
	-F 'files=@$2' \
	-F 'simple_form=1' \
https://jetson-nano.mail2you.net/server/php/index.php >> ~/jetson-nano-ai-cam/send_http.log
EOF
)

echo "$today: $curl_str:$0" >> ~/jetson-nano-ai-cam/send_http.log


#ARGV[2]
#clear
#echo $curl_str
#printf "\n\n"

eval $curl_str

echo "" >> ~/jetson-nano-ai-cam/send_http.log

echo "$1 $2"