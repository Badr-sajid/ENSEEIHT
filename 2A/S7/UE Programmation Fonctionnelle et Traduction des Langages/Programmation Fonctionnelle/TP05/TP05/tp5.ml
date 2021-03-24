(* Evaluation des expressions simples *)


(* Module abstrayant les expressions *)
module type ExprSimple =
sig
  type t
  val const : int -> t
  val plus : t -> t -> t
  val mult : t-> t -> t
end

(* Module réalisant l'évaluation d'une expression *)
module EvalSimple : ExprSimple with type t = int =
struct
  type t = int
  let const c = c
  let plus e1 e2 = e1 + e2
  let mult e1 e2 = e1 * e2
end


(* Solution 1 pour tester *)
(* A l'aide de foncteur *)

(* Définition des expressions *)
module ExemplesSimples (E:ExprSimple) =
struct
  (* 1+(2*3) *)
  let exemple1  = E.(plus (const 1) (mult (const 2) (const 3)) )
  (* (5+2)*(2*3) *)
  let exemple2 =  E.(mult (plus (const 5) (const 2)) (mult (const 2) (const 3)) )
end

(* Module d'évaluation des exemples *)
module EvalExemples =  ExemplesSimples (EvalSimple)

let%test _ = (EvalExemples.exemple1 = 7)
let%test _ = (EvalExemples.exemple2 = 42)


module PrintSimple : ExprSimple with type t = string =
struct
  type t = string
  let const c = string_of_int c
  let plus e1 e2 = "(" ^e1^ "+" ^e2^ ")"
  let mult e1 e2 = "(" ^e1^ "*" ^e2^ ")"
end

module PrintSimpleExemples =  ExemplesSimples (PrintSimple)

let%test _ = (PrintSimpleExemples.exemple1 = "(1+(2*3))")
let%test _ = (PrintSimpleExemples.exemple2 = "((5+2)*(2*3))")


module CompteSimple : ExprSimple with type t = int =
struct
  type t = int
  let const c = 0
  let plus e1 e2 = e1+e2+1 
  let mult e1 e2 = e1+e2+1 
end

module CompteSimpleExemples =  ExemplesSimples (CompteSimple)

let%test _ = (CompteSimpleExemples.exemple1 = 2)
let%test _ = (CompteSimpleExemples.exemple2 = 3)


module type ExprVar =
sig 
  type t
  val def : string -> t -> t -> t
  val var : string -> t
end

module type Expr =
sig
  include ExprSimple
  include ExprVar with type t:=t
end

module PrintVar : ExprVar with type t = string =
struct
  type t = string
  let def e1 e2 e3 = "let " ^e1^ " = " ^e2^ " in " ^e3  
  let var e = e
end

module Print : Expr with type t = string =
struct 
  include PrintSimple 
  include (PrintVar : module type of PrintVar  with type t := t)
end

module Exemples (E:Expr) = 
struct
  (* let x = 1+2 in x*3 *)
  let exemple1 = E.(def ("x") (plus (const 1) (const 2)) (mult (var "x") (const 3)) )
end

module PrintExemples =  Exemples(Print)

let%test _ = (PrintExemples.exemple1 = "let x = (1+2) in (x*3)")