(defpackage #:non-trivial-benchmarks/channels/calispel
  (:use :cl)

  ;; TODO I disabled these test because they deadlocked on my
  ;; computer...  for run1, if I decreased n by 10x (remove a 0) then
  ;; it runs in under a second. It fells like perhaps the test is
  ;; creating too many threads?
  #+ (or)
  (:export
   ;; TODO find much much better names :P
   #:run1
   #:run2))

(in-package #:non-trivial-benchmarks/channels/calispel)

(defun run1 (&optional (n 1000000))
  "TODO Put a nice description here."
  (let ((chan
          (make-instance 'calispel:channel)))
    ;; TODO we should not include the thread creation in the
    ;; benchmark.
    (benchmark:with-timing (n)
      (eager-future2:pexec
        (calispel:! chan 42))
      (calispel:? chan))))


(defun run2 (&optional (n 1000000))
  "TODO Put a nice description here.
Same as run, but send multiple message at a time."
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