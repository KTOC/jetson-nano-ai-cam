#gst-launch-1.0 nvarguscamerasrc ! 'video/x-raw(memory:NVMM),width=1640, height=1232, framerate=30/1, format=NV12' ! nvvidconv flip-method=2 ! nvegltransform ! nveglglessink -e


#gst-launch-1.0 nvarguscamerasrc sensor-id=0 ! capsfilter caps="$CAPS" ! omxh264enc ! \
               #mpegtsmux ! filesink location=test.ts


#gst-launch-1.0 nvarguscamerasrc ! 'video/x-raw(memory:NVMM),width=1640, height=1232, framerate=30/1, format=NV12' ! nvvidconv flip-method=2 ! nvoverlaysink -e


./darknet detector demo cfg/samson-obj.data cfg/samson-yolov3-tiny.cfg backup/samson-yolov3-tiny_final.weights "nvarguscamerasrc ! video/x-raw(memory:NVMM), width=(int)1640, height=(int)1232, format=(string)NV12, framerate=(fraction)30/1 ! nvvidconv flip-method=2 ! video/x-raw, format=(string)BGRx ! videoconvert ! video/x-raw, format=(string)BGR ! appsink" -thresh 0.4 -dont_show -mjpeg_port 8090