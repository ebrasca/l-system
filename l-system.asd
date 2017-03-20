;;;; l-system.asd

(asdf:defsystem #:l-system
  :description "L-system or Lindenmayer system on lists"
  :author "Bruno Cichon <ebrasca.ebrasca@openmailbox.org>"
  :license "GPLv3+"
  :pathname "src"
  :serial t
  :depends-on (:iterate)
  :components ((:file "package")
               (:file "l-system")))
