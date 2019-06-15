#!/bin/bash

 gst-launch-1.0 \
	videomixer name=mixer sink_1::xpos=960 sink_1::ypos=0 sink_2::xpos=0 sink_2::ypos=0 ! \
		videoconvert ! nvvidconv ! nvoverlaysink overlay-x=100 overlay-y=100 overlay-w=640 overlay-h=480 overlay=1 sync=false async=false \
	videotestsrc pattern=13 ! "video/x-raw,format=AYUV, framerate=1/1, width=1920, height=1080" ! \
		clockoverlay time-format="%Y/%m/%d %H:%M:%S" ! \
		queue2 ! mixer. \
	v4l2src io-mode=2 device=/dev/video0 do-timestamp=true ! \
		'image/jpeg, width=1280, height=720, framerate=30/1' ! \
		jpegparse ! nvjpegdec ! 'video/x-raw,format=I420' ! \
		videoconvert ! 'video/x-raw,format=(string)BGR' ! \
		videoscale ! video/x-raw, width=960 ! \
		timeoverlay ! queue2 ! mixer. \
	v4l2src io-mode=2 device=/dev/video1 do-timestamp=true ! \
		'image/jpeg, width=1280, height=720, framerate=30/1' ! \
		jpegparse ! nvjpegdec ! 'video/x-raw,format=I420' ! \
		videoconvert ! 'video/x-raw,format=(string)BGR' ! \
		videoscale ! video/x-raw, width=960 ! \
		timeoverlay ! queue2 ! mixer. \

exit 1

gst-launch-1.0 \
videotestsrc pattern=1 \
	! video/x-raw,format=I420, framerate=\(fraction\)10/1, width=100, height=100 \
	! mix. \
v4l2src io-mode=2 device=/dev/video0 do-timestamp=true \
    ! 'image/jpeg, width=1920, height=1080, framerate=30/1' \
	! jpegparse ! jpegdec ! 'video/x-raw,format=I420' \
	! videoconvert ! 'video/x-raw,format=(string)BGR' \
	! mix. \
v4l2src io-mode=2 device=/dev/video1 do-timestamp=true \
    ! 'image/jpeg, width=1280, height=720, framerate=30/1' \
	! jpegparse ! jpegdec ! 'video/x-raw,format=I420' \
	! videoconvert ! 'video/x-raw,format=(string)BGR' \
	! videoscale ! video/x-raw, width=960 \
! videomixer name=mix sink_2::xpos=20 sink_2::ypos=20 sink_2::zorder=3 sink_3::xpos=100 sink_3::ypos=100 sink_3::zorder=3\
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