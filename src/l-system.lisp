;;;; l-system.lisp

(in-package #:l-system)

;;; "l-system" goes here. Hacks and glory await!

(defparameter *l-system-clauses* (make-hash-table :test 'eq))

(defun l-system (axiom depth)
  (iter (repeat depth)
	(with result = axiom)
	(setf result
	      (map-l-system result))
	(finally (return result))))

(defun map-l-system (clauses)
  (iter (for (symbol . parameters) in clauses)
	(for func = (gethash symbol *l-system-clauses*))
	(appending (if (functionp func)
		       (apply func parameters)
		       (list `(,symbol ,@parameters))))))

(defmacro setf-l-system-rule (symbol lambda)
  `(setf (gethash ,symbol *l-system-clauses*)
	 ,lambda))

(defun make-l-system-expr (item)
  `(list ',(first item) ,@(rest item)))

(defun make-l-system-list (rest)
  (iter (for item in rest)
	(collecting (make-l-system-expr item))))

(defmacro make-l-system-rule (vars &body body)
  `#'(lambda ,(append vars '(&rest rest))
       (declare (ignorable rest))
       (list ,@(make-l-system-list body))))

(defmacro -> (symbol vars &body body)
  `(setf-l-system-rule ',symbol
		       (make-l-system-rule ,vars ,@body)))
