#/bin/bash

##need to implement a checl for existing files for $2

today=`date +%Y-%m-%d.%H.%M.%S`

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
https://jetson-nano.mail2you.net/server/php/index.php >> /home/samson/jetson-nano-ai-cam/send_http.log
EOF
)

echo "$today: $curl_str" >> /home/samson/jetson-nano-ai-cam/send_http.log


#ARGV[2]
#clear
#echo $curl_str
#printf "\n\n"

eval $curl_str

echo "" >> /home/samson/jetson-nano-ai-cam/send_http.log

echo "$1 $2"