#!/usr/bin/env python
from multiprocessing.connection import wait
import queue
import sys, rospy, tf, moveit_commander, random
import copy
from geometry_msgs.msg import Pose, Point, Quaternion
from time import sleep, time
from r2000_commander.msg import follow

"""
    Script that receives box coordinates from a ros topic and moves the robot accordingly
"""
class BoxFollower:

    def __init__(self):
        self.arm = moveit_commander.MoveGroupCommander("arm")
        self.hand = moveit_commander.MoveGroupCommander("hand")
        self.arm.set_goal_position_tolerance(0.01)
        self.arm.set_goal_orientation_tolerance(0.1)
        self.arm.set_planning_time(0.1)
        self.arm.set_max_acceleration_scaling_factor(.7)
        self.arm.set_max_velocity_scaling_factor(.7)
        self.subscriber = rospy.Subscriber('boxdetector/coords', follow, self.FollowCallback, queue_size=1)
        self.box_reached = False
        self.EEFrotated = False #True if EEF has rotated. EEF has to rotate only one time.

    def PickBox(self):
        waypoints = []
        wpose = self.arm.get_current_pose().pose
        wpose.position.z -= 0.7
        waypoints.append(copy.deepcopy(wpose))
        plan, fraction = self.arm.compute_cartesian_path(
                                        waypoints,   # waypoints to follow
                                        0.01,        # eef_step
                                        0.0)         # jump_threshold
        self.arm.execute(plan,wait=True)

        joint_goal = self.hand.get_current_joint_values()
        joint_goal[0] -= 0.1
        joint_goal[1] += 0.1
        self.hand.go(joint_goal, wait=True)

    def Home(self):
        waypoints = []
        wpose = self.arm.get_current_pose().pose
        wpose.position.z += 0.5   # First move up (z)
        boa = self.validPose(1.5,0,2.7, 3.14, 0, 1.57)
        waypoints.append(copy.deepcopy(wpose))
        waypoints.append(copy.deepcopy(boa))
        plan, fraction = self.arm.compute_cartesian_path(
                                        waypoints,   # waypoints to follow
                                        0.01,        # eef_step
                                        0.0)         # jump_threshold
        self.arm.execute(plan,wait=True)

    def FollowCallback(self,data):
        
        print('DATA', data)

        # 1) Rotates EEF only 1 time 
        if not self.EEFrotated:
                joints = self.arm.get_current_joint_values()
                joints[5] += (data.rotation)*3.14/180
                self.arm.go(joints, wait=True)
                self.EEFrotated = True

        # 2) For every iteration, if EEF center is too distant from box center,
        # The robot is moved to decrease that distance. 
        wpose = self.arm.get_current_pose().pose        

        if (data.follow_x > 0.01 or data.follow_y > 0.01):# or wpose.position.y < 0:
            
            wpose.position.x += data.follow_x 
            wpose.position.y -= data.follow_y
            waypoints = []
            waypoints.append(copy.deepcopy(wpose))
            plan, fraction = self.arm.compute_cartesian_path(
                                            waypoints,   # waypoints to follow
                                            0.01,        # eef_step
                                            0.0)         # jump_threshold
            self.arm.execute(plan,wait=True)

        else:
            self.box_reached = True  

        
if __name__ == '__main__':
    moveit_commander.roscpp_initialize(sys.argv)
    rospy.init_node('box_follower')
    
    sleep(15) # has to start after gazebo initialization

    box_follower = BoxFollower()

    while (not box_follower.box_reached):
        pass

    box_follower.subscriber.unregister()

    box_follower.PickBox()
    box_follower.Home()

    moveit_commander.roscpp_shutdown()


