(defpackage #:non-trivial-benchmarks/channels/lparallel
  (:use :cl)
  (:export
   ;; TODO find much much better name :P
   #:run
   #:run2
   ))

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

(defun run (&optional (n 1000000))
  (benchmark:with-timing (n)
    (let ((chan (lparallel:make-channel)))
      (lparallel:submit-task chan #'(lambda () 42))
      (lparallel:receive-result chan))))

(defun run2 (&optional (n 1000000))
  (let ((chan (lparallel:make-channel))
        (q1 (lparallel.queue:make-queue))
        (q2 (lparallel.queue:make-queue)))
    (benchmark:with-timing (n)
      (lparallel:submit-task
       chan
       #'(lambda ()
           (loop
             :initially (lparallel.queue:push-queue 10 q1)
             :repeat 5
             :do (lparallel.queue:push-queue
                  (+ 10 (lparallel.queue:pop-queue q2)) q1))))
      (loop
        :repeat 5
        :do (lparallel.queue:push-queue
             (+ 10 (lparallel.queue:pop-queue q1)) q2)
        :finally (lparallel.queue:pop-queue q1))
      (lparallel:receive-result chan))))
