gst-launch-1.0 v4l2src device="/dev/video0" ! "video/x-raw, width=(int)1920, height=(int)1080, format=(string)YUY2" ! xvimagesink -e

