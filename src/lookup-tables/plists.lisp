(defpackage #:non-trivial-benchmarks/lookup-tables/plists  (:use :cl))

(in-package #:non-trivial-benchmarks/lookup-tables/plists)

(export
 (defun run-insertion-plist (&optional (n 1000000))
   "Sequencially inserting values into an plist"
   (declare (type fixnum n))
   (let* ((ht '())
          (random-list (loop :repeat n
                             :for i = (random 100)
                             :collect i)))
     (benchmark:with-timing (n)
                            (loop :for i :in random-list
                                  :do (push (cons i i) ht))))))


(export
 (defun run-lookup-plist (&optional (n 1000000))
   "Looking up values in an plist"
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
                                  :do (assoc i ht))))))
