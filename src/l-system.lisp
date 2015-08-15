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

(defun iter-l-system (fn seed n)
  (iter (repeat n)
	(with item = seed)
	(setf item
	      (iterconcat fn
			  item))
	(finally (return item))))

#|
(iterconcat (l-system (a a i a d a)
		      (b b d b i b)
		      (i i b i a i)
		      (d d a d b d))
	    '(d)) ;; --> (D A D B D)

(iter-l-system (l-system (a a i a d a)
			 (b b d b i b)
			 (i i b i a i)
			 (d d a d b d))
	       '(d)
	       3)
;; --> (D A D B D A I A D A D A D B D B D B I B D A D B D A I A D A I B I A I A I A D
        A D A D B D A I A D A D A D B D A I A D A D A D B D B D B I B D A D B D B D B
        I B D A D B D B D B I B I B I A I B D B I B D A D B D A I A D A D A D B D B D
        B I B D A D B D)
|#
