;;; General Setup
(ql:quickload :trivial-benchmark)
;;; Calispel
(ql:quickload :calispel)
(ql:quickload :eager-future2)

(defparameter *chan*
  (make-instance 'calispel:channel))

(benchmark:with-timing (1000000)
  (eager-future2:pexec
    (calispel:! *chan* 42))
  (calispel:? *chan*))
#|
-                samples  total       minimum   maximum   median    average    deviation
real-time        1000000  15.090046   0         0.1       0         0.000015   0.000411
run-time         1000000  26.975489   0.000006  0.094754  0.000018  0.000027   0.000213
user-run-time    1000000  13.261213   0         0.092004  0.000014  0.000013   0.000151
system-run-time  1000000  14.109874   0         0.019929  0.000007  0.000014   0.000135
page-faults      1000000  0           0         0         0         0          0.0
gc-run-time      1000000  507.735     0         93.44     0         0.000508   0.150308
bytes-consed     1000000  1013893328  0         11232800  0         1013.8933  12756.485
eval-calls       1000000  0           0         0         0         0          0.0
|#
;;;; Multi Message
(defparameter *chan*
  (make-instance 'calispel:channel))

(benchmark:with-timing (1000000)
  (eager-future2:pexec ()
    (loop
      :initially (calispel:! *chan* 10)
      :repeat 5
      :do (calispel:! *chan* (+ 10 (calispel:? *chan*)))))
  (loop
    :repeat 5
    :do (calispel:! *chan* (+ 10 (calispel:? *chan*)))
    :finally (calispel:? *chan*)))

#|
-                samples  total       minimum   maximum   median    average   deviation
real-time        1000000  77.49031    0         0.050001  0         0.000077  0.000882
run-time         1000000  110.03609   0.000033  0.051525  0.000091  0.00011   0.00022
user-run-time    1000000  59.89902    0         0.051527  0.000059  0.00006   0.000147
system-run-time  1000000  50.67493    0         0.028984  0.000035  0.000051  0.000157
page-faults      1000000  0           0         0         0         0         0.0
gc-run-time      1000000  892.176     0         50.171    0         0.000892  0.126727
bytes-consed     1000000  4418523024  0         11263232  0         4418.523  18450.777
eval-calls       1000000  0           0         0         0         0         0.0
|#
#+end_src


;;; lparallels
(ql:quickload :lparallel)

;; Not sure how this should be handled in benchmarking
(setf lparallel:*kernel* (lparallel:make-kernel 8))

(defparameter *chan* (lparallel:make-channel))
(benchmark:with-timing (1000000)
  (let ((lparallel:*task-category* 'my-stuff))
    (lparallel:submit-task *chan* #'(lambda () 42)))
  (lparallel:receive-result *chan*))
#|
-                samples  total      minimum  maximum   median    average    deviation
real-time        1000000  12.480038  0        0.06      0         0.000012   0.000392
run-time         1000000  96.76701   0        0.285451  0.000008  0.000097   0.002414
user-run-time    1000000  90.52401   0        0.285451  0.000007  0.000091   0.002315
system-run-time  1000000  4.504161   0        0.019549  0         0.000005   0.000198
page-faults      1000000  0          0        0         0         0          0.0
gc-run-time      1000000  116.296    0        62.044    0         0.000116   0.067153
bytes-consed     1000000  249428384  0        65536     0         249.42839  2845.9097
eval-calls       1000000  0          0        0         0         0          0.0
|#

;;;; Multi Message
(setf lparallel:*kernel* (lparallel:make-kernel 8))

(defparameter *chan* (lparallel:make-channel))
(defparameter *q* (lparallel.queue:make-queue))
(defparameter *q2* (lparallel.queue:make-queue))

(benchmark:with-timing (1000000)
  (lparallel:submit-task
   *chan*
   #'(lambda ()
       (loop
	 :initially (lparallel.queue:push-queue 10 *q*)
	 :repeat 5
	 :do (lparallel.queue:push-queue
	      (+ 10 (lparallel.queue:pop-queue *q2*)) *q*))))
  (loop
    :repeat 5
    :do (lparallel.queue:push-queue
	 (+ 10 (lparallel.queue:pop-queue *q*)) *q2*)
    :finally (lparallel.queue:pop-queue *q*))
  (lparallel:receive-result *chan*))

#|
-                samples  total      minimum   maximum   median    average   deviation
real-time        1000000  92.45006   0         0.06      0         0.000092  0.000963
run-time         1000000  622.5068   0.000009  0.067196  0.000183  0.000623  0.001435
user-run-time    1000000  587.612    0         0.060621  0.000169  0.000588  0.00139
system-run-time  1000000  35.465958  0         0.028603  0         0.000035  0.000252
page-faults      1000000  0          0         0         0         0         0.0
gc-run-time      1000000  342.004    0         62.182    0         0.000342  0.115923
bytes-consed     1000000  595171360  0         131072    0         595.1714  4397.095
eval-calls       1000000  0          0         0         0         0         0.0
|#

;;; Green-threads
(ql:quickload :green-threads)

(defparameter *chan* (make-instance 'gt:channel))

(benchmark:with-timing (1000000)
  (gt:with-green-thread
    (gt:with-green-thread
      (gt:recv/cc *chan*))
    (gt:with-green-thread
      (gt:send/cc *chan* 1))))

#|
-                samples  total       minimum   maximum   median    average    deviation
real-time        1000000  6.800021    0         0.090001  0         0.000007   0.000277
run-time         1000000  6.897386    0.000004  0.087411  0.000006  0.000007   0.000112
user-run-time    1000000  4.887487    0         0.080012  0.000006  0.000005   0.000103
system-run-time  1000000  2.09931     0         0.013611  0         0.000002   0.00002
page-faults      1000000  0           0         0         0         0          0.0
gc-run-time      1000000  368.509     0         86.044    0         0.000369   0.105412
bytes-consed     1000000  2286751232  0         6638048   0         2286.7512  10732.878
eval-calls       1000000  0           0         0         0         0          0.0
|#
;;;; Multi Message
(defparameter *chan* (make-instance 'gt:channel))

(benchmark:with-timing (1000000)
  (gt:with-green-thread
    (gt:with-green-thread
      (loop
	:initially (gt:send/cc *chan* 10)
	:repeat 5
	:do (gt:send/cc *chan* (+ 10 (gt:recv/cc *chan*)))))
    (loop
      :repeat 5
      :do (gt:send/cc *chan* (+ 10 (gt:recv/cc *chan*)))
      :finally (gt:recv/cc *chan*))))
#|
-                samples  total       minimum  maximum   median    average   deviation
real-time        1000000  16.010096   0        0.060001  0         0.000016  0.000409
run-time         1000000  16.241562   0        0.058835  0.000014  0.000016  0.000115
user-run-time    1000000  14.548427   0        0.058836  0.000014  0.000015  0.000105
system-run-time  1000000  1.75259     0        0.013941  0         0.000002  0.000028
page-faults      1000000  0           0        0         0         0         0.0
gc-run-time      1000000  827.324     0        57.824    0         0.000827  0.106816
bytes-consed     1000000  8889297472  0        6625408   0         8889.298  16661.602
eval-calls       1000000  0           0        0         0         0         0.0
|#
