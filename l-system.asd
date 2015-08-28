;;;; l-system.asd

(asdf:defsystem #:l-system
  :description "L-system or Lindenmayer system on lists"
  :author "Bruno Cichon <ebrasca.ebrasca@gmail.com>"
  :license "GPLv3+"
  :pathname "src"
  :serial t
  :depends-on (:sb-cga
	       :iterate)
  :components ((:file "package")
	       (:file "turtle-system")
               (:file "l-system")
	       (:file "test")))

