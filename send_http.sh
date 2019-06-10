#/bin/bash

curl_str=$(cat <<EOF
curl \
-X POST -H 'Content-Type: multipart/form-data' \
	-F 'gps=0.0,0.0' \
	-F 'detected_object=$1' \
	-F 'app_id=1234' \
	-F 'app_token=42134' \
	-F "files=@$2" \
	-F 'simple_form=1' \
https://jetson-nano.mail2you.net/server/php/index.php
EOF
)

#ARGV[2]
#clear
#echo $curl_str
#printf "\n\n"

today=`date +%Y-%m-%d.%H.%M.%S`
echo "$today $curl_str \n" >> /home/samson/jetson-nano-ai-cam/send_http.log

eval $curl_str
echo "*Sent*$1******************$2**"