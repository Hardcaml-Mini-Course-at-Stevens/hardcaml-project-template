open Core
open Hardcaml
open Hardcaml_waveterm
open Hardcaml_example

let test_counter () =
  let module Sim = Cyclesim.With_interface (Counter.I) (Counter.O) in
  let sim = Sim.create Counter.create in
  let waves, sim = Waveform.create sim in
  let inputs = Cyclesim.inputs sim in
  inputs.enable := Bits.vdd;
  Cyclesim.cycle ~n:2 sim;
  inputs.enable := Bits.gnd;
  Cyclesim.cycle sim;
  inputs.enable := Bits.vdd;
  Cyclesim.cycle ~n:3 sim;
  waves
;;

let%expect_test "test counter" =
  Waveform.print (test_counter ());
  [%expect
    {|
    ┌Signals────────┐┌Waves──────────────────────────────────────────────┐
    │clock          ││┌───┐   ┌───┐   ┌───┐   ┌───┐   ┌───┐   ┌───┐   ┌──│
    │               ││    └───┘   └───┘   └───┘   └───┘   └───┘   └───┘  │
    │enable         ││────────────────┐       ┌───────────────────────   │
    │               ││                └───────┘                          │
    │               ││────────┬───────┬───────────────┬───────┬───────   │
    │q              ││ 00     │01     │02             │03     │04        │
    │               ││────────┴───────┴───────────────┴───────┴───────   │
    └───────────────┘└───────────────────────────────────────────────────┘
    |}]
;;
