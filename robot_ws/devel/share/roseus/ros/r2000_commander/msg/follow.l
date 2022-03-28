;; Auto-generated. Do not edit!


(when (boundp 'r2000_commander::follow)
  (if (not (find-package "R2000_COMMANDER"))
    (make-package "R2000_COMMANDER"))
  (shadow 'follow (find-package "R2000_COMMANDER")))
(unless (find-package "R2000_COMMANDER::FOLLOW")
  (make-package "R2000_COMMANDER::FOLLOW"))

(in-package "ROS")
;;//! \htmlinclude follow.msg.html


(defclass r2000_commander::follow
  :super ros::object
  :slots (_follow_x _follow_y _rotation ))

(defmethod r2000_commander::follow
  (:init
   (&key
    ((:follow_x __follow_x) 0.0)
    ((:follow_y __follow_y) 0.0)
    ((:rotation __rotation) 0.0)
    )
   (send-super :init)
   (setq _follow_x (float __follow_x))
   (setq _follow_y (float __follow_y))
   (setq _rotation (float __rotation))
   self)
  (:follow_x
   (&optional __follow_x)
   (if __follow_x (setq _follow_x __follow_x)) _follow_x)
  (:follow_y
   (&optional __follow_y)
   (if __follow_y (setq _follow_y __follow_y)) _follow_y)
  (:rotation
   (&optional __rotation)
   (if __rotation (setq _rotation __rotation)) _rotation)
  (:serialization-length
   ()
   (+
    ;; float32 _follow_x
    4
    ;; float32 _follow_y
    4
    ;; float32 _rotation
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float32 _follow_x
       (sys::poke _follow_x (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _follow_y
       (sys::poke _follow_y (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _rotation
       (sys::poke _rotation (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float32 _follow_x
     (setq _follow_x (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _follow_y
     (setq _follow_y (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _rotation
     (setq _rotation (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get r2000_commander::follow :md5sum-) "f19ced7bb25afdc86477774c9b980548")
(setf (get r2000_commander::follow :datatype-) "r2000_commander/follow")
(setf (get r2000_commander::follow :definition-)
      "float32 follow_x
float32 follow_y
float32 rotation
")



(provide :r2000_commander/follow "f19ced7bb25afdc86477774c9b980548")


