;;;; turtle-system.lisp

(in-package #:l-system)

;;;(matrix* translate rotate scale)

(export 'f)

(defun turtle-system (list radians)
  (iter (with seed = sb-cga:+identity-matrix+)
	(with vec = (sb-cga:vec 1.0 0.0 0.0))
	(with pile)
	(with angle = radians)
	(for item in list)
	(case item
	  ((f)
	   (collect
	       (setf seed
		     (matrix* seed
			      (translate vec)))))
	  ((j)
	   (setf seed
		 (matrix* seed
			  (translate vec))))
	  ((+)
	   (setf vec
		 (transform-point (vec 0.0 0.0 0.0)
				  (matrix*
				   (rotate-around (vec 0.0 0.0 1.0) angle)
				   (translate vec)))))
	  ((-)
	   (setf vec
		 (transform-point (vec 0.0 0.0 0.0)
				  (matrix*
				   (rotate-around (vec 0.0 0.0 1.0) (- angle))
				   (translate vec)))))
	  ((&)
	   (setf vec
		 (transform-point (vec 0.0 0.0 0.0)
				  (matrix*
				   (rotate-around (vec 0.0 1.0 0.0) angle)
				   (translate vec)))))
	  ((^)
	   (setf vec
		 (transform-point (vec 0.0 0.0 0.0)
				  (matrix*
				   (rotate-around (vec 0.0 1.0 0.0) (- angle))
				   (translate vec)))))
	  ((\ )
	   (setf vec
		 (transform-point (vec 0.0 0.0 0.0)
				  (matrix*
				   (rotate-around (vec 1.0 0.0 0.0) angle)
				   (translate vec)))))
	  ((/)
	   (setf vec
		 (transform-point (vec 0.0 0.0 0.0)
				  (matrix*
				   (rotate-around (vec 1.0 0.0 0.0) (- angle))
				   (translate vec)))))
	  (([)
	   (push (cons seed vec) pile))
	  ((])
	   (let ((last-state (pop pile)))
	     (setf seed (first last-state)
		   vec (rest last-state)))))))

(defun list-of-vectors->list (list-of-vectors)
  (iterconcat #'(lambda (matrix)
		  (concatenate 'list
			       (sb-cga:transform-point (vec 0.0 0.0 0.0)
						       matrix)))
	      list-of-vectors))
