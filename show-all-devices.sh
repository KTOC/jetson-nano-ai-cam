#/bin/bash

v4l2-ctl --list-devices


for d in /dev/video* ; 
do 
	echo $d ; 
	v4l2-ctl --device=$d -D --list-formats-ext  ;
	echo '===============' ; 
done

