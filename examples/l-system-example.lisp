(in-package #:l-system-examples)

;;;Parametric grammars
(-> f ()
  (f 1)
  (j 1)
  (f 1))

(-> j (x)
  (j (* 3 x)))

(l-system #'parametric-grammar '((f 1.0)) 2)

;;;Context sensitive grammars
(-> (f j f) (x)
  (j (* 2 x)))

(l-system #'context-sensitive-grammar '((f 1.0)) 2)
