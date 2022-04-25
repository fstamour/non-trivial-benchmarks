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
  :components ((:file "utils")))

(defsystem #:non-trivial-benchmarks/channels
  :name "non-trivial-benchmarks"
  :version "0"
  :maintainer "Francis St-Amour"
  :author ("Francis St-Amour"
           "Gavin Freeborn")
  :licence "MIT License"
  :description "Benchmarking libraries that provide channels"
  :depends-on (#:non-trivial-benchmarks/common
               #:eager-future2
               #:calispel
               #:lparallel
               #:green-threads)
  :pathname "src/channels"
  :components
  ((:file "calispel")
   (:file "lparallel")
   (:file "green-threads")))

(defsystem #:non-trivial-benchmarks/lookup-tables
  :name "non-trivial-benchmarks"
  :version "0"
  :maintainer "Francis St-Amour"
  :author ("Francis St-Amour"
           "Gavin Freeborn")
  :licence "MIT License"
  :description "Benchmarking Lookup and Insertion for different forms of lookup tables"
  :depends-on (#:non-trivial-benchmarks/common
               #:fset)
  :pathname "src/lookup-tables"
  :components
  ((:file "hash-tables")
   (:file "alists")
   (:file "plists")
   (:file "fset")))

(defsystem #:non-trivial-benchmarks
  :name "non-trivial-benchmarks"
  :version "0"
  :maintainer "Francis St-Amour"
  :author ("Francis St-Amour")
  :licence "MIT License"
  :description "Some benchmarks to compare libraries and techniques"
  :depends-on (#:non-trivial-benchmarks/channels
               #:non-trivial-benchmarks/lookup-tables)
  :pathname "src"
  :components ((:file "main")))
