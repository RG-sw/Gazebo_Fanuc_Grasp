#include <gazebo_msgs/SpawnModel.h>
#include <gazebo_msgs/ApplyBodyWrench.h>
#include <stdlib.h> //atoi()
//#include <ros/package.h>
#include <ros/ros.h>
#include <fstream>
#include <string>
#include <chrono>
#include <thread>

/* 
 * Script that Spawns & Moves a Box in Gazebo (this conveyor's world has no friction)
 * 
 * Command Line Input: number of box to spawn
 */

std::string getFile(std::string filename)
{
  std::string buffer;
  char c;

  std::ifstream in(filename);
  if (!in)
  {
    std::cout << filename << " not found";
    exit(1);
  }
  while (in.get(c))
    buffer += c;
  in.close();

  return buffer;
}

int main(int argc, char **argv)
{
  ros::init(argc, argv, "urdf_spawner");
  ros::NodeHandle nh;

  std::this_thread::sleep_for(std::chrono::seconds(15)); // wait for gazebo startup

  std::string file_path = "/robot_ws/src/r2000_description/materials/models/box.sdf";

  std::string sdf = getFile(file_path);

  int box_count = atoi(argv[1]);
  
  ros::ServiceClient spawnClient = nh.serviceClient<gazebo_msgs::SpawnModel>("/gazebo/spawn_sdf_model");
  gazebo_msgs::SpawnModel::Request spawn_model_req;
  gazebo_msgs::SpawnModel::Response spawn_model_resp;

  ros::ServiceClient MoveBoxClient = nh.serviceClient<gazebo_msgs::ApplyBodyWrench>("/gazebo/apply_body_wrench");
  gazebo_msgs::ApplyBodyWrench::Request box_move_req;
  gazebo_msgs::ApplyBodyWrench::Response box_move_resp;

  box_move_req.wrench.force.y = 25;
  box_move_req.duration = ros::Duration (0.001);

  spawn_model_req.initial_pose.position.x = 0; // Should be 1.5 ... :^( 
  spawn_model_req.initial_pose.position.z = 2;
  spawn_model_req.initial_pose.position.y = -3;

  spawn_model_req.reference_frame = "world";
  spawn_model_req.model_xml = sdf;
  
  for(int i=0; i<box_count; ++i){
    
    std::string box_name = "box";
    box_name.append(std::to_string(i));
    spawn_model_req.model_name = box_name;
    spawnClient.call(spawn_model_req, spawn_model_resp);
    if (spawn_model_resp.success)
    {
      std::this_thread::sleep_for(std::chrono::seconds(1));
      box_name.append("::my_box");
      box_move_req.body_name = box_name;
      box_move_req.reference_frame = box_name;
      MoveBoxClient.call(box_move_req, box_move_resp);
      ROS_INFO("model has been spawned");
    }

  }
}