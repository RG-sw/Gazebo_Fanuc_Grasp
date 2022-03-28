#!/usr/bin/env python
import rospy
from sensor_msgs.msg import Image
import cv2, cv_bridge
import sys, numpy as np
from copy import deepcopy
import moveit_commander
import geometry_msgs.msg
import moveit_msgs.msg
#from sensor_msgs.msg import Image
from r2000_commander.msg import follow
from std_msgs.msg import Header
from time import sleep

class BoxDetector:
  """
    - receives images from EEF camera on topic /camera1/color/image_raw
    - performs OpenCV operations via image_callback()
    - publishes processed image to /boxdetector/image
    - publishes coordinates of detected box on /boxdetector/coords
  """
  def __init__(self):
    self.bridge = cv_bridge.CvBridge()
    # subcribes to camera topic
    self.image_sub = rospy.Subscriber('/camera1/color/image_raw', Image, self.image_callback)
    # publishes a processed image
    self.image_pub = rospy.Publisher('/boxdetector/image', Image, queue_size=1)
    # publishes coordinates of detected box
    self.follow_pub = rospy.Publisher('/boxdetector/coords', follow, queue_size=1)

  def image_callback(self, msg):
    image = self.bridge.imgmsg_to_cv2(msg,desired_encoding='bgr8')
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    image_thresh = cv2.threshold(gray_image,130,255,cv2.THRESH_BINARY)[1]
    kernel = np.ones((5,5),np.uint8)
    
    opening = cv2.morphologyEx(image_thresh, cv2.MORPH_OPEN, kernel)
    edges = cv2.Canny(opening,100,200)
    contours, hierarchy = cv2.findContours(edges, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    if contours: #checks if contours isn't empty 
      cnt = contours[0]
      rect = cv2.minAreaRect(cnt) #returns : ( center (x,y), (width, height), angle of rotation )
      #if rect[1][0] > 200: #Y coordinate of the box..
      box = cv2.boxPoints(rect)
      box = np.int0(box)
      
      offsetX = int(640/2) - int(rect[0][0])
      offsetY = int(480/2) - int(rect[0][1])
      
      cv2.drawContours(image,[box],0,(0,0,255),2)
      cv2.circle(image, (int(rect[0][0]), int(rect[0][1])), 5, (0,0,255), -1)
      cv2.circle(image, (int(640/2), int(480/2)), 5, (0,255,0), -1)
      self.image_pub.publish(self.bridge.cv2_to_imgmsg(image,encoding="bgr8"))#mono8

      #print("\nBOX ANGLE :",rect[2],"OFFSET X :", offsetX, "OFFSET Y ", offsetY)
      fw = follow()
      fw.follow_x = (offsetX*1.34)/1000
      fw.follow_y = (offsetY*1.34)/1000
      fw.rotation = rect[2]
      self.follow_pub.publish(fw)
  

rospy.init_node('box_detector')
sleep(12) # has to start after gazebo initialization
follower = BoxDetector()
rospy.spin()