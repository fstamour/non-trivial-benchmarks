#!/bin/sh
#
# Load the system with sbcl and run the benchmarks
#
# This script serves has documentation more than anything.
#

sbcl --eval '(asdf:load-system :non-trivial-benchmarks)' \
     --eval '(non-trivial-benchmarks:run)' \
     --quit
