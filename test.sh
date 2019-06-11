temptemp=$(cat <<EOF
JETSON_NANO_DETECTION:person 43%, person 42%, person 42%, person 41%, :/home/samson/images/d20190610-080932_0000000002.jpg 
EOF
)
echo $temptemp


echo
echo
echo

#echo $temptemp | grep JETSON_NANO_DETECTION | sed 's/JETSON_NANO_DETECTION\://g'
#echo $temptemp | grep JETSON_NANO_DETECTION | sed 's/JETSON_NANO_DETECTION\://g' | sed 's/\,\W\:/:/g'
#echo $temptemp | grep JETSON_NANO_DETECTION | sed 's/JETSON_NANO_DETECTION\://g' | sed 's/\,\W\:/:/g' | awk -F: '{print $1 $2}'

#echo $temptemp | grep JETSON_NANO_DETECTION | sed 's/JETSON_NANO_DETECTION\://g' | sed 's/\,\W\:/:/g' | awk -F: '{print $2}' | xargs ls -al

#echo $temptemp | grep JETSON_NANO_DETECTION | sed 's/JETSON_NANO_DETECTION\://g' | sed 's/\,\W\:/:/g' | awk -F: '{ system ("ls -al " $2) }'


#-i header


clear
echo "**********************"

#post_server_str=$(cat <<EOF
# | grep JETSON_NANO_DETECTION | sed 's/JETSON_NANO_DETECTION\://g' | sed 's/\,\W\:/:/g' | awk -F: '{ system ( "/home/samson/jetson-nano-ai-cam/send_http.sh $1 $2" ) }'
#EOF
#)

#post_server_str=$(cat <<EOF
# | grep JETSON_NANO_DETECTION | sed 's/JETSON_NANO_DETECTION\://g' | sed 's/ //g' | sed 's/\,\W/ /g' | awk -v myvar="abc" '
# BEGIN{
#	to_run = "/home/samson/jetson-nano-ai-cam/send_http.sh \$1 \$2 $myvar" 
#	system("./send_http.sh \$1")
#	$to_run
#}
# '  
#EOF
#)



#tail -f demo_log.log

tail -f demo_log.log | gawk -F: '/JETSON_NANO_DETECTION:[.]*/ { gsub(/,\s\W/, ":"); gsub(/,\s/, ","); print $2 "--"$3} '


tail -f demo_log.log | gawk -F: '/JETSON_NANO_DETECTION:[.]*/ { gsub(/,\s\W/, ":"); gsub(/,\s/, ","); system("/home/samson/jetson-nano-ai-cam/send_http.sh" " \"" $2 "\" " $3)} '

#tail -f demo_log.log | grep JETSON_NANO_DETECTION | sed 's/JETSON_NANO_DETECTION\://g' | sed 's/ //g' | sed 's/\,\W/|/g' | gawk -F'|' '{system ("/home/samson/jetson-nano-ai-cam/send_http.sh" " " $1" "$2 )}  '

#post_server_str=$(cat <<EOF
# | grep JETSON_NANO_DETECTION | sed 's/JETSON_NANO_DETECTION\://g' | sed 's/ //g' | sed 's/\,\W/|/g' | awk -F'|' '{ system #("/home/samson/jetson-nano-ai-cam/send_http.sh "\$1" "\$2) }  '  
#EOF
#)






#post_server_str =" | sed 's/JETSON_NANO_DETECTION\://g' | sed 's/\,\W\:/:/g' | awk -F: '{ system (\" \" $2) }' ";


#echo $post_server_str

#post_server_str=$(cat <<EOF
#echo $temptemp $post_server_str
#EOF
#)


#post_server_str=$(cat <<EOF
#tail -f demo_log.log $post_server_str
#EOF
#)

#echo $post_server_str

echo
#eval $post_server_str
echo
echo
tail -2 /home/samson/jetson-nano-ai-cam/send_http.log