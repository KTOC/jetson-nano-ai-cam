#!/bin/bash
clear


declare -A VIDEO_CAMERA_INPUTS

today=`date +%Y-%m-%d.%H:%M:%S`

shopt -s nullglob
video_camera_array=(/dev/video*)
shopt -u nullglob # Turn off nullglob to make sure it doesn't interfere with anything later



if (( ${#video_camera_array[@]} == 0 )); then
    echo "No Cameras found" >&2
    exit 0
fi

echo "Found devices ============================";
echo "${video_camera_array[@]}"
echo ""


##----GET basic info
##for i in ${video_camera_array[@]}

this_device_id="nothing"

for (( i=0; i<${#video_camera_array[@]}; i++ ));
do
	#echo $i

	this_device_id="${video_camera_array[$i]}"

	VIDEO_CAMERA_INPUTS[$i,0]="$this_device_id"

	#v4l2-ctl --device=$this_device_id --list-formats-ext

	#get Name
	VIDEO_CAMERA_INPUTS[$i,1]=$(v4l2-ctl --device=$this_device_id --all | grep "Card.*type" | cut -d ' ' -f 8-)

	if [[ $(v4l2-ctl --device=$this_device_id --list-formats-ext --list-formats | awk '/YUYV'/ | wc -l ) > 0 ]];
	then
		VIDEO_CAMERA_INPUTS[$i,2]="YUYV"
	fi

	if [[ $(v4l2-ctl --device=$i --list-formats-ext --list-formats | awk '/MJPG'/ | wc -l ) > 0 ]]; 
	then
		VIDEO_CAMERA_INPUTS[$i,2]="MJPG"
	fi

	if [[ $(v4l2-ctl --device=$i --list-formats-ext --list-formats | awk '/H264'/ | wc -l ) > 0 ]]; 
	then
		VIDEO_CAMERA_INPUTS[$i,2]="H264"
	fi


	#get Width
	#VIDEO_CAMERA_INPUTS[$i,4]=$(v4l2-ctl --device=$this_device_id --all | grep "Width\/Height" | cut -d ' ' -f 8- | cut -d '/' -f 1)

	#get Height
	#VIDEO_CAMERA_INPUTS[$i,5]=$(v4l2-ctl --device=$this_device_id --all | grep "Width\/Height" | cut -d ' ' -f 8- | cut -d '/' -f 2)





done


##----Get Frame Size

#IFS=$'\n\r'


printf "\nGet Frame Size ============================\n\n";

for (( i=0; i<${#video_camera_array[@]}; i++ ));
do	 
	#echo "$i. Doing: v4l2-ctl --device=${VIDEO_CAMERA_INPUTS[$i,0]} --list-framesizes=${VIDEO_CAMERA_INPUTS[$i,2]} "

	VIDEO_CAMERA_INPUTS[$i,3]=$( v4l2-ctl --device=${VIDEO_CAMERA_INPUTS[$i,0]} --list-framesizes=${VIDEO_CAMERA_INPUTS[$i,2]} | cut -d ' ' -f 3-  )

	#echo "${VIDEO_CAMERA_INPUTS[$i,3]}"  #in multiple line

	#put it into temp_array
	IFS=$'\n\r'
	readarray -t temp_array <<< ${VIDEO_CAMERA_INPUTS[$i,3]}


	#sort it reverse
	sorted_array=($(sort -t 'x' -k 2n <<<"${temp_array[*]}"))

	VIDEO_CAMERA_INPUTS[$i,4]="${sorted_array[-1]}" ##THE hight resolution the cam can do

	selected_width=0
	selected_height=0

	##test if it can do 30 fps by testing with string 30.000 fps
	for ((j=${#sorted_array[@]}-1; j>=0; j-- ));
	do
		this_res="${sorted_array[$j]}"
		#printf  "\n[$j) $this_res]: "
		this_width=$( printf ${this_res} | cut -d 'x' -f 1 ) 
		this_height=$( printf ${this_res} | cut -d 'x' -f 2 ) 

		selected_width=$this_width
		selected_height=$this_height

		#printf  "debug: v4l2-ctl --device=${VIDEO_CAMERA_INPUTS[$i,0]} --list-frameintervals=width=$this_width,height=$this_height,pixelformat=${VIDEO_CAMERA_INPUTS[$i,2]} \n"

		this_fps_string="$( v4l2-ctl --device=${VIDEO_CAMERA_INPUTS[$i,0]} --list-frameintervals=width=$this_width,height=$this_height,pixelformat=${VIDEO_CAMERA_INPUTS[$i,2]} )"

		##printf  "$this_fps_string"

		if [[ $this_fps_string ==  *"30.000 fps"* ]]; then
			#printf "\nyes\n"
			break	##break loop, as it is supported, not need find another one
		fi
	done
	

	#echo "Final array: ${sorted_array[*]}"

	VIDEO_CAMERA_INPUTS[$i,5]="${selected_width}"
	VIDEO_CAMERA_INPUTS[$i,6]="${selected_height}"

	#printf "\nSelected Size: ${selected_width}  x  ${selected_height}"
	#printf  "\n\n------------------------\n";

done


echo ""

echo "Output ============================";

for (( i=0; i<${#video_camera_array[@]}; i++ ));
do
	echo $i

	echo ${VIDEO_CAMERA_INPUTS[$i,0]}
	echo ${VIDEO_CAMERA_INPUTS[$i,1]}
	echo ${VIDEO_CAMERA_INPUTS[$i,2]}
	#echo ${VIDEO_CAMERA_INPUTS[$i,3]}
	echo ${VIDEO_CAMERA_INPUTS[$i,4]}
	echo ${VIDEO_CAMERA_INPUTS[$i,5]}
	echo ${VIDEO_CAMERA_INPUTS[$i,6]}

	echo "------------------------";

done


#echo "${VIDEO_CAMERA_INPUTS[@]}" 

printf "\nWhich Camera would you like to use?"
read camera_num
printf "\nOK, choosen: ${VIDEO_CAMERA_INPUTS[$camera_num,1] ${VIDEO_CAMERA_INPUTS[$camera_num,0]\n"