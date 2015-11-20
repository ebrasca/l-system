(in-package #:l-system-examples)

(deflsys f (n)
    (let* ((r0 0.5235988)
	   (n0 (* 1.01 n)))
      `((f ,(* 1.11 n0))
	
	([)
	(+ ,r0)
	(f ,(* 0.89 n0))
	(])
	
	([)
	(- ,r0)
	(f ,(* 0.89 n0))
	(])

	([)
	(/ ,r0)
	(f ,(* 0.89 n0))
	(])
	
	([)
	(q ,r0)
	(f ,(* 0.89 n0))
	(])

	(f ,(* 1.11 n0))
	
	([)
	(+ ,r0)
	(f ,(* 0.89 n0))
	(])
	
	([)
	(- ,r0)
	(f ,(* 0.89 n0))
	(])

	([)
	(/ ,r0)
	(f ,(* 0.89 n0))
	(])
	
	([)
	(q ,r0)
	(f ,(* 0.89 n0))
	(])

	(f ,(* 1.11 n0)))))

(deflsys + (n)
  `((+ ,(+ 0.1 n))))

(deflsys - (n)
  `((- ,(+ 0.1 n))))

;; Rest
(defclass test-window (gl-window)
  ((start-time :initform (get-internal-real-time))
   (frames :initform 0)
   (dt :initform 0)
   (rotate :initform 0.0)
   
   (view-matrix :initform (kit.glm:perspective-matrix 50.0 1.1 1.0 800.0))
   (vao :initform nil)
   (programs :initform nil)))

(defmethod initialize-instance :after ((w test-window)
				       &key shaders &allow-other-keys)
  (setf (idle-render w) t)
  (gl:viewport 0 0 800 600)

  (with-slots (vao programs) w
    (let* ((data
	    ;;convert list of vecs to array
	    (list-of-vectors->list
	     ;;make list of vecs
	     (turtle-system
	      ;;Specific geometry for symbol f
	      #'(lambda (o n list)
		  (cube o n))
	      ;;make structure of turtle commands
	      (l-system '((f 1.0)) 3))))
	   (length (length data))
	   (array (make-array length
		    :element-type 'single-float
		    :initial-contents data)))
      (setf programs (compile-shader-dictionary shaders))
      (setf vao
	    (make-instance 'vao
			   :type 'vertex-3d
			   :primitive :triangles
			   :vertex-count (/ length 3)))
      (vao-buffer-vector vao 0 (* 4 length) array)
      (vao-buffer-vector vao 1 (* 4 length) array))))


;;; Rest

(defmethod render ((window test-window))
  (with-slots (view-matrix vao programs rotate) window
    (gl:clear-color 0.0 0.0 1.0 1.0)
    (gl:clear :color-buffer)

    (use-program programs :vertex-color)
    (uniform-matrix programs :view-m 4 (vector
					(sb-cga:matrix*
					 view-matrix
					 (kit.glm:look-at
					  (sb-cga:vec 0.0 0.0 200.0)
					  (sb-cga:vec 0.0 10.0 0.0)
					  (sb-cga:vec 0.0 -1.0 0.0))
					 (sb-cga:rotate* 0.0
							 (incf rotate 0.00625)
							 0.0))))
    (vao-draw vao)))

(defmethod render :after ((window test-window))
  (with-slots (start-time frames rotate) window
    (incf frames)
    (let* ((current-time (get-internal-real-time))
           (seconds (/ (- current-time start-time) internal-time-units-per-second)))
      
      (when (> seconds 5)
	(format t "FPS: ~A~%" (float (/ frames seconds)))
        (setf frames 0)
        (setf start-time (get-internal-real-time))))))

(defun start-example ()
  (kit.sdl2:start)
  (sdl2:in-main-thread ()
    (sdl2:gl-set-attr :context-major-version 3)
    (sdl2:gl-set-attr :context-minor-version 3))
  (make-instance 'test-window :shaders 'vao-color.programs.330))

(defvao vertex-3d ()
  (:separate ()
    (vertex :float 3)
    (color :float 3)))

(defdict vao-color.programs.330 ()
  (program :vertex-color (:view-m)
           (:vertex-shader "
#version 330

uniform mat4 view_m;

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 color;

smooth out vec3 f_color;

void main() {
    gl_Position = view_m * vec4(vertex, 1.0);
    f_color = color;
}
")
           (:fragment-shader "
#version 330

smooth in vec3 f_color;
out vec4 f_out;

void main() {
    f_out = vec4(f_color,
                 1.0);
}
")))
