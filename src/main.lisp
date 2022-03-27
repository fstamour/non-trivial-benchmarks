(defpackage #:non-trivial-benchmarks
  (:use :cl)
  (:export :run))

(in-package #:non-trivial-benchmarks)

(defun run ()
  (format t "~A" :todo))
