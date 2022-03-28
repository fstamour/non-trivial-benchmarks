project = lisp

all:run

# If dependancies are not installed attempt to install them using
# the qlot executable
.qlot/setup.lisp:
	command -v qlot >/dev/null && qlot install

run: .qlot/setup.lisp
	./scripts/run.sh
