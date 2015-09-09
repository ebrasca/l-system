;;;; turtle-system.lisp

(in-package #:l-system)

;;;(matrix* translate rotate scale)

(export 'f)
(export	'[)
(export	'])

(defun turtle-system (fn list radians)
  (iter (with pos = (sb-cga:vec 0.0 0.0 0.0))
	(with vec = (sb-cga:vec 0.0 1.0 0.0))
	(with pile = '())
	(with angle = radians)
	(for item in list)
	(case item
	  ;;Move forward one unit,adding data to mesh.
	  ((f)
	   (let ((new-pos
		  (vec+ pos vec)))
	     (appending (funcall fn pos new-pos vec))
	     (setf pos new-pos)))
	  ;;Move forward one unit,without adding data to mesh.
	  ((j)
	   (setf pos
		 (vec+ pos
		       vec)))
	  ;;Rotate left on axis z
	  ((+)
	   (setf vec
		 (vec-rotate-around vec (vec 0.0 0.0 1.0) angle)))
	  ;;Rotate right on axis z
	  ((-)
	   (setf vec
		 (vec-rotate-around vec (vec 0.0 0.0 -1.0) angle)))
	  ;;Rotate left on axis y
	  ((&)
	   (setf vec
		 (vec-rotate-around vec (vec 0.0 1.0 0.0) angle)))
	  ;;Rotate right on axis y
	  ((^)
	   (setf vec
		 (vec-rotate-around vec (vec 0.0 -1.0 0.0) angle)))
	  ;;Rotate left on axis x
	  ((\ )
	   (setf vec
		 (vec-rotate-around vec (vec 1.0 0.0 0.0) angle)))
	  ;;Rotate right on axis x
	  ((/)
	   (setf vec
		 (vec-rotate-around vec (vec -1.0 0.0 0.0) angle)))
	  ;;Push the current turtle state onto a stack
	  (([)
	   (push (list pos vec)
		 pile))
	  ;;Pop the turtle stack, restoring an earlier state
	  ((])
	   (let* ((asd (pop pile))
		  (pos0 (first asd))
		  (vec0 (second asd)))
	     (setf pos pos0)
	     (setf vec vec0))))))

;;; Turgle utils

(defun list-of-vectors->list (list-of-vectors)
  (iterconcat #'(lambda (vec)
		  (concatenate 'list
			       vec))
	      list-of-vectors))

(defun vec-rotate-around (vec vec-rotation angle)
  "Rotate vec around vec-rotation axis by angle"
  (transform-point (vec 0.0 0.0 0.0)
		   (matrix*
		    (rotate-around vec-rotation angle)
		    (translate vec))))
