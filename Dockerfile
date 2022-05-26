FROM osrf/ros:noetic-desktop-full
RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/RG-sw/Gazebo_Fanuc_Grasp.git -b dockerfile-missing
#RUN source /opt/ros/noetic/setup.bash 
#RUN cd Gazebo_Fanuc_Grasp/robot_ws && rm -r build && rm -r devel
RUN apt install -y ros-noetic-moveit && \
    apt-get install ros-noetic-joint-trajectory-controller


