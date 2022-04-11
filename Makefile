all: run

# If dependencies are not installed attempt to install them using
# the qlot executable
.qlot/setup.lisp:
	command -v qlot >/dev/null && qlot install

.PHONY: run
run: .qlot/setup.lisp
	./scripts/run.sh

.PHONY: clean
clean:
	rm -rf .qlot
