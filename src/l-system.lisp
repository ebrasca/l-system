;;;; l-system.lisp

(in-package #:l-system)

;;; "l-system" goes here. Hacks and glory await!

(defparameter *l-system-clauses* (make-hash-table :test 'equal))

(defun l-system (fn axiom depth)
  "Expand axiom into some larger list of symbols.
It can expand to parametric grammar or to context sensitive grammar."
  (iter (repeat depth)
	(with result = axiom)
	(setf result
	      (funcall fn result))
	(finally (return result))))

(defun parametric-grammar (elements)
  "Handle parametric grammar."
  (iter (for (symbol . parameters) in elements)
	(for func = (gethash symbol *l-system-clauses*))
	(appending (if (functionp func)
		       (apply func parameters)
		       (list `(,symbol ,@parameters))))))

(defun context-sensitive-grammar (elements)
  "Handle context sensitive grammar and parametric grammar."
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

(defmacro -> (symbol vars &body body)
  "Define and set rules to grammar."
  `(setf (gethash ',symbol *l-system-clauses*)
         #'(lambda ,(append vars '(&rest rest))
             (declare (ignorable rest))
             ,@body)))

(defun unset-rule (symbol)
  "Unset rules from grammar."
  (setf (gethash symbol *l-system-clauses*)
        nil))
