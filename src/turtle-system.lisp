;;;; turtle-system.lisp

(in-package #:l-system)

;;;(matrix* translate rotate scale)

(export 'f)
(export	'[)
(export	'])

(defun turtle-system (list radians)
  (iter (with pos = (sb-cga:vec 0.0 0.0 0.0))
	(with vec = (sb-cga:vec 0.0 1.0 0.0))
	(with pile = '())
	(with angle = radians)
	(for item in list)
	(case item
	  ((f)
	   (collect
	       (setf pos
		     (vec+ pos
			   vec))))
	  ((j)
	   (setf pos
		 (vec+ pos
		       vec)))
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
				   (rotate-around (vec 0.0 0.0 -1.0) angle)
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
				   (rotate-around (vec 0.0 -1.0 0.0) angle)
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
				   (rotate-around (vec -1.0 0.0 0.0) angle)
				   (translate vec)))))
	  (([)
	   (push (list pos vec)
		 pile))
	  ((])
	   (let* ((asd (pop pile))
		  (pos0 (first asd))
		  (vec0 (second asd)))
	     (setf pos pos0)
	     (setf vec vec0))))))

(defun list-of-vectors->list (list-of-vectors)
  (iterconcat #'(lambda (vec)
		  (concatenate 'list
			       vec))
	      list-of-vectors))
