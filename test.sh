temptemp=$(cat <<EOF
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00001818.jpg
EOF
)
echo $temptemp


cat <<EOF
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00000326.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00000443.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00000577.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00000697.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00000831.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00000943.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00001061.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00001179.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00001313.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00001448.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00001566.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00001684.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00001818.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00001939.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00002054.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00002188.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00002323.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00002457.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00002592.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00002710.jpg
JETSON_NANO_DETECTION:person 69%, person 40%, :/mnt/sandisk/detection-_00002842.jpg
EOF
echo
echo
echo

#echo $temptemp | sed 's/JETSON_NANO_DETECTION\://g'
#echo $temptemp | sed 's/JETSON_NANO_DETECTION\://g' | sed 's/\,\W\:/:/g'
#echo $temptemp | sed 's/JETSON_NANO_DETECTION\://g' | sed 's/\,\W\:/:/g' | awk -F: '{print $1,$2}'

#echo $temptemp | sed 's/JETSON_NANO_DETECTION\://g' | sed 's/\,\W\:/:/g' | awk -F: '{print $2}' | xargs ls -al

#echo $temptemp | sed 's/JETSON_NANO_DETECTION\://g' | sed 's/\,\W\:/:/g' | awk -F: '{ system ("ls -al " $2) }'


#-i header


curl_str=$(cat <<EOF
curl \
-X POST -H 'Content-Type: multipart/form-data' \
	-F 'gps=0.0,0.0' \
	-F 'detected_object=policeman(90%)' \
	-F 'app_id=1234' \
	-F 'app_token=42134' \
	-F "files=@/mnt/sandisk/detection-_00002842.jpg" \
	-F 'simple_form=1' \
https://jetson-nano.mail2you.net/server/php/index.php
EOF
)

clear
echo $curl_str
$curl_str

echo "**********************"

post_server_str=$(cat <<EOF
 | sed 's/JETSON_NANO_DETECTION\://g' | sed 's/\,\W\:/:/g' | awk -F: '{ system ( "$curl_str" ) }'
EOF
)

#post_server_str =" | sed 's/JETSON_NANO_DETECTION\://g' | sed 's/\,\W\:/:/g' | awk -F: '{ system (\" \" $2) }' ";


#echo $post_server_str

post_server_str=$(cat <<EOF
echo $temptemp $post_server_str
EOF
)

echo $post_server_str
eval $post_server_str