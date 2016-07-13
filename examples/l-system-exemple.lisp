(in-package #:l-system-examples)

(-> f (x)
  '((f 1)
    (j 1)
    (f 1)))

(-> j (x)
  `((j ,(* 3 x))))

(l-system '((f 1.0)) 2)
