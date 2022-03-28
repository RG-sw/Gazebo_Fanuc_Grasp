// Auto-generated. Do not edit!

// (in-package r2000_commander.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;

//-----------------------------------------------------------

class follow {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.follow_x = null;
      this.follow_y = null;
      this.rotation = null;
    }
    else {
      if (initObj.hasOwnProperty('follow_x')) {
        this.follow_x = initObj.follow_x
      }
      else {
        this.follow_x = 0.0;
      }
      if (initObj.hasOwnProperty('follow_y')) {
        this.follow_y = initObj.follow_y
      }
      else {
        this.follow_y = 0.0;
      }
      if (initObj.hasOwnProperty('rotation')) {
        this.rotation = initObj.rotation
      }
      else {
        this.rotation = 0.0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type follow
    // Serialize message field [follow_x]
    bufferOffset = _serializer.float32(obj.follow_x, buffer, bufferOffset);
    // Serialize message field [follow_y]
    bufferOffset = _serializer.float32(obj.follow_y, buffer, bufferOffset);
    // Serialize message field [rotation]
    bufferOffset = _serializer.float32(obj.rotation, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type follow
    let len;
    let data = new follow(null);
    // Deserialize message field [follow_x]
    data.follow_x = _deserializer.float32(buffer, bufferOffset);
    // Deserialize message field [follow_y]
    data.follow_y = _deserializer.float32(buffer, bufferOffset);
    // Deserialize message field [rotation]
    data.rotation = _deserializer.float32(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    return 12;
  }

  static datatype() {
    // Returns string type for a message object
    return 'r2000_commander/follow';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'f19ced7bb25afdc86477774c9b980548';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    float32 follow_x
    float32 follow_y
    float32 rotation
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new follow(null);
    if (msg.follow_x !== undefined) {
      resolved.follow_x = msg.follow_x;
    }
    else {
      resolved.follow_x = 0.0
    }

    if (msg.follow_y !== undefined) {
      resolved.follow_y = msg.follow_y;
    }
    else {
      resolved.follow_y = 0.0
    }

    if (msg.rotation !== undefined) {
      resolved.rotation = msg.rotation;
    }
    else {
      resolved.rotation = 0.0
    }

    return resolved;
    }
};

module.exports = follow;
