(defpackage #:non-trivial-benchmarks/lookup-tables/hash-tables  (:use :cl))

(in-package #:non-trivial-benchmarks/lookup-tables/hash-tables)

(export
 (defun run-insertion-hash-table (&optional (n 1000000))
   "Sequentially inserting values into an hash-table"
   (declare (type fixnum n))
   (let* ((ht (make-hash-table))
          (random-list (loop :repeat n
                             :for i = (random 100)
                             :collect i)))
     (benchmark:with-timing (n)
                            (loop :for i :in random-list
                                  :do (setf (gethash i ht) i))))))

(export
 (defun run-lookup-hash-table (&optional (n 1000000))
   "Looking up values in an hash-table"
   (declare (type fixnum n))
   (let* ((ht (make-hash-table))
          (random-list (loop :repeat n
                             :for i = (random 100)
                             :collect i)))
     ;; Initialize Values
     (loop :for i :in random-list
           :do (setf (gethash i ht) i))
     (benchmark:with-timing (n)
                            (loop :for i :in random-list
                                  :do (gethash i ht))))))
