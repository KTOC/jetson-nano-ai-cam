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

#clear
#echo $curl_str
#printf "\n\n"
eval $curl_str
#echo "**********************"