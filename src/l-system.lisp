;;;; l-system.lisp
#|
(ql:quickload :l-system)
|#

(in-package #:l-system)

;;; "l-system" goes here. Hacks and glory await!

(defun iterconcat (fn list)
  "Applies fn on each element of list, and concatenate a copy of the resulting lists."
  (iter (for item in list)
	(appending (funcall fn item))))

(defun make-case-clause (keys value)
  "Make one CASE clause mapping a list of KEYS to one VALUE"
  `((,@keys) ',value))

(defun make-case-clauses-from-rules (rules)
  "Makes a list of CASE clauses from the RULES."
  (mapcar (lambda (rule) (make-case-clause (list (first rule)) (rest rule)))
          rules))

(defun generate-l-system (rules)
  "Make lambda Lindenmayer system"
  `(lambda (atom) (case atom ,@(make-case-clauses-from-rules rules))))

(defmacro l-system (&rest rules)
  (generate-l-system rules))

(defun iter-l-system (rules axiom depth)
  (iter (repeat depth)
	(with result = axiom)
	(setf result
	      (iterconcat rules
			  result))
	(finally (return result))))
