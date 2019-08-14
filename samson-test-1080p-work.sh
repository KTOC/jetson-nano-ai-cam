#/bin/bash

#gst-launch-1.0 v4l2src device="/dev/video0" ! "video/x-raw, width=(int)1920, height=(int)1080, format=(string)YUY2" ! xvimagesink -e

gst-launch-1.0 v4l2src  device=/dev/video0 do-timestamp=true ! image/jpeg, width=1920, height=1080, framerate=30/1 ! jpegparse ! nvjpegdec ! video/x-raw ! nvvidconv ! 'video/x-raw(memory:NVMM)' ! fpsdisplaysink video-sink=fakesink  text-overlay=false sync=false async=false -e


#gst-launch-1.0 v4l2src device=/dev/video0 do-timestamp=true ! image/jpeg, width=1920, height=1080, framerate=30/1 ! jpegparse ! nvjpegdec ! video/x-raw ! nvvidconv ! 'video/x-raw(memory:NVMM), format=(string)RGBA' ! nvoverlaysink sync=false -e

#gst-launch-1.0 v4l2src io-mode=2 device=/dev/video0 ! image/jpeg, width=1920, height=1080, framerate=30/1 ! jpegparse ! nvjpegdec ! video/x-raw !  'video/x-raw(memory:NVMM),format=NV12' !  fpsdisplaysink video-sink=nvoverlaysink text-overlay=true -v -e
