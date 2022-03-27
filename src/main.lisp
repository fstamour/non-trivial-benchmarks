(defpackage #:non-trivial-benchmarks
  (:use :cl)
  (:export :run))

(in-package #:non-trivial-benchmarks)

(defun find-benchmark-packages ()
  "Find all packages that contains benchmarks."
  (remove-if-not #'(lambda (package)
                     (let ((prefix "non-trivial-benchmarks/")
                           (name (string-downcase (package-name package))))
                       (and
                        (alexandria:starts-with-subseq prefix name)
                        ;; has another "/" after the prefix
                        (position #\/ name :start (length prefix)))))
                 (list-all-packages)))

(defun find-benchmarks (package)
  "Find all the exported functions that starts with \"run\"."
  (loop :for symbol :being :the :external-symbols :of package
        :when (and
               (fdefinition symbol)
               (alexandria:starts-with-subseq
                "run"
                (string-downcase (symbol-name symbol))))
          :collect symbol))

(defun validate-benchmarks ()
  (loop :for package :in (find-benchmark-packages)
        :do (loop :for fn :in (find-benchmarks package)
                  :unless (documentation fn 'function)
                    :do (warn "~a:~a is missing a docstring"
                              (package-name (symbol-package fn))
                              fn))))

(defun run ()
  "Run all exported benchmarks."
  (validate-benchmarks)
  (loop :for package :in (find-benchmark-packages)
        :do
           (format t "~&Running benchmarks in the ~a package..." package)
           (loop :for fn :in (find-benchmarks package)
                 :do
                    (format t "~&Running the benchmark ~a..." fn)
                    (finish-output)
                    (funcall fn))))
