#include <gazebo_msgs/SpawnModel.h>
//#include <ros/package.h>
#include <ros/ros.h>
#include <fstream>


/* 
 * Script that Spawns a Conveyor in Gazebo (actually not useful)
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

  std::string file_path = "/robot_ws/src/r2000_description/urdf/conveyor.urdf";

  std::string urdf = getFile(file_path);

  ros::ServiceClient spawnClient = nh.serviceClient<gazebo_msgs::SpawnModel>("/gazebo/spawn_urdf_model");
  gazebo_msgs::SpawnModel::Request spawn_model_req;
  gazebo_msgs::SpawnModel::Response spawn_model_resp;

  spawn_model_req.initial_pose.position.x = 1.5;
  spawn_model_req.initial_pose.position.y = -3;
  spawn_model_req.reference_frame = "world";
  spawn_model_req.model_name = "conv1";
  spawn_model_req.model_xml = urdf;

  bool call_service = spawnClient.call(spawn_model_req, spawn_model_resp);
  if (call_service)
  {
    if (spawn_model_resp.success)
    {
      ROS_INFO_STREAM("model has been spawned");
    }
    else
    {
      ROS_INFO_STREAM("model spawn failed");
    }
  }
  else
  {
    ROS_INFO("fail in first call");
    ROS_ERROR("fail to connect with gazebo server");
    return 0;
  }
  
  spawn_model_req.initial_pose.position.y = 3;
  spawn_model_req.model_name = "conv2";

  call_service = spawnClient.call(spawn_model_req, spawn_model_resp);
  if (call_service)
  {
    if (spawn_model_resp.success)
    {
      ROS_INFO_STREAM("model has been spawned");
    }
    else
    {
      ROS_INFO_STREAM("model spawn failed");
    }
  }
  else
  {
    ROS_INFO("fail in first call");
    ROS_ERROR("fail to connect with gazebo server");
    return 0;
  }
}