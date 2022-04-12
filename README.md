# non-trivial-benchmarks

Some Common lisp benchmarks to compare libraries and techniques.

## Setup

If you would like to run or adapt the test suite it's best you use
[qlot](https://github.com/fukamachi/qlot). Qlot provides a way for
developers to ensure they have the library versions as the last time
the tests where ran.

### (Option 1) Roswell

Installing qlot with roswell is as easy as

```bash
ros install qlot
```

Then ensure qlot is in your path

Then install the dependencies using

```bash
qlot install
```

### (Option 2) Quicklisp

Simply start up a repl at the root directory then in the repl run

```lisp
(ql:quickload :qlot)
(qlot:install :non-trivial-benchmarks)
```

### Running the benchmarks

If the dependencies were installed correctly you can run the
benchmarks by running `make` in the root directory.
