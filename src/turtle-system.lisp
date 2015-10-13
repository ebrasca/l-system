;;;; turtle-system.lisp

(in-package #:l-system)

;;;(matrix* translate rotate scale)

(export 'f)
(export 'q)
(export	'[)
(export	'])

(defun turtle-system (fn list radians)
  (iter (with pos = (sb-cga:vec 0.0 0.0 0.0))
	(with vec-x = (sb-cga:vec 1.0 0.0 0.0))
	(with vec-y = (sb-cga:vec 0.0 1.0 0.0))
	(with vec-z = (sb-cga:vec 0.0 0.0 1.0))
	(with stack = '())
	(with angle = radians)
	(for item in list)
	(case (car item)
	  ;;Move forward one unit,adding data to mesh.
	  ((f)
	   (let ((new-pos
		  (vec+ pos vec-y)))
	     (appending (funcall fn pos new-pos vec-x vec-y vec-z))
	     (setf pos new-pos)))
	  ;;Move forward one unit,without adding data to mesh.
	  ((j)
	   (setf pos
		 (vec+ pos
		       vec-y)))
	  ;;Rotate left on axis z
	  ((+)
	   (setf vec-x
		 (vec-rotate-around vec-x vec-z angle))
	   (setf vec-y
		 (vec-rotate-around vec-y vec-z angle)))
	  ;;Rotate right on axis z
	  ((-)
	   (setf vec-x
		 (vec-rotate-around vec-x vec-z (- angle)))
	   (setf vec-y
		 (vec-rotate-around vec-y vec-z (- angle))))
	  ;;Rotate left on axis y
	  ((&)
	   (setf vec-x
		 (vec-rotate-around vec-x vec-y angle))
	   (setf vec-z
		 (vec-rotate-around vec-z vec-y angle)))
	  ;;Rotate right on axis y
	  ((^)
	   (setf vec-x
		 (vec-rotate-around vec-x vec-y (- angle)))
	   (setf vec-z
		 (vec-rotate-around vec-z vec-y (- angle))))
	  ;;Rotate left on axis x
	  ((q)
	   (setf vec-z
		 (vec-rotate-around vec-z vec-x angle))
	   (setf vec-y
		 (vec-rotate-around vec-y vec-x angle)))
	  ;;Rotate right on axis x
	  ((/)
	   (setf vec-z
		 (vec-rotate-around vec-z vec-x (- angle)))
	   (setf vec-y
		 (vec-rotate-around vec-y vec-x (- angle))))
	  ;;Push the current turtle state onto a stack
	  (([)
	   (push (list pos vec-x vec-y vec-z)
		 stack))
	  ;;Pop the turtle stack, restoring an earlier state
	  ((])
	   (let* ((asd (pop stack))
		  (pos0 (pop asd))
		  (vec-x0 (pop asd))
		  (vec-y0 (pop asd))
		  (vec-z0 (pop asd)))
	     (setf pos pos0
		   vec-x vec-x0
		   vec-y vec-y0
		   vec-z vec-z0))))))

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
