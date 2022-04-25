(defpackage #:non-trivial-benchmarks/lookup-tables/fset (:use :cl))

(in-package #:non-trivial-benchmarks/lookup-tables/fset)

(export
 (defun run-insertion-fset-map (&optional (n 1000000))
   "Sequentially inserting values into an fset:map"
   (declare (type fixnum n))
   (let* ((fset-map (fset:empty-map))
          (random-list (loop :repeat n
                             :for i = (random 100)
                             :collect i)))
     ;; Note that this isn't exactly the expected usecase of this library
     (benchmark:with-timing (n)
                            (loop :for i :in random-list
                                  :do (setq fset-map (fset:with fset-map i i)))))))


(export
 (defun run-lookup-fset-map (&optional (n 1000000))
   "Looking up values in an fset:map"
   (declare (type fixnum n))
   (let* ((fset-map (fset:empty-map))
          (random-list (loop :repeat n
                             :for i = (random 100)
                             :collect i)))
     ;; Initialize Values
     (loop :for i :in random-list
           :do (setq fset-map (fset:with fset-map i i)))
     (benchmark:with-timing (n)
                            (loop :for i :in random-list
                                  :do (fset:lookup fset-map i))))))
