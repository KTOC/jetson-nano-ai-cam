#/bin/bash



#v4l2-ctl --device=/dev/video0 --list-ctrls

#v4l2-ctl --device=/dev/video1 --set-ctrl brightness=138
#v4l2-ctl --device=/dev/video1 --set-ctrl saturation=149
#v4l2-ctl --device=/dev/video1 --set-ctrl hue=5
#v4l2-ctl --device=/dev/video1 --set-ctrl contrast=120


#gst-launch-1.0 v4l2src device="/dev/video1" ! "video/x-raw, width=(int)1920, height=(int)1080, framerate=60/1, format=(string)YUY2" ! xvimagesink -e

#gst-launch-1.0 v4l2src device="/dev/video1" ! "video/x-raw, width=(int)1920, height=(int)1080, framerate=60/1, format=(string)YUY2" ! xvimagesink sync=false -e


v4l2-ctl --device=/dev/video1 --set-ctrl brightness=146
v4l2-ctl --device=/dev/video1 --set-ctrl saturation=106
v4l2-ctl --device=/dev/video1 --set-ctrl hue=3
v4l2-ctl --device=/dev/video1 --set-ctrl contrast=130


#gst-launch-1.0 v4l2src device="/dev/video1" ! "image/jpeg, width=1920, height=1080, framerate=30/1" ! jpegparse ! jpegdec ! videoconvert ! xvimagesink sync=false


gst-launch-1.0 v4l2src device="/dev/video1" ! "video/x-raw, width=(int)1920, height=(int)1080, framerae=30/1, format=(string)YUY2" ! xvimagesink sync=false -e

#v4l2-ctl --device=/dev/video1 --set-ctrl brightness=140
#v4l2-ctl --device=/dev/video1 --set-ctrl saturation=153
#v4l2-ctl --device=/dev/video1 --set-ctrl hue=0
#v4l2-ctl --device=/dev/video1 --set-ctrl contrast=153
