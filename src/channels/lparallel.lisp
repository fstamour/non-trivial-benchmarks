(defpackage #:non-trivial-benchmarks/channels/lparallel
  (:use :cl))

(in-package #:non-trivial-benchmarks/channels/lparallel)

#|
Welcome to lparallel. To get started, you need to create some worker
threads. Choose the MAKE-KERNEL restart to create them now.

Worker threads are asleep when not in use. They are typically created
once per Lisp session.

Adding the following line to your startup code will prevent this
message from appearing in the future (N is the number of workers):

(setf lparallel:*kernel* (lparallel:make-kernel N))
|#


;; Maybe find a more sensible value than 8, but what?
(setf lparallel:*kernel* (lparallel:make-kernel 8))

(export
 (defun run-single-message (&optional (n 1000000))
   "Running a simple task using lparallel's worker threads and wait for
its result"
   (benchmark:with-timing (n)
     (let ((chan (lparallel:make-channel)))
       (lparallel:submit-task chan #'(lambda () 42))
       (lparallel:receive-result chan)))))

(export
 (defun run-multiple-messages (&optional (n 1000000))
   "Running a task using lparallel's worker threads to do simple math,
using two queues for communicating the results."
   (let ((chan (lparallel:make-channel))
         (send-queue (lparallel.queue:make-queue))
         (recv-queue (lparallel.queue:make-queue)))
     (benchmark:with-timing (n)
       (lparallel:submit-task
        chan
        #'(lambda ()
            (loop
              :initially (lparallel.queue:push-queue 10 send-queue)
              :repeat 5
              :do (lparallel.queue:push-queue
                   (+ 10 (lparallel.queue:pop-queue recv-queue))
                   send-queue))))
       (loop
         :repeat 5
         :do (lparallel.queue:push-queue
              (+ 10 (lparallel.queue:pop-queue send-queue))
              recv-queue)
         :finally (lparallel.queue:pop-queue send-queue))
       (lparallel:receive-result chan)))))
