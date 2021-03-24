
(*  Module qui permet la décomposition et la recomposition de données **)
(*  Passage du type t1 vers une liste d'éléments de type t2 (décompose) **)
(*  et inversement (recopose).**)
module type DecomposeRecompose =
sig
  (*  Type de la donnée **)
  type mot
  (*  Type des symboles de l'alphabet de t1 **)
  type symbole

  val decompose : mot -> symbole list
  val recompose : symbole list -> mot
end

module DRString : DecomposeRecompose with type mot=string and type symbole = char =
struct
  type mot = string

  type symbole = char

  let decompose mot = 
    let rec decompose_mot i accu =
      if i < 0 then accu
      else decompose_mot (i-1) (mot.[i]::accu)
    in decompose_mot (String.length mot - 1) []

  let recompose lc = 
    List.fold_right (fun t q -> String.make 1 t ^ q) lc ""
end

module DRNat : DecomposeRecompose with type mot=int and type symbole=int =
struct
  type mot = int

  type symbole = int

  let decompose s = 
    let rec decompose_chiffre i accu =
      if i < 0 then accu
      else decompose_chiffre (i-1) (((int_of_char (string_of_int s).[i])-(int_of_char '0'))::accu)
    in decompose_chiffre (String.length (string_of_int s) - 1) []

  let recompose ls = List.fold_left(fun t q -> (t*10)+(q)) 0 ls

end

let%test _ = (DRNat.decompose 248 = [2;4;8])
let%test _ = (DRNat.recompose [2;4;8] = 248)