open! Core
open Hardcaml
open Signal

module I = struct
  type 'a t =
    { clock : 'a
    ; enable : 'a
    }
  [@@deriving hardcaml]
end

module O = struct
  type 'a t = { q : 'a [@bits 32] } [@@deriving hardcaml]
end

let create (i : _ I.t) =
  { O.q =
      reg_fb (Reg_spec.create ~clock:i.clock ()) ~enable:i.enable ~width:32 ~f:(fun d ->
        d +:. 1)
  }
;;

let board () =
  let open Hardcaml_hobby_boards in
  let board = Board.create () in
  let%tydi { clock_100 = clock; _ } = Nexys_a7_100t.Clock_and_reset.create board in
  Nexys_a7_100t.Leds.complete board (create { I.clock; enable = vdd }).q.:[31, 16];
  board
;;
