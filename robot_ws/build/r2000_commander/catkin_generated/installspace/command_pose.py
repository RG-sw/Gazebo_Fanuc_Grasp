# !usr/bin/env python

import sys
import copy
import geometry_msgs.msg
import rospy
import moveit_commander
import moveit_msgs.msg

def Prova():
    moveit_commander.roscpp_initialize(sys.argv)
    rospy.init_node('robi_moveit', anonymous=True)
    robot = moveit_commander.RobotCommander()
    
    group_name = "arm"
    move_group = moveit_commander.MoveGroupCommander(group_name)
    group_names = robot.get_group_names()
    print("============ Available Planning Groups:", robot.get_group_names())
    #print("============ Printing robot state", robot.get_current_state(), "")
    print("============ Printing current pose : \n", move_group.get_current_pose(), "\n")
    
    x = input("Press any key.. ")
    '''
    pose_goal_stamped = move_group.get_current_pose() #"tool0"
    pose_goal_stamped.header.frame_id = 'world'
    pose_goal_stamped.pose.position.z -= 0.10
    '''
    pose_goal = geometry_msgs.msg.Pose()
    pose_goal.orientation.w = -0.7
    pose_goal.orientation.x = 0.7
    pose_goal.position.x = 1.5
    pose_goal.position.y = -0.6
    pose_goal.position.z = 0.39

    '''
    position: 
    x: 1.55475618793926
    y: -0.6274070910164764
    z: 0.3905504128603474
    orientation: 
    x: -0.7066006900095315
    y: 0.7075508328577306
    z: 0.00912141019410934
    w: 0.002020810841404175
    '''
    move_group.set_pose_target(pose_goal)#move_group.set_pose_target(pose_goal_stamped)

    plan = move_group.go(wait=True)
    # Calling `stop()` ensures that there is no residual movement
    move_group.stop()
    # It is always good to clear your targets after planning with poses.
    # Note: there is no equivalent function for clear_joint_value_targets()
    move_group.clear_pose_targets()
    print("============ Printing robot state", robot.get_current_state(), "")
    

if __name__ == '__main__':
    try:
        Prova()
    except rospy.ROSInterruptException:
        pass
