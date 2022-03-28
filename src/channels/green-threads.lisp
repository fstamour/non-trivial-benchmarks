(defpackage #:non-trivial-benchmarks/channels/green-threads
  (:use :cl))

(in-package #:non-trivial-benchmarks/channels/green-threads)

(export
 (defun run-single-message (&optional (n 1000000))
   "Sending and receiving 1 message at a time with green-threads."
   (let ((chan (make-instance 'gt:channel)))
     (benchmark:with-timing (n)
       (gt:with-green-thread
         (gt:with-green-thread
           (gt:recv/cc chan))
         (gt:with-green-thread
           (gt:send/cc chan 1)))))))

(export
 (defun run-multiple-messages (&optional (n 1000000))
   "Sending and receiving 5 message at a time with green-threads."
   (let ((chan (make-instance 'gt:channel)))
     (benchmark:with-timing (n)
       (gt:with-green-thread
         (gt:with-green-thread
           (loop
             :initially (gt:send/cc chan 10)
             :repeat 5
             :do (gt:send/cc chan (+ 10 (gt:recv/cc chan)))))
         (loop
           :repeat 5
           :do (gt:send/cc chan (+ 10 (gt:recv/cc chan)))
           :finally (gt:recv/cc chan)))))))
