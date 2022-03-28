
(cl:in-package :asdf)

(defsystem "r2000_commander-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "follow" :depends-on ("_package_follow"))
    (:file "_package_follow" :depends-on ("_package"))
  ))