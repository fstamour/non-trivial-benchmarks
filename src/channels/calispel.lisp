;;;; These benchmarks are not exported, so they're effectively
;;;; disabled. I disabled them because they deadlock.

(defpackage #:non-trivial-benchmarks/channels/calispel
  (:use :cl))

(in-package #:non-trivial-benchmarks/channels/calispel)

(defun run-single-message (&optional (n 1000000))
  "Sending and receiving 1 message at a time between two threads using
calispel."
  (let ((chan
          (make-instance 'calispel:channel)))
    ;; TODO we should not include the thread creation in the
    ;; benchmark.
    (benchmark:with-timing (n)
      (eager-future2:pexec
        (calispel:! chan 42))
      (calispel:? chan))))

(defun run-multiple-messages (&optional (n 1000000))
  "Sending and receiving 5 message at a time between two threads using
calispel, doing simple math on the messages."
  (let ((chan
          (make-instance 'calispel:channel)))
    (benchmark:with-timing (n)
      (eager-future2:pexec ()
        (loop
          :initially (calispel:! chan 10)
          :repeat 5
          :do (calispel:! chan (+ 10 (calispel:? chan)))))
      (loop
        :repeat 5
        :do (calispel:! chan (+ 10 (calispel:? chan)))
        :finally (calispel:? chan)))))
