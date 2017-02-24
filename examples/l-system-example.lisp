(in-package #:l-system-examples)

;;Lindenmayer's original L-system
;;Example 1: Algae
(-> a ()
  '((a) (b)))

(-> b ()
  '((a)))

(l-system #'parametric-grammar '((a)) 3)

;;;Parametric grammars
(-> f ()
  '((f 1)
    (j 1)
    (f 1)))

(-> j (x)
  (if (oddp x)
      `((j ,(1+ (* 3 x))))
      `((j ,(/ x 2)))))

(l-system #'parametric-grammar '((f 1.0)) 3)

;;;Context sensitive grammars
(-> (f j f) (x)
  `((j ,(* 2 x))))

(l-system #'context-sensitive-grammar '((f 1.0)) 3)
