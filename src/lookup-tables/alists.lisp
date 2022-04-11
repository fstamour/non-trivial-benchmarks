;;;; These benchmarks are not exported, so they're effectively
;;;; disabled. I disabled them because they deadlock.

(defpackage #:non-trivial-benchmarks/lookup-tables/alists  (:use :cl))

(in-package #:non-trivial-benchmarks/lookup-tables/alists)

(defun run-insertion-alist (&optional (n 1000000))
  "Sequencially inserting values into an alist"
  (declare (type fixnum n))
  (let* ((ht '())
         (random-list (loop :repeat n
                            :for i = (random 100)
                            :collect i)))
    (benchmark:with-timing (n)
      (loop :for i :in random-list
            :do (push (cons i i) ht)))))


(defun run-lookup-alist (&optional (n 1000000))
  "Looking up values in an alist"
  (declare (type fixnum n))
  (let* ((ht '())
         (random-list (loop :repeat n
                            :for i = (random 100)
                            :collect i)))
    ;; Initialize Values
    (loop :for i :in random-list
          :do (push (cons i i) ht))
    (benchmark:with-timing (n)
      (loop :for i :in random-list
            :do (assoc i ht)))))
