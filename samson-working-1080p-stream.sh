gst-launch-1.0 -e v4l2src device=/dev/video0 ! image/jpeg, width=1920, height=1080, framerate=30/1 ! jpegparse ! jpegdec ! videoscale ! videoconvert ! nveglglessink sync=false -v
