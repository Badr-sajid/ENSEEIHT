(******* TRIS ******)

(** Tri par insertion **)

(*CONTRAT
Fonction qui ajoute un élément dans une liste triée, selon un ordre donné
Type : ('a->'a->bool)->'a->'a list -> 'a list
Paramètre : ordre  ('a->'a->bool), un ordre sur les éléments de la liste
Paramètre : elt, l'élement à ajouter
Paramètre : l, la liste triée dans laquelle ajouter elt
Résultat : une liste triée avec les éléments de l, plus elt
*)
let rec insert ordre elt l = 
  match l with
  | [] -> [elt]
  | t::q -> if (ordre t elt) then t::(insert ordre elt q) 
            else elt::l

(* TESTS *)
let%test _ = insert (fun x y -> x<y) 3 []=[3]
let%test _ = insert (fun x y -> x<y) 3 [2;4;5]=[2;3;4;5]
let%test _ = insert (fun x y -> x > y) 6 [3;2;1]=[6;3;2;1]



(*CONTRAT
Fonction qui trie une liste, selon un ordre donné
Type : ('a->'a->bool)->'a list -> 'a list
Paramètre : ordre  ('a->'a->bool), un ordre sur les éléments de la liste
Paramètre : l, la liste à trier
Résultat : une liste triée avec les éléments de l
*)
let rec tri_insertion ordre l = 
  match l with
  | [] -> []
  | t::q -> insert ordre t (tri_insertion ordre q)

(* TESTS *)
let%test _ = tri_insertion (fun x y -> x<y) [] =[]
let%test _ = tri_insertion (fun x y -> x<y) [4;2;4;3;1] =[1;2;3;4;4]
let%test _ = tri_insertion (fun x y -> x > y) [4;7;2;4;1;2;2;7]=[7;7;4;4;2;2;2;1]


(** Tri fusion **)

(* CONTRAT
Fonction qui décompose une liste en deux listes de tailles égales à plus ou moins un élément
Paramètre : l, la liste à couper en deux
Retour : deux listes
*)
let rec scinde l =
    match l with
    | []        -> ([],[])
    | [t]       -> ([t],[])
    | ta::tb::q -> let (l1,l2) = scinde q in ((ta::l1),(tb::l2))

(* TESTS *)
(* Peuvent être modifiés selon l'algorithme choisi *)
let%test _ = scinde [1;2;3;4] = ([1;3],[2;4])
let%test _ = scinde [1;2;3] = ([1;3],[2])
let%test _ = scinde [1] = ([1],[])
let%test _ = scinde [] = ([],[])


(* Fusionne deux listes triées pour en faire une seule triée
Paramètre : ordre  ('a->'a->bool), un ordre sur les éléments de la liste
Paramètre : l1 et l2, les deux listes triées
Résultat : une liste triée avec les éléments de l1 et l2
*)
let rec fusionne ordre l1 l2 = 
  match l1 with
  | []   -> l2
  | t::q -> fusionne ordre q (insert ordre t l2)

(*TESTS*)
let%test _ = fusionne (fun x y -> x<y) [1;2;4;5;6] [3;4] = [1;2;3;4;4;5;6]
let%test _ = fusionne (fun x y -> x<y) [1;2;4] [3;4] = [1;2;3;4;4]
let%test _ = fusionne (fun x y -> x<y) [1;2;4] [3;4;8;9;10] = [1;2;3;4;4;8;9;10]
let%test _ = fusionne (fun x y -> x<y) [] [] = []
let%test _ = fusionne (fun x y -> x<y) [1] [] = [1]
let%test _ = fusionne (fun x y -> x<y) [] [1] = [1]
let%test _ = fusionne (fun x y -> x<y) [1] [2] = [1;2]
let%test _ = fusionne (fun x y -> x>y) [1] [2] = [2;1]


(* CONTRAT
Fonction qui trie une liste, selon un ordre donné
Type : ('a->'a->bool)->'a list -> 'a list
Paramètre : ordre  ('a->'a->bool), un ordre sur les éléments de la liste
Paramètre : l, la liste à trier
Résultat : une liste triée avec les éléments de l
*)
let rec tri_fusion ordre l =
  match l with 
  | []  -> []
  | [_] -> l
  | _   -> let (l1,l2) = scinde l in fusionne ordre (tri_fusion ordre l1) (tri_fusion ordre l2) 


(* TESTS *)
let%test _ = tri_fusion (fun x y -> x<y) [] =[]
let%test _ = tri_fusion (fun x y -> x<y) [4;2;4;3;1] =[1;2;3;4;4]
let%test _ = tri_fusion (fun x y -> x > y) [4;7;2;4;1;2;2;7]=[7;7;4;4;2;2;2;1]


(** Parsing du fichier *)
open Lexing

(* Affiche un quadruplet composé 
- du sexe des personnes ayant reçu ce prénom : 1 pour les hommes, 2 pour les femmes
- du prénom
- de l'année
- du nombre de fois où ce prénom a été donné cette année là
*)
let print_stat (sexe,nom,annee,nb) =
  Printf.eprintf "%s,%s,%d,%d%!\n" (if (sexe=1) then "M" else "F") nom annee nb

(* Analyse le fichier nat2016.txt (stratistique des prénoms entre 1900 et 2016) 
 et construit une liste de quadruplet (sexe,prénom,année,nombre d'affectation)
*)

let listStat = 
  let input = open_in "nat2016.txt" in 
  let filebuf = Lexing.from_channel input in
  Parser.main Lexer.token filebuf
  

(* Analyse le fichier nathomme2016.txt (stratistique des prénoms d'homme commençant par un A ou un B entre 1900 et 2016) 
 et construit une liste de quadruplets (sexe,prénom,année,nombre d'affectations)
*)
let listStatHomme = 
  let input = open_in "nathomme2016.txt" in 
  let filebuf = Lexing.from_channel input in
  Parser.main Lexer.token filebuf
  


(** Les contrats et les tests des fonctions suivantes sont à écrire *)

let tri_fusion_listStatHomme = tri_fusion (fun (_,_,_,x) (_,_,_,y) -> x>y) listStatHomme

let temps_fusion = let t1 = Sys.time() in let l = tri_fusion_listStatHomme in Sys.time() -. t1

let tri_insertion_listStatHomme = tri_insertion (fun (_,_,_,x) (_,_,_,y) -> x>y) listStatHomme

let temps_insertion  = let t1 = Sys.time() in let l = tri_insertion_listStatHomme in Sys.time() -. t1

let temps = temps_fusion -. temps_insertion

(* ------------------------------------------------------------------------------------------------------------ *)

let tri_sort_listStat = List.sort (fun (_,_,_,x) (_,_,_,y) -> if x>y then x else y) listStat
let temps_sort = let t1 = Sys.time() in let l = tri_sort_listStat in Sys.time() -. t1

(*let tri_fusion_listStat = tri_fusion (fun (_,_,_,x) (_,_,_,y) -> x>y) listStat
let temps_fusion = let t1 = Sys.time() in let l = tri_fusion_listStat in Sys.time() -. t1*)