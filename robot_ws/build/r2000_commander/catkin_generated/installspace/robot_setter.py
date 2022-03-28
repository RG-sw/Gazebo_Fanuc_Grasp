#!/usr/bin/env python3
import sys, rospy, tf, moveit_commander, random
import copy
from geometry_msgs.msg import Pose, Point, Quaternion
from time import sleep


"""
    Script used during the Gazebo Launch to set the robot arm in 'Ready' position
"""
class RobotSetter:
    def __init__(self):
        self.arm = moveit_commander.MoveGroupCommander("arm")
        self.hand = moveit_commander.MoveGroupCommander("hand")
        self.arm.set_goal_position_tolerance(0.01)
        self.arm.set_goal_orientation_tolerance(0.1)
        self.arm.set_planning_time(0.1)
        self.arm.set_max_acceleration_scaling_factor(1)
        self.arm.set_max_velocity_scaling_factor(1)

    def OpenHand(self):
        joint_goal = self.hand.get_current_joint_values()
        joint_goal[0] = 0
        joint_goal[1] = 0
        self.hand.go(joint_goal, wait=True)

    def PickCartesianPath(self):
        print("INIZIO OPERAZIONE")
        waypoints = []
        prelievo = self.validPose(1.5,-0.95,2.7, 3.14, 0, -1.57)
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


if __name__ == '__main__':
    moveit_commander.roscpp_initialize(sys.argv)
    rospy.init_node('r2000_robot_setter')

    sleep(10) # has to start after gazebo initialization

    robot_setter = RobotSetter()

    robot_setter.PickCartesianPath()
    robot_setter.OpenHand()
    
    moveit_commander.roscpp_shutdown()


