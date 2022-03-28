; Auto-generated. Do not edit!


(cl:in-package r2000_commander-msg)


;//! \htmlinclude follow.msg.html

(cl:defclass <follow> (roslisp-msg-protocol:ros-message)
  ((follow_x
    :reader follow_x
    :initarg :follow_x
    :type cl:float
    :initform 0.0)
   (follow_y
    :reader follow_y
    :initarg :follow_y
    :type cl:float
    :initform 0.0)
   (rotation
    :reader rotation
    :initarg :rotation
    :type cl:float
    :initform 0.0))
)

(cl:defclass follow (<follow>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <follow>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'follow)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name r2000_commander-msg:<follow> is deprecated: use r2000_commander-msg:follow instead.")))

(cl:ensure-generic-function 'follow_x-val :lambda-list '(m))
(cl:defmethod follow_x-val ((m <follow>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader r2000_commander-msg:follow_x-val is deprecated.  Use r2000_commander-msg:follow_x instead.")
  (follow_x m))

(cl:ensure-generic-function 'follow_y-val :lambda-list '(m))
(cl:defmethod follow_y-val ((m <follow>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader r2000_commander-msg:follow_y-val is deprecated.  Use r2000_commander-msg:follow_y instead.")
  (follow_y m))

(cl:ensure-generic-function 'rotation-val :lambda-list '(m))
(cl:defmethod rotation-val ((m <follow>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader r2000_commander-msg:rotation-val is deprecated.  Use r2000_commander-msg:rotation instead.")
  (rotation m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <follow>) ostream)
  "Serializes a message object of type '<follow>"
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'follow_x))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'follow_y))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'rotation))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <follow>) istream)
  "Deserializes a message object of type '<follow>"
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'follow_x) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'follow_y) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'rotation) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<follow>)))
  "Returns string type for a message object of type '<follow>"
  "r2000_commander/follow")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'follow)))
  "Returns string type for a message object of type 'follow"
  "r2000_commander/follow")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<follow>)))
  "Returns md5sum for a message object of type '<follow>"
  "f19ced7bb25afdc86477774c9b980548")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'follow)))
  "Returns md5sum for a message object of type 'follow"
  "f19ced7bb25afdc86477774c9b980548")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<follow>)))
  "Returns full string definition for message of type '<follow>"
  (cl:format cl:nil "float32 follow_x~%float32 follow_y~%float32 rotation~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'follow)))
  "Returns full string definition for message of type 'follow"
  (cl:format cl:nil "float32 follow_x~%float32 follow_y~%float32 rotation~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <follow>))
  (cl:+ 0
     4
     4
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <follow>))
  "Converts a ROS message object to a list"
  (cl:list 'follow
    (cl:cons ':follow_x (follow_x msg))
    (cl:cons ':follow_y (follow_y msg))
    (cl:cons ':rotation (rotation msg))
))
