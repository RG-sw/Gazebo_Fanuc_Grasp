FROM osrf/ros:noetic-desktop-full

COPY ./robot_ws /robot_ws

#RUN source /opt/ros/noetic/setup.bash not working
RUN . /opt/ros/noetic/setup.sh
 
RUN apt-get update && \
    apt-get install -y ros-noetic-moveit && \
    apt-get install ros-noetic-joint-trajectory-controller


