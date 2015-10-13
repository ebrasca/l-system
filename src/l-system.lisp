;;;; l-system.lisp
#|
(ql:quickload :l-system)
|#

(in-package #:l-system)

;;; "l-system" goes here. Hacks and glory await!

(defparameter *l-system-clauses* (make-hash-table :test 'eq))

(defun iterconcat (fn list)
  "Applies fn on each element of list, and concatenate a copy of the resulting lists."
  (iter (for item in list)
	(appending (funcall fn item))))

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
			 (let ((result (funcall func (rest clause))))
			   (when result
			     result))
			 (list clause))))))

(defun def-l-system-clause (symbol lambda)
  (setf (gethash symbol *l-system-clauses*)
	lambda))
