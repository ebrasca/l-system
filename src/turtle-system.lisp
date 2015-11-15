;;;; turtle-system.lisp

(in-package #:l-system)

;;;(matrix* translate rotate scale)

(export '(f j + - & ^ q / [ ]))

(defvar coor-sys (identity-matrix))
(defvar stack '())

(defun turtle-system (fn list)
  (iter (for item in list)
	(case (car item)
	  ;;Move forward one unit,adding data to mesh.
	  ((f)
	   (let ((pos (get-vec coor-sys))
		 (vec-x (get-axis coor-sys 0))
		 (vec-y (get-axis coor-sys 1))
		 (vec-z (get-axis coor-sys 2)))
	     (setf coor-sys (mtranslate coor-sys
					(vec* (vec 0.0 1.0 0.0)
					      (cadr item))))
	     (appending (funcall fn pos (get-vec coor-sys)
				 vec-x vec-y vec-z))))
	  ;;Move forward one unit,without adding data to mesh.
	  ((j)
	   (setf coor-sys (mtranslate coor-sys
				      (vec* (vec 0.0 1.0 0.0)
					    (cadr item)))))
	  ;;Rotate left on axis z
	  ((+)
	   (setf coor-sys (mrotate
			   (get-axis coor-sys 2)
			   coor-sys
			   (cadr item))))
	  ;;Rotate right on axis z
	  ((-)
	   (setf coor-sys (mrotate
			   (get-axis coor-sys 2)
			   coor-sys
			   (- (cadr item)))))
	  ;;Rotate left on axis y
	  ((&)
	   (setf coor-sys (mrotate
			   (get-axis coor-sys 1)
			   coor-sys
			   (cadr item))))
	  ;;Rotate right on axis y
	  ((^)
	   (setf coor-sys (mrotate
			   (get-axis coor-sys 1)
			   coor-sys
			   (- (cadr item)))))
	  ;;Rotate left on axis x
	  ((q)
	   (setf coor-sys (mrotate
			   (get-axis coor-sys 0)
			   coor-sys
			   (cadr item))))
	  ;;Rotate right on axis x
	  ((/)
	   (setf coor-sys (mrotate
			   (get-axis coor-sys 0)
			   coor-sys
			   (- (cadr item)))))
	  ;;Push the current turtle state onto a stack
	  (([)
	   (push (copy-seq coor-sys)
		 stack))
	  ;;Pop the turtle stack, restoring an earlier state
	  ((])
	   (setf coor-sys (pop stack))))
	(finally (init))))

;;; Turgle utils

(defun init ()
  (setf coor-sys (identity-matrix)
	stack '()))

(defun list-of-vectors->list (list-of-vectors)
  (iterconcat #'(lambda (vec)
		  (concatenate 'list
			       vec))
	      list-of-vectors))

(defun mtranslate (matrix vec)
  (matrix* matrix
	   (translate vec)))

(defun mrotate (axis matrix radians)
  (matrix* matrix
	   (rotate-around axis radians)))

(defun get-axis (matrix column)
  (vec (mref matrix 0 column)
       (mref matrix 1 column)
       (mref matrix 2 column)))

(defun get-vec (matrix)
  (transform-point (vec 0.0 0.0 0.0)
		   matrix))
