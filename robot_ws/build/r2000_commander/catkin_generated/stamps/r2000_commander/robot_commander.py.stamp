#!/usr/bin/env python
from multiprocessing.connection import wait
import sys, rospy, tf, moveit_commander, random
import copy
from geometry_msgs.msg import Pose, Point, Quaternion
from gazebo_msgs.msg import ContactsState
from time import sleep

"""
    Script that automatically commands the robot.
    Subscribes to a bumper sensor topic. When a box touches the bumper, the robot performs
    a pick and place operation with that box
"""
class RobotCommander:
    def __init__(self):
        self.arm = moveit_commander.MoveGroupCommander("arm")
        self.hand = moveit_commander.MoveGroupCommander("hand")
        self.arm.set_goal_position_tolerance(0.01)
        self.arm.set_goal_orientation_tolerance(0.1)
        self.arm.set_planning_time(0.1)
        self.arm.set_max_acceleration_scaling_factor(.8)
        self.arm.set_max_velocity_scaling_factor(.8)
        self.isBoxPresent = False
        self.subscriber = rospy.Subscriber('knife_bumper', ContactsState, self.callback)

    def callback(self,ContactData):
        if (len(ContactData.states) != 0):
            self.isBoxPresent = True

    def validPose(self,x, y, z, phi, theta, psi):
        orient = Quaternion(*tf.transformations.quaternion_from_euler(phi, theta, psi))
        pose = Pose(Point(x, y, z), orient)
        return pose

    def deposito(self):
        joint_goal = self.arm.get_current_joint_values()
        joint_goal[0] = 0.55
        joint_goal[1] = 1.04
        joint_goal[2] = -0.28
        joint_goal[3] = 3.14
        joint_goal[4] = 0.2
        joint_goal[5] = 1.02
        self.arm.go(joint_goal, wait=True)

    def PickBox(self):
        joint_goal = self.hand.get_current_joint_values()
        joint_goal[0] -= 0.06
        joint_goal[1] += 0.06
        while (not robot_commander.isBoxPresent):
            sleep(0.5)
            pass
        self.hand.go(joint_goal, wait=True)
        self.isBoxPresent = False

    def OpenGripper(self):
        joint_goal = self.hand.get_current_joint_values()
        joint_goal[0] = 0
        joint_goal[1] = 0
        self.hand.go(joint_goal, wait=True)

    def ReleaseBox(self):
        joint_goal = self.hand.get_current_joint_values()
        joint_goal[0] += 0.0105
        joint_goal[1] -= 0.0105
        self.hand.go(joint_goal, wait=True)

    def PickCartesianPath(self):
        waypoints = []
        prelievo = self.validPose(1.5,-0.95,2, 3.14, 0, 1.57)
        waypoints.append(copy.deepcopy(prelievo))
        # We want the Cartesian path to be interpolated at a resolution of 1 cm
        # which is why we will specify 0.01 as the eef_step in Cartesian
        # translation.  We will disable the jump threshold by setting it to 0.0 disabling:
        plan, fraction = self.arm.compute_cartesian_path(
                                        waypoints,   # waypoints to follow
                                        0.01,        # eef_step
                                        0.0)         # jump_threshold
        self.arm.execute(plan,wait=True)
        # Note: We are just planning, not asking move_group to actually move the robot yet:
        #return plan, fraction
    
    def PlaceCartesianPath(self,place_pose):
        waypoints = []
        wpose = copy.deepcopy(place_pose)
        wpose.position.z += 0.5
        waypoints.append(copy.deepcopy(wpose))
        waypoints.append(copy.deepcopy(place_pose))
        # We want the Cartesian path to be interpolated at a resolution of 1 cm
        # which is why we will specify 0.01 as the eef_step in Cartesian
        # translation.  We will disable the jump threshold by setting it to 0.0 disabling:
        plan, fraction = self.arm.compute_cartesian_path(
                                        waypoints,   # waypoints to follow
                                        0.01,        # eef_step
                                        0.0)         # jump_threshold
        self.arm.execute(plan,wait=True)
        # Note: We are just planning, not asking move_group to actually move the robot yet:
        #return plan, fraction

    def Home(self):
        waypoints = []
        wpose = self.arm.get_current_pose().pose
        wpose.position.z += 0.5   # First move up (z)
        boa = self.validPose(1.5,0,2.5, 3.14, 0, 1.57)
        waypoints.append(copy.deepcopy(wpose))
        waypoints.append(copy.deepcopy(boa))
        plan, fraction = self.arm.compute_cartesian_path(
                                        waypoints,   # waypoints to follow
                                        0.01,        # eef_step
                                        0.0)         # jump_threshold
        self.arm.execute(plan,wait=True)

if __name__ == '__main__':
    moveit_commander.roscpp_initialize(sys.argv)
    rospy.init_node('r2000_commander')

    sleep(10) # has to start after gazebo initialization

    robot_commander = RobotCommander()

    yGripper = 0.55
    zGripper = 0.4
    boxX = 0.4
    boxY = 0.4
    offset = yGripper/2 - boxY/2

    box_proximity_distance = 0.018
    deposit_center = robot_commander.validPose(1.5,0.95,2, 3.14, 0, 1.57)
    xDeposit = 1.5
    yDeposit = 0.95
    zDeposit = 2
    boxes=[]
    box1 = robot_commander.validPose(xDeposit+boxX/2+box_proximity_distance, yDeposit+boxY/2+box_proximity_distance - offset, zDeposit, 3.14, 0, 1.57)
    box2 = robot_commander.validPose(xDeposit-boxX/2-box_proximity_distance, yDeposit+boxY/2+box_proximity_distance - offset, zDeposit, 3.14, 0, 1.57)
    box3 = robot_commander.validPose(xDeposit+boxX/2+box_proximity_distance, yDeposit-boxY/2-box_proximity_distance - offset, zDeposit, 3.14, 0, 1.57)
    box4 = robot_commander.validPose(xDeposit-boxX/2-box_proximity_distance, yDeposit-boxY/2-box_proximity_distance - offset, zDeposit, 3.14, 0, 1.57)
    boxes.append(copy.deepcopy(box1))
    boxes.append(copy.deepcopy(box2))
    boxes.append(copy.deepcopy(box3))
    boxes.append(copy.deepcopy(box4))
    
    robot_commander.OpenGripper()    
    robot_commander.Home()
    
    for box in boxes:
        robot_commander.PickCartesianPath()
        robot_commander.PickBox()
        robot_commander.Home()
        robot_commander.PlaceCartesianPath(copy.deepcopy(box))
        robot_commander.ReleaseBox()
        robot_commander.Home()
        robot_commander.OpenGripper()
    
    moveit_commander.roscpp_shutdown()


