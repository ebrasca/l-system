;;;; turtle-system.lisp

(in-package #:l-system)

;;;(matrix* translate rotate scale)

(export 'f)
(export 'q)
(export	'[)
(export	'])

(defun turtle-system (fn list)
  (iter (with pos = (sb-cga:vec 0.0 0.0 0.0))
	(with vec-x = (sb-cga:vec 1.0 0.0 0.0))
	(with vec-y = (sb-cga:vec 0.0 1.0 0.0))
	(with vec-z = (sb-cga:vec 0.0 0.0 1.0))
	(with stack = '())
	(for item in list)
	(case (car item)
	  ;;Move forward one unit,adding data to mesh.
	  ((f)
	   (let ((new-pos
		  (vec+ pos
			(vec* vec-y
			      (cadr item)))))
	     (appending (funcall fn pos new-pos vec-x vec-y vec-z))
	     (setf pos new-pos)))
	  ;;Move forward one unit,without adding data to mesh.
	  ((j)
	   (setf pos
		 (vec+ pos
		       (vec* vec-y
			     (cadr item)))))
	  ;;Rotate left on axis z
	  ((+)
	   (setf vec-x (vec-rotate-around vec-x vec-z (cadr item))
		 vec-y (vec-rotate-around vec-y vec-z (cadr item))))
	  ;;Rotate right on axis z
	  ((-)
	   (setf vec-x (vec-rotate-around vec-x vec-z (- (cadr item)))
		 vec-y (vec-rotate-around vec-y vec-z (- (cadr item)))))
	  ;;Rotate left on axis y
	  ((&)
	   (setf vec-x (vec-rotate-around vec-x vec-y (cadr item))
		 vec-z (vec-rotate-around vec-z vec-y (cadr item))))
	  ;;Rotate right on axis y
	  ((^)
	   (setf vec-x (vec-rotate-around vec-x vec-y (- (cadr item)))
		 vec-z (vec-rotate-around vec-z vec-y (- (cadr item)))))
	  ;;Rotate left on axis x
	  ((q)
	   (setf vec-z (vec-rotate-around vec-z vec-x (cadr item))
		 vec-y (vec-rotate-around vec-y vec-x (cadr item))))
	  ;;Rotate right on axis x
	  ((/)
	   (setf vec-z (vec-rotate-around vec-z vec-x (- (cadr item)))
		 vec-y (vec-rotate-around vec-y vec-x (- (cadr item)))))
	  ;;Push the current turtle state onto a stack
	  (([)
	   (push (list pos vec-x vec-y vec-z)
		 stack))
	  ;;Pop the turtle stack, restoring an earlier state
	  ((])
	   (let* ((asd (pop stack)))
	     (setf pos (pop asd)
		   vec-x (pop asd)
		   vec-y (pop asd)
		   vec-z (pop asd)))))))

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
