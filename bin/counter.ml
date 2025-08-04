open Core
open! Hardcaml
open Hardcaml_example

let nexys17_100t =
  Command.basic
    ~summary:"Generate top level code for Nexys A7 board"
    [%map_open.Command
      let () = return () in
      fun () -> Hardcaml_hobby_boards.Nexys_a7_100t.generate_top (Counter.create ())]
;;

let () =
  Command_unix.run
    (Command.group
       ~summary:"simulate or generate rtl for counter design."
       [ "nexys-a7", nexys17_100t ])
;;
