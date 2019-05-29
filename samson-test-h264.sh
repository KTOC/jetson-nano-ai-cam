#!/bin/bash

today=`date +%Y-%m-%d.%H:%M:%S`



#v4l2-ctl --device=/dev/video0 -D --list-formats-ext


#v4l2-ctl --device=/dev/video0 --set-fmt-video=width=1080,height=720,pixelformat=1


#V4L2_PIX_FMT_MJPEG
				#pixelformat = V4L2_PIX_FMT_MJPEG;
				#pixelformat = V4L2_PIX_FMT_YUYV;
				#pixelformat = V4L2_PIX_FMT_MPEG
				#pixelformat = V4L2_PIX_FMT_H264;
				#pixelformat = V4L2_PIX_FMT_MP2T;

#v4l2-ctl --device=/dev/video0 --set-fmt-video=width=1920,height=1080,pixelformat=MJPEG

##working MJPEG samson
#gst-launch-1.0 -v -e v4l2src  io-mode=2  device="/dev/video0" ! "image/jpeg, width=(int)1280, height=(int)720, framerate=30/1" ! jpegparse ! jpegdec ! videoconvert ! xvimagesink sync=false

##around 52% cpu
#gst-launch-1.0 -v -e v4l2src  io-mode=2  device="/dev/video0" ! "image/jpeg, width=(int)1920, height=(int)1080, framerate=30/1" ! jpegparse ! jpegdec !  nveglglessink sync=false

#usbmon

#fmpeg -f v4l2 -list_formats all -i /dev/video0

#fmpeg -f v4l2 -list_formats all -i /dev/video1


#gst-launch-1.0 v4l2src device="/dev/video1" ! "video/x-raw, width=(int)1920, height=(int)1080, format=(string)YUY2" ! xvimagesink -e


#gst-launch-1.0 -v -e v4l2src  io-mode=2  device="/dev/video0" ! "image/jpeg, width=(int)1280, height=(int)720, framerate=30/1" ! jpegparse ! jpegdec ! filesink location=gstreamer-test.mp4

# ss << "format=YUY2 ! videoconvert ! video/x-raw, format=RGB ! videoconvert !";


#gst-launch-1.0 v4l2src device="/dev/video0" ! "video/x-raw, ! queue ! video/x-h264,width=1920,height=1080,framerate=30/1 ! h264parse ! avdec_h2643 ! xvimagesink sync=false

gst-launch-1.0 -v -e v4l2src device="/dev/video1" ! queue ! "video/x-h264,width=1920,height=1080,framerate=30/1" ! h264parse ! avdec_h264 ! xvimagesink sync=false


## working h264
#gst-launch-1.0 -v -e v4l2src device="/dev/video1" ! \
#	"video/x-h264,width=1920,height=1080,framerate=30/1, format=NV12" \
#	! queue ! h264parse ! omxh264dec disable-dvfs=1 enable-low-outbuffer=1  \
#	!  nveglglessink sync=false 


#gst-launch-1.0 -v -e v4l2src device="/dev/video1" ! "video/x-h264,width=1920,height=1080,framerate=30/1,streamformat=(string)byte-stream" !  h264parse ! omxh264dec ! nveglglessink sync=false 

#nvoverlaysink

#Working great
#around 14%% cpu utilization

#gst-launch-1.0 -v -e v4l2src io-mode=2 device="/dev/video1" ! "video/x-h264,width=1920,height=1080,framerate=30/1,streamformat=(string)byte-stream" ! omxh264dec  !  videoconvert ! nveglglessink sync=false 

#gst-launch-1.0 -v -e v4l2src io-mode=2 device=/dev/video1 ! video/x-h264,width=1920,height=1080,framerate=30/1,streamformat=byte-stream ! omxh264dec ! nvvidconv ! video/x-raw,chroma-site=unknown ! videoconvert ! xvimagesink sync=false

#gst-launch-1.0 -v -e v4l2src io-mode=2 device="/dev/video1" ! "video/x-h264,width=1920,height=1080,framerate=30/1,streamformat=(string)byte-stream" ! omxh264dec  !  videoconvert ! fpsdisplaysink video-sink=nveglglessink sync=false 


#gst-launch-1.0 -v -e filesrc location=i_am.mp4 ! qtdemux ! h264parse ! omxh264dec ! nveglglessink sync=false



# ss << "format=YUY2 ! videoconvert ! video/x-raw, format=RGB ! videoconvert !";


