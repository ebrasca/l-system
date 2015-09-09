;;;; test.list

(in-package :l-system)

(defun test ()
  (and
   (test-l-system)
   (test-iter-l-system)))

(defun test-l-system ()
  (tree-equal
   (iterconcat (l-system (a a i a d a)
			 (b b d b i b)
			 (i i b i a i)
			 (d d a d b d))
	       '(d))
   '(D A D B D)))

(defun test-iter-l-system ()
  (tree-equal
   (iter-l-system (l-system (a a i a d a)
			    (b b d b i b)
			    (i i b i a i)
			    (d d a d b d))
		  '(d)
		  3)
   '(D A D B D A I A D A D A D B D B D B I B D A D B D A I A D A I B I A I A I A D
     A D A D B D A I A D A D A D B D A I A D A D A D B D B D B I B D A D B D B D B
     I B D A D B D B D B I B I B I A I B D B I B D A D B D A I A D A D A D B D B D
     B I B D A D B D)))
