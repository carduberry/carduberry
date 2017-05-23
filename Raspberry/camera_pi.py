import time
import io
import threading
import picamera
import requests
import os
import json
import re
from google.cloud import vision
import serial

serConn = False
try: #Tries to open a serial connection
	ser = serial.Serial('/dev/ttyACM0', 9600)
	serConn = True
except ValueError:
	print("Can't connect to Arduino")

oldtime = time.time()
vision_client = vision.Client()

def upload(img):
        image = vision_client.image(content=img)

        # Performs label detection on the image file
        labels = image.detect_labels()
	for label in labels:
		if label.description == "signage":
			ser.write("0")
			print("Stop")
		else:
			ser.write("1")
    		

class Camera(object):
    thread = None  # background thread that reads frames from camera
    frame = None  # current frame is stored here by background thread
    last_access = 0  # time of last client access to the camera
    vision_client = vision.Client()

    def initialize(self):
        if Camera.thread is None:
            # start background frame thread
            Camera.thread = threading.Thread(target=self._thread)
            Camera.thread.start()

            # wait until frames start to be available
            while self.frame is None:
                time.sleep(0)

    def get_frame(self):
        Camera.last_access = time.time()
        self.initialize()
        return self.frame

    @classmethod
    def _thread(cls):
        #with picamera.PiCamera(framerate=1) as camera:
	with picamera.PiCamera() as camera:
            # camera setup
	    oldtime = time.time()
            camera.resolution = (320, 240)
            camera.hflip = True
            camera.vflip = True

            # let camera warm up
            camera.start_preview()
            time.sleep(2)
            stream = io.BytesIO()
            for foo in camera.capture_continuous(stream, 'jpeg',
                                                 use_video_port=True):
                # store frame
                stream.seek(0)
                cls.frame = stream.read()
	        stream.seek(0)
	        if time.time() - oldtime > 1 & serConn: #Send a frame to GCP every second and only if serial is true
    			oldtime = time.time()
			upload(stream.read())

	        #r = requests.post(url = API_ENDPOINT, files = {"requests":[{"image":{"content":stream.read()}}]})
        	#file_name_1 = re.findall(r'"url": *"((h.+\/){0,1}(.+))"[,\}]', \
        	#r.text.replace("\\", ""))[0][2]
        	#url = "http://my.mixtape.moe/" + file_name_1
        	#r = requests.get(url = "http://armandoc6.altervista.org/insert.php?url=" + url)


                # reset stream for next frame
                stream.seek(0)
                stream.truncate()

                # if there hasn't been any clients asking for frames in
                # the last 10 seconds stop the thread
                if time.time() - cls.last_access > 10:
                    break
        cls.thread = None
