#!/usr/bin/env python
from multiprocessing.connection import wait
import sys, rospy, tf, moveit_commander, random
import copy
from geometry_msgs.msg import Pose, Point, Quaternion
from time import sleep


"""
    Script that palletizes 10 Boxes, placing 2 of these in 'costa' mode.
    'costa' (italian) means placed on a side that's not its base. 
"""
class RobotCommander:
    def __init__(self):
        self.arm = moveit_commander.MoveGroupCommander("arm")
        self.hand = moveit_commander.MoveGroupCommander("hand")
        self.arm.set_goal_position_tolerance(0.01)
        self.arm.set_goal_orientation_tolerance(0.1)
        self.arm.set_planning_time(0.1)
        self.arm.set_max_acceleration_scaling_factor(1)
        self.arm.set_max_velocity_scaling_factor(1)

    def validPose(self,x, y, z, phi, theta, psi):
        orient = Quaternion(*tf.transformations.quaternion_from_euler(phi, theta, psi))
        pose = Pose(Point(x, y, z), orient)
        return pose

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

    def PickBox(self):
        joint_goal = self.hand.get_current_joint_values()
        joint_goal[0] -= 0.06
        joint_goal[1] += 0.06
        self.hand.go(joint_goal, wait=True)

    def PickCartesianPath(self):
        print("INIZIO OPERAZIONE")
        waypoints = []
        boa_prelievo = self.validPose(1.5,-0.95, 2.3, 3.14, 0, -1.57)
        prelievo = self.validPose(1.5,-0.98, 2, 3.14, 0, -1.57)
        waypoints.append(copy.deepcopy(boa_prelievo))
        waypoints.append(copy.deepcopy(prelievo))
        # We want the Cartesian path to be interpolated at a resolution of 1 cm
        # which is why we will specify 0.01 as the eef_step in Cartesian
        # translation.  We will disable the jump threshold by setting it to 0.0 disabling:
        plan, fraction = self.arm.compute_cartesian_path(
                                        waypoints,   # waypoints to follow
                                        0.05,        # eef_step
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
        plan, fraction = self.arm.compute_cartesian_path(
                                        waypoints,   # waypoints to follow
                                        0.05,        # eef_step
                                        0.0)         # jump_threshold
        self.arm.execute(plan,wait=True)

    def Home(self):
        waypoints = []
        wpose = self.arm.get_current_pose().pose
        wpose.position.z += 0.5   # First move up (z)
        boa = self.validPose(1.5,0,2.7, 3.14, 0, -1.57)
        waypoints.append(copy.deepcopy(wpose))
        waypoints.append(copy.deepcopy(boa))
        plan, fraction = self.arm.compute_cartesian_path(
                                        waypoints,   # waypoints to follow
                                        0.01,        # eef_step
                                        0.0)         # jump_threshold
        self.arm.execute(plan,wait=True)

    def HomeCosta(self):
        waypoints = []
        wpose = self.arm.get_current_pose().pose
        wpose.position.z += 0.5   # First move up (z)
        boa = self.validPose(1.5,0,2.7, 3.14, 0, 0)
        waypoints.append(copy.deepcopy(wpose))
        waypoints.append(copy.deepcopy(boa))
        plan, fraction = self.arm.compute_cartesian_path(
                                        waypoints,   # waypoints to follow
                                        0.01,        # eef_step
                                        0.0)         # jump_threshold
        self.arm.execute(plan,wait=True)

    def CostaPick(self):
        waypoints = []
        boa_prelievo = self.validPose(1.5,-0.95,2.3, 3.14, 0, -1.57)
        prelievo = self.validPose(1.5,-0.95,2, 3.14, 0, -1.57)
        #boa = self.validPose(1.5,0,2.7, 3.14, 0, 0)

        waypoints.append(copy.deepcopy(boa_prelievo))
        waypoints.append(copy.deepcopy(prelievo))
        #waypoints.append(copy.deepcopy(boa))
        plan, fraction = self.arm.compute_cartesian_path(
                                        waypoints,   # waypoints to follow
                                        0.05,        # eef_step
                                        0.0)         # jump_threshold
        self.arm.execute(plan,wait=True)


if __name__ == '__main__':
    moveit_commander.roscpp_initialize(sys.argv)
    rospy.init_node('r2000_commander_costa')

    sleep(10) # has to start after gazebo initialization

    robot_commander = RobotCommander()

    yGripper = 0.55
    zGripper = 0.4

    boxX = 0.4
    boxY = 0.4
    offset = yGripper/2 - boxY/2

    box_proximity_distance = 0.018 
    xDeposito = 1.5
    yDeposito = 0.95
    zDeposito = 2

    boxes=[]
    box1 = robot_commander.validPose(1.7+box_proximity_distance, 1.15+box_proximity_distance - offset, zDeposito, 3.14, 0, -1.57)
    box2 = robot_commander.validPose(1.3-box_proximity_distance, 1.15+box_proximity_distance - offset, zDeposito, 3.14, 0, -1.57)
    box3 = robot_commander.validPose(1.7+box_proximity_distance, 1.15+box_proximity_distance - offset, zDeposito+0.21, 3.14, 0, -1.57)
    box4 = robot_commander.validPose(1.3-box_proximity_distance, 1.15+box_proximity_distance - offset, zDeposito+0.21, 3.14, 0, -1.57)    
    box5 = robot_commander.validPose(1.7+box_proximity_distance, 0.9-0.35, 1.8, -1.57, -1.57, 0)
    box6 = robot_commander.validPose(1.3-box_proximity_distance, 0.9-0.35, 1.8, -1.57, -1.57, 0)
    box7 = robot_commander.validPose(1.7+box_proximity_distance, 0.65-box_proximity_distance - offset, zDeposito, 3.14, 0, -1.57)
    box8 = robot_commander.validPose(1.3-box_proximity_distance, 0.65-box_proximity_distance - offset, zDeposito, 3.14, 0, -1.57)
    box9 = robot_commander.validPose(1.7+box_proximity_distance, 0.65-box_proximity_distance - offset, zDeposito+0.21, 3.14, 0, -1.57)
    box10 = robot_commander.validPose(1.3-box_proximity_distance, 0.65-box_proximity_distance - offset, zDeposito+0.21, 3.14, 0, -1.57)
    
    boxes.append(copy.deepcopy(box1))
    boxes.append(copy.deepcopy(box2))
    boxes.append(copy.deepcopy(box3))
    boxes.append(copy.deepcopy(box4))
    boxes.append(copy.deepcopy(box5))
    boxes.append(copy.deepcopy(box6))
    boxes.append(copy.deepcopy(box7))
    boxes.append(copy.deepcopy(box8))
    boxes.append(copy.deepcopy(box9))
    boxes.append(copy.deepcopy(box10))

    robot_commander.OpenGripper()    
    robot_commander.Home()

    i=0
    
    for box in boxes:
        i+=1
        if i==5 or i==6: 
            # places 2 pieces in 'costa' mode
            robot_commander.CostaPick()
            robot_commander.PickBox()
            robot_commander.HomeCosta()
            robot_commander.PlaceCartesianPath(box)
            robot_commander.ReleaseBox()
            robot_commander.HomeCosta()
            robot_commander.OpenGripper()
        else:
            robot_commander.PickCartesianPath()
            robot_commander.PickBox()
            robot_commander.Home()
            robot_commander.PlaceCartesianPath(box)       
            robot_commander.ReleaseBox()
            robot_commander.Home()
            robot_commander.OpenGripper()

    moveit_commander.roscpp_shutdown()


