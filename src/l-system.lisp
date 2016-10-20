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
  (iter (for clause in clauses)
	(appending (let ((func (gethash (car clause) *l-system-clauses*)))
		     (if (functionp func)
			 (let ((result (apply func
					      (rest clause))))
			   (when result
			     result))
			 (list clause))))))

(defun setf-l-system-rule (symbol lambda)
  (setf (gethash symbol *l-system-clauses*)
 	lambda))

(defun make-l-system-expr (item)
  `(list ',(first item) ,(second item)))

(defun make-l-system-list (rest)
  (iter (for item in rest)
	(collecting (make-l-system-expr item))))

(defmacro make-l-system-rule (vars &body body)
  `#'(lambda ,vars (list ,@(make-l-system-list body))))

(defmacro -> (symbol vars &body body)
  `(setf-l-system-rule ',symbol
		       (make-l-system-rule ,vars ,@body)))
