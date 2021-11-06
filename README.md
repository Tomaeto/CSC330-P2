# Screen Formatting

Screen Formatting Project

Contains 6 directories that each contain Screen Formatting program in different languages

Instructions assume user starts in formatScr folder

Each directory contains a sample input text file `input.txt`

To run Ada:

```
cd Ada
gnatmake formatscr.adb
formatscr
```

To run Fortran:

```
cd fortran
gfortran formatScr.f95
a.out
```

To run Julia:

```
cd julia
formatScr.jl
```

To run Lisp:

```
cd lisp
formatScr.lisp
```

To run Rust:

```
cd rust/formatScr
cargo run
```

Rust program throws error messages concerning naming style, but still runs.
