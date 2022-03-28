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

(defun benchmark-name (fn)
  (concatenate 'string
               (package-name
                (symbol-package fn))
               ":"
               (symbol-name fn)))

(defun benchmark-description (fn)
  (when (documentation fn 'function)
    (remove #\Newline (documentation fn 'function))))

(defun validate-benchmarks ()
  (loop :for package :in (find-benchmark-packages)
        :do (loop :for fn :in (find-benchmarks package)
                  :unless (benchmark-description fn)
                    :do (warn "~a is missing a docstring"
                              (benchmark-name fn)))))

(defun run ()
  "Run all exported benchmarks."
  (validate-benchmarks)
  (loop :for package :in (find-benchmark-packages)
        :do
           (format t "~&~tRunning benchmarks in the ~a package..."
                   (package-name package))
           (loop :for fn :in (find-benchmarks package)
                 :do
                    (format t "~&~2t~a~%~
                               ~3t~a..."
                            (benchmark-name fn)
                            (benchmark-description fn))
                    (finish-output)
                    (funcall fn))))
