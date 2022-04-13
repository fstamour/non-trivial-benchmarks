(defpackage #:non-trivial-benchmarks/lookup-tables/plists  (:use :cl))

(in-package #:non-trivial-benchmarks/lookup-tables/plists)

(export
 (defun run-insertion-plist (&optional (n 1000000))
   "Sequentially inserting values into an plist"
   (declare (type fixnum n))
   (let* ((plist '())
          (random-list (loop :repeat n
                             :for i = (random 100)
                             :collect i)))
     (benchmark:with-timing (n)
                            (loop :for i :in random-list
                                  :do (progn (push i plist)
                                             (push i plist)))))))


(export
 (defun run-lookup-plist (&optional (n 1000000))
   "Looking up values in an plist"
   (declare (type fixnum n))
   (let* ((plist '())
          (random-list (loop :repeat n
                             :for i = (random 100)
                             :collect i)))
     ;; Initialize Values
     (loop :for i :in random-list
           :do (progn (push i plist)
                      (push i plist)))
     (benchmark:with-timing (n)
                            (loop :for i :in random-list
                                  :do (getf plist i))))))
