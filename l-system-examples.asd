;;;; l-system-examples.asd

(asdf:defsystem #:l-system-examples
    :description "L-system or Lindenmayer system on lists"
    :author "Bruno Cichon <ebrasca.ebrasca@gmail.com>"
    :license "GPLv3+"
    :pathname "examples"
    :serial t
    :depends-on (:glkit
		 :sdl2kit
		 :l-system)
    :components ((:file "package")
		 (:file "l-system-exemple")))
