(defsystem #:non-trivial-benchmarks/common
  :name "non-trivial-benchmarks"
  :version "0"
  :maintainer "Francis St-Amour"
  :author ("Francis St-Amour")
  :licence "MIT License"
  :description "Utilities and libraries common to some benchmarks"
  :depends-on (;; for benchmarking
               #:trivial-benchmark
               ;; Utilities
               #:alexandria
               ;; Logging
               #:log4cl)
  :pathname "src"
  :components ())

(defsystem #:non-trivial-benchmarks/channels
  :name "non-trivial-benchmarks"
  :version "0"
  :maintainer "Francis St-Amour"
  :author ("Francis St-Amour"
           "Gavin Freeborn")
  :licence "MIT License"
  :description "Benchmarking libraries that provide channels"
  :depends-on (;; for benchmarking
               #:trivial-benchmark
               ;; Utilities
               #:alexandria
               ;; Logging
               #:log4cl)
  :pathname "src/channels"
  :components
  (#+nil(:file "channels")))

(defsystem #:non-trivial-benchmarks
  :name "non-trivial-benchmarks"
  :version "0"
  :maintainer "Francis St-Amour"
  :author ("Francis St-Amour")
  :licence "MIT License"
  :description "Some benchmarks to compare libraries and techniques"
  :depends-on (#:non-trivial-benchmarks/channels)
  :pathname "src"
  :components ((:file "main")))
