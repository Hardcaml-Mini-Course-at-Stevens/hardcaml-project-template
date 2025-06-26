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
  type 'a t = { q : 'a [@bits 8] } [@@deriving hardcaml]
end

let create (i : _ I.t) =
  { O.q =
      reg_fb (Reg_spec.create ~clock:i.clock ()) ~enable:i.enable ~width:8 ~f:(fun d ->
        d +:. 1)
  }
;;
