#!/bin/sh
#
# Load the system with sbcl and run the benchmarks
#
# This script serves has documentation more than anything.
#

sbcl --load ".qlot/setup.lisp" \
     --eval '(ql:quickload :non-trivial-benchmarks)' \
     --eval '(non-trivial-benchmarks:run)' \
     --quit
