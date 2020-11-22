(** Exercice à rendre **)
(** 
    pgcd : int -> int -> int 
    calcule le pgcd des deux entiers entres en parametre
    Parametre : a : int, le premier entier
    Parametre : b : int, le deuxieme entier
    Resultat : int, le pgcd de a et b
    *)
let pgcd a b = 
  let rec aux x y =
    if x = y then x
    else if x < y then aux x (y-x)
    else aux (x-y) y
  in match (a,b) with
    | (0,b) -> b
    | (a,0) -> a
    | _ -> aux (abs a) (abs b)

(** TO DO : tests unitaires *)

let%test _ = pgcd 3 4 = 1
let%test _ = pgcd 12 4 = 4
let%test _ = pgcd (-15) 9 = 3
let%test _ = pgcd 24 65 = 1
let%test _ = pgcd 0 4 = 4
let%test _ = pgcd 12 0 = 12
let%test _ = pgcd (-24) 65 = 1
