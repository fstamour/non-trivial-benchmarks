#!/bin/sh
#
# Load the system with sbcl and run the benchmarks
#
# This script serves has documentation more than anything.
#

set -u -e

cd "$(git rev-parse --show-toplevel)"

sbcl --eval "(asdf:initialize-source-registry
     \`(:source-registry
        (:directory ,(truename \".\"))
           :inherit-configuration))" \
     --non-interactive \
     --eval '(ql:quickload :non-trivial-benchmarks)' \
     --eval '(non-trivial-benchmarks:run)' \
     --quit
