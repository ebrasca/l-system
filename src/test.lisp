;;;; test.list

(in-package :l-system)

(defun test ()
  (and
   (test-l-system)
   (test-iter-l-system)))
   ;;(turle-system)))

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

#|
(defun turle-system ()
  (tree-equal
   (turtle-system (l-system (a (0 1 0))
			    (b (0 -1 0))
			    (i (-1 0 0))
			    (d (1 0 0)))
		  (iter-l-system (l-system (a a i a d a)
					   (b b d b i b)
					   (i i b i a i)
					   (d d a d b d))
				 '(d)
				 3))
   '(1 0 0 1 1 0 2 1 0 2 0 0 3 0 0 3 1 0 2 1 0 2 2 0 3 2 0 3 3 0 4 3 0 4 4 0 5 4 0
     5 3 0 6 3 0 6 2 0 7 2 0 7 1 0 6 1 0 6 0 0 7 0 0 7 1 0 8 1 0 8 0 0 9 0 0 9 1 0
     8 1 0 8 2 0 9 2 0 9 3 0 8 3 0 8 2 0 7 2 0 7 3 0 6 3 0 6 4 0 5 4 0 5 5 0 6 5 0
     6 6 0 7 6 0 7 7 0 8 7 0 8 6 0 9 6 0 9 7 0 8 7 0 8 8 0 9 8 0 9 9 0 10 9 0 10 10
     0 11 10 0 11 9 0 12 9 0 12 10 0 11 10 0 11 11 0 12 11 0 12 12 0 13 12 0 13 13
     0 14 13 0 14 12 0 15 12 0 15 11 0 16 11 0 16 10 0 15 10 0 15 9 0 16 9 0 16 10
     0 17 10 0 17 9 0 18 9 0 18 8 0 19 8 0 19 7 0 18 7 0 18 6 0 19 6 0 19 7 0 20 7
     0 20 6 0 21 6 0 21 5 0 22 5 0 22 4 0 21 4 0 21 3 0 20 3 0 20 2 0 19 2 0 19 3 0
     18 3 0 18 2 0 19 2 0 19 1 0 18 1 0 18 0 0 19 0 0 19 1 0 20 1 0 20 0 0 21 0 0
     21 1 0 20 1 0 20 2 0 21 2 0 21 3 0 22 3 0 22 4 0 23 4 0 23 3 0 24 3 0 24 2 0
     25 2 0 25 1 0 24 1 0 24 0 0 25 0 0 25 1 0 26 1 0 26 0 0 27 0 0)))
|#
