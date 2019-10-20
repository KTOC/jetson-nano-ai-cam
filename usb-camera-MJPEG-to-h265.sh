#!/bin/bash

#https://devtalk.nvidia.com/default/topic/1063717/jetson-nano/usb-camera-mjpeg-to-h265/
#gst-launch-1.0 -vvv v4l2src device=/dev/video0 do-timestamp=true ! image/jpeg, width=3264, height=2448, framerate=15/1 ! jpegparse ! nvjpegdec ! 'video/x-raw' ! nvvidconv ! 'video/x-raw(memory:NVMM),format=I420,width=1920,height=1080' ! nvoverlaysink

##works with jpegdec instead of nvjpeg with io-mode=2
#gst-launch-1.0 -e -v v4l2src device=/dev/video0 io-mode=2 do-timestamp=true ! image/jpeg, width=1920, height=1080, framerate=30/1 ! jpegparse ! nvjpegdec ! 'video/x-raw(memory:NVMM)' !  nvvidconv ! 'video/x-raw(memory:NVMM),format=I420,width=1920,height=1080' ! nvoverlaysink sync=false 


##works
gst-launch-1.0 -e -v v4l2src device=/dev/video0 ! image/jpeg, width=1920, height=1080, framerate=30/1 ! jpegparse ! jpegdec ! 'video/x-raw' !  nvvidconv ! 'video/x-raw(memory:NVMM),format=I420,width=1920,height=1080' ! nvoverlaysink sync=false


###Encoding to 265 works
#gst-launch-1.0 -e -v v4l2src device=/dev/video0 io-mode=2 do-timestamp=true ! image/jpeg, width=1920, height=1080, framerate=30/1 ! jpegparse ! jpegdec ! 'video/x-raw' !  nvvidconv ! 'video/x-raw(memory:NVMM), format=NV12' ! omxh265enc ! matroskamux ! filesink location=test_MJPG_H265enc.mkv


##test-launch "v4l2src device=/dev/video0 ! image/jpeg, width=1920, height=1080, framerate=30/1, format=MJPG ! jpegdec ! nvvidconv ! video/x-raw(memory:NVMM), format=NV12 ! omxh265enc ! rtph265pay name=pay0 pt=96 config-interval=1 "
