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

camera_num="-1"

while  ! [[ ("$camera_num" -ge 0) && ("$camera_num" -lt ${#video_camera_array[@]}) ]];
do

	printf "\nWhich Camera would you like to use? "

	end_num=$(( ${#video_camera_array[@]}-1 ))

	printf "[0-${end_num}]\n"	
	read camera_num	
done

printf "\nOK, choosen: $camera_num, ${VIDEO_CAMERA_INPUTS[$camera_num,1]} ${VIDEO_CAMERA_INPUTS[$camera_num,0]}\n"


show_result_onscreen="-1"
while  ! [[ ("$show_result_onscreen" -ge 0) && ("$show_result_onscreen" -lt 2) ]];
do

	printf "\nDo you want to show on screen(need X11) [0-no, 1-yes]? "
	
	read show_result_onscreen	
done


darknet_exe_str="./darknet detector demo cfg/samson-obj.data cfg/samson-yolov3-tiny.cfg backup/samson-yolov3-tiny_final.weights "

v4l2src_pipeline_str="v4l2src io-mode=2 device=${VIDEO_CAMERA_INPUTS[$camera_num,0]} do-timestamp=true ! "

#video/x-raw, width=1920, height=1080, framerate=30/1 ! videoconvert ! tee name=t   t. !  appsink sync=false async=false" 
framerate=30


case ${VIDEO_CAMERA_INPUTS[$camera_num,2]} in

	"YUYV")
		v4l2src_pipeline_str+="video/x-raw, "
		framerate=5
	;;

	"MJPG")
		v4l2src_pipeline_str+="image/jpeg, "
	;;

	"H264")
		v4l2src_pipeline_str+="video/x-h264, "
	;;	

esac


v4l2src_pipeline_str+="width=${VIDEO_CAMERA_INPUTS[$camera_num,5]}, height=${VIDEO_CAMERA_INPUTS[$camera_num,6]}, framerate=$framerate ! "

case ${VIDEO_CAMERA_INPUTS[$camera_num,2]} in

	"YUYV")
		printf ""
	;;

	"MJPG")
		v4l2src_pipeline_str+="jpegparse ! jpegdec ! videoscale ! "
	;;

	"H264")
		v4l2src_pipeline_str+="omxh264dec ! "
	;;	

esac


v4l2src_pipeline_str+="videoconvert ! appsink sync=false async=false "

#printf "$v4l2src_pipeline_str\n\n";

darknet_exe_str+=" \"$v4l2src_pipeline_str\" "

case ${show_result_onscreen} in

	"0")
		darknet_exe_str+="-dont_show -mjpeg_port 8090 -json_port 8070 -map"
	;;

	"1")
		darknet_exe_str+="--thresh 0.4"
	;;

esac

printf "$darknet_exe_str \n\n";


#"v4l2src io-mode=2 device=/dev/video1 do-timestamp=true ! video/x-raw, width=1920, height=1080, framerate=30/1 ! videoconvert ! tee name=t   t. !  appsink sync=false async=false" -dont_show -mjpeg_port 8090 -json_port 8070 -map

#./darknet detector demo cfg/samson-obj.data cfg/samson-yolov3-tiny.cfg backup/samson-yolov3-tiny_final.weights "v4l2src io-mode=2 device=/dev/video1 do-timestamp=true ! image/jpeg, width=1920, height=1080, framerate=10/1 ! jpegparse ! jpegdec ! videoscale ! videoconvert ! appsink sync=false async=false" --thresh 0.4


#./darknet detector demo cfg/samson-obj.data cfg/samson-yolov3-tiny.cfg backup/samson-yolov3-tiny_final.weights "v4l2src io-mode=2 device=/dev/video1 do-timestamp=true ! video/x-h264, width=1920, height=1080, framerate=10/1, streamformat=byte-stream !  omxh264dec ! videoconvert ! appsink sync=false async=false" --thresh 0.4

cd /home/samson/install_yolo/AlexeyAB/darknet
($darknet_exe_str)

#nohup command &>/dev/null &