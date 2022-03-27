(defpackage #:non-trivial-benchmarks/utils
  (:use :cl)
  (:export #:with-timing))

(in-package #:non-trivial-benchmarks/utils)

(defun compute-metrics (timer computations)
  `((:name ,@computations)
    ,(loop :for metric :in (benchmark:metrics timer)
           :collect (append (list metric)
                            (benchmark:compute computations metric)))))

(defmacro with-timing ((n &optional
                            (timer-form '(benchmark:make-timer))
                            (computations '*default-computations*))
                       &body forms)
  "Evaluates FORMS N times, returns all COMPUTATIONS for all metrics."
  (let ((timer (gensym "TIMER")))
    `(let ((,timer ,timer-form))
       (loop repeat ,n
             do (benchmark:with-sampling (,timer)
                  ,@forms))
       (compute-metrics timer ,computations))))
