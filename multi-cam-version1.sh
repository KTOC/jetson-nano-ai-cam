#!/bin/bash

gst-launch-1.0 -e \
v4l2src io-mode=2 device=/dev/video0 do-timestamp=true \
    ! 'image/jpeg, width=1920, height=1080, framerate=30/1' \
	! jpegparse ! jpegdec ! 'video/x-raw,format=I420' \
	! videoconvert ! 'video/x-raw,format=(string)BGR' \
    ! queue \
	! mix. \
v4l2src io-mode=2 device=/dev/video1 do-timestamp=true \
    ! 'image/jpeg, width=1280, height=720, framerate=30/1' \
	! jpegparse ! jpegdec ! 'video/x-raw,format=I420' \
	! videoconvert ! 'video/x-raw,format=(string)BGR' \
	! videoscale ! video/x-raw, width=960 \
    ! queue \
! videomixer name=mix \
    ! videoconvert ! 'video/x-raw,format=(string)NV12' \
	! nvvidconv ! nvoverlaysink sync=false async=false  -e 

#videoconvert ! video/x-raw,format=(string)BGR
#nvvidconv ! 'video/x-raw(memory:NVMM), format=(string)RGBA' ! nvoverlaysink sync=false async=false"

	#! videocrop top=100 left=100 right=100 bottom=100 \
#		! videoscale ! video/x-raw, width=640 \

#v4l2src io-mode=2 device=/dev/video0 do-timestamp=true \
#    ! 'video/x-raw, format=YUY2, width=1280, height=720, framerate=30/1' \
#	! videoconvert ! 'video/x-raw, format=I420' \
#	! videoconvert ! 'video/x-raw,format=(string)BGR' \
#    ! queue \