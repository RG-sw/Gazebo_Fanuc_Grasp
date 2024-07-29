FROM osrf/ros:noetic-desktop-full

COPY ./robot_ws /robot_ws
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#RUN source /opt/ros/noetic/setup.bash not working
RUN source /opt/ros/noetic/setup.bash
 
RUN apt-get update && \
    apt-get install -y ros-noetic-moveit && \
    apt-get install ros-noetic-joint-trajectory-controller


RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd robot_ws; catkin_make' 
# Command sourced from https://answers.ros.org/question/312577/catkin_make-command-not-found-executing-by-a-dockerfile/
WORKDIR "robot_ws/build"

RUN source ../devel/setup.bash