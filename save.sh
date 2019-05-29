#!/bin/bash

today=`date +%Y-%m-%d.%H:%M:%S`

#gst-launch-1.0 -v -e v4l2src  io-mode=2  device="/dev/video0" ! "image/jpeg, width=(int)1280, height=(int)720, framerate=30/1" ! jpegparse! tee name=t  \
#       t. ! queue ! multipartmux ! filesink location=gstreamer-$today.mp4 \
#       t. ! queue ! jpegdec !  nveglglessink sync=false



gst-launch-1.0 -v -e v4l2src io-mode=2 device=/dev/video1 do-timestamp=true ! video/x-h264,width=1920,height=1080,framerate=30/1,streamformat=byte-stream !  tee name=t  \
 t. ! omxh264dec ! omxh264enc bitrate=12000000 preset-level=2 ! video/x-h264, streamformat=byte-stream ! h264parse ! mp4mux  ! filesink location=gstreamer-$today.mp4 \
 t. ! omxh264dec ! videoconvert ! timeoverlay ! nveglglessink sync=false


#gst-launch-1.0 -v -e v4l2src io-mode=2 device=/dev/video1 do-timestamp=true ! video/x-h264,width=1920,height=1080,framerate=30/1,streamformat=byte-stream ! tee name=t  \
# t. ! omxh264dec !  nvvidconv ! 'video/x-raw(memory:NVMM), width=(int)1280, height=(int)720, format=(string)I420' ! omxh264enc preset-level=2! video/x-h264, streamformat=byte-stream,profile=high,control-rate=variable,target-bitrate=5000000,quant-i-frames=250  ! h264parse ! qtmux ! filesink location=test.mp4 \
# t. ! omxh264dec !  videoconvert ! timeoverlay ! nveglglessink sync=false

#  omxh264dec ! nvvidconv ! 'video/x-raw(memory:NVMM), width=(int)640, height=(int)480, format=(string)I420' ! omxh264enc ! video/x-h264, streamformat=byte-stream ! h264parse ! qtmux ! filesink location=test.mp4

