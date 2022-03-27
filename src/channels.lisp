
;;; Green-threads

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
