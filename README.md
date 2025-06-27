# hardcaml-project-template

An example project template for hardcaml designs.  

# Project Structure

The project consists of three directories which implement a simple hardware 
module, provide integrated runtests and an executable for simulation and RTL 
generation.

This structure is commonly used for hardcaml designs and gets more useful as 
projects get more complicated.  We will discuss ways to simplify the project 
structure for smaller designs.

## The `hardcaml_example` library

The library in `src` is where we will generally put our hardcaml designs.  In this 
case there is a single counter module.

Looking at the `dune` file we have called the library `hardcaml_example` in the 
name stanza.  It depends on the libraries `core` and `hardcaml`.  Finally, we have 
enabled 2 preprocessors - `ppx_jane` and `ppx_hardcaml` - most hardcaml designs 
will need both of them.

## Testing in `hardcaml_example_tests`

The library in `test` implements a testbench for our example counter design.

The dune file names the library `hardcaml_example_tests`.  Note that it depends on 
the `hardcaml_example` library we just defined - we need it to get the implementation 
of the counter module so we can test it.  In addition we add `hardcaml_waveterm` so 
we can show waveform results.

We also have a preprocess stanza - this time we only need `ppx_jane` as we dont 
call `[@@deriving hardcaml]` in the testbench code.

Lastly, there is a `(inline_tests)` stanza.  This tells dune that this library 
includes tests which should be run when it is asked to process the `runtest` 
alias.

## The `counter.exe` Executable

In `bin` we define an executable called `counter.exe`.

It depends on `hardcaml_example` so it can create a circuit for the counter design to 
print RTL (Verilog or VHDL).

It also depends on `hardcaml_example_tests` so it can run the testbench to generate a 
waveform.  To show the waveform we link `hardcaml_waveterm.interactive` which allows
us to view the waveform in the terminal.

It is written using the `Core.Command` command line parsing library and provides the 
following commands.

- **simulate**: execute the testbench and show and interactive waveform for debugging.
- **verilog**: print the design as Verilog.
- **vhdl**: print the desing as VHDL.

## Misc files

- **.gitignore**: Some common files and directories used by dune (and opam) which 
  should not be checked into a repository.
- **.ocamlformat**: Enable automatic formatting of code (requires ocamlformat support 
  in your editor).
- **dune-project**: Basic dune project definition file.

## Building and running

To build the project run:

```
dune build
```

dune will either complete successfully or print some errors to be fixed.

Adding `-w` will enable watch (or polling mode).  dune will run continuously and
react to changes in the source code.

```
dune build -w
```

To execute the tests we run dune as follows:

```
dune runtest
```

Again, it is possible to use the `-w` argument to enable watch mode.

When running tests, dune will print any expect test diffs that occur as you change 
your code.  You can accept these changes with

```
dune promote
```

This works in watch mode as well.

To run the executable we use:

```
dune exec bin/counter.exe
```

## Simplifying the Project

The executable in this project is only useful if you want to:

1. Generate RTL from the library
2. Run longer simulations that are inconvenient to implement with an expect test.

If you don't need either of these things you can skip defining the executable
altogether.

Although it a common practice to split library code and test code, for smaller
projects it can be simpler to keep them together.  In this case we would
remove the `test` directory and move the tests into `src`.  Dont forget to also
move the `(inline_tests)` stanza to the dune file in `src`.

### Using mli files

Using mli files is generally recommened, though not necessary.  Especially as files 
get larger and more complicated it can be very useful to control what is exported 
from Ocaml modules.

That being said, for simpler designs it is reasonable to not want to write them.  
When not included, all top level values will be exported.
