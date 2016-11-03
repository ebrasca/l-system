;;;; l-system.lisp

(in-package #:l-system)

;;; "l-system" goes here. Hacks and glory await!

(defparameter *l-system-clauses* (make-hash-table :test 'equal))

(defun l-system (fn axiom depth)
  (iter (repeat depth)
	(with result = axiom)
	(setf result
	      (funcall fn result))
	(finally (return result))))

(defun parametric-grammar (elements)
  (iter (for (symbol . parameters) in elements)
	(for func = (gethash symbol *l-system-clauses*))
	(appending (if (functionp func)
		       (apply func parameters)
		       (list `(,symbol ,@parameters))))))

(defun context-sensitive-grammar (elements)
  (iter (for elt on elements)
	(with symbol0 = nil)
	(for (symbol1 . parameters1) = (first elt))
	(for symbol2 = (first (second elt)))
	(for func = (or (gethash (list symbol0 symbol1 symbol2) *l-system-clauses*)
			(gethash symbol1 *l-system-clauses*)))
	(appending (if (functionp func)
		       (apply func parameters1)
		       (list `(,symbol1 ,@parameters1))))
	(setf symbol0 (first (first elt)))))

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
