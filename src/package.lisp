;;;; package.lisp

(defpackage #:l-system
  (:use #:cl #:iter #:sb-cga)
  (:export #:*l-system-clauses*
	   #:l-system
	   #:map-l-system
	   #:def-l-system-clause
	   #:deflsys

	   #:turtle-system
	   #:list-of-vectors->list

	   #:mtranslate
	   #:mrotate
	   #:get-axis
	   #:get-vec

	   #:cube))
