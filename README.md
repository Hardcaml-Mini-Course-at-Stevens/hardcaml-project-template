# hardcaml-project-template

An example project template for hardcaml designs.  

# Project Structure

The project structure consists of a library called `hardcaml_example` in `src`.  
The library exports a single module called `Counter` which implements a very basic 
upcounter hardware design.

A testbench is given the a library called `hardcaml_example_test` in the `test` directory.
It implements a basic testbench in the function `Test_counter.test_count` which returns 
a waveform.  The waveform is printed as an expect test.

The `bin` directory implements an executable with 3 commands

- simulate: runs the testbench and opens an interactive viewer to see the results.
- verilog: print verilog for the counter design
- vhdl: print VHDL for the counter design

## Using mli files

Using mli files is generally recommenend, though not necessary.  Especially as files 
get larger and more complicated it can be very useful to control what is exported from 
Ocaml modules.

That being said, given they are not required it is reasonable to not want to write them.

# The `hardcaml_example` library

The library in `src` is where we will generally put our hardcaml designs.  In this case 
there is a single counter module.

Looking at the `dune` file we have called the library `hardcaml_example`.  It depends on the
libraries `core` and `hardcaml`.  Finally, we have enabled 2 preprocessors - `ppx_jane` and
`ppx_hardcaml` - most hardcaml designs will use need both of them.

# Testing in `hardcaml_example_tests`

The library in `test` implements a testbench for our example counter design.

The dune file names the library.  Note that it depends on the `hardcaml_example` library we 
just defined - we need it to get the implementation of the counter so we can test it.  In
addition we add `hardcaml_waveterm` so we can show waveform results.

We also have a preprocess stanza - this time we only need `ppx_jane` as we dont need to
called `[@@deriving hardcaml]` in the testbench code.

Lastly, there is a `(inline_tests)` stanza.  This tells dune that this library includes tests
which should be run when it is askked to process the `runtest` alias.

# The `counter.exe` Executable

In `bin` we define an executable called `counter.exe`.

It depends on `hardcaml_example` so it can create a circuit for the counter design to 
print RTL (Verilog or VHDL).

It also depends on `hardcaml_example_tests` so it can run the testbench to generate a 
waveform.  To show the waveform we link `hardcaml_waveterm.interactive` which allows
us to display the waveform in the terminal.