
module PassePlacementRat : Passe.Passe with type t1 = Ast.AstType.programme and type t2 = Ast.AstPlacement.programme =
struct

  open Tds
  open Ast
  open AstPlacement
  open Type


  type t1 = Ast.AstType.programme
  type t2 = Ast.AstPlacement.programme

(* analyse_placement_instruction : AstType.instruction -> int -> int -> int *)
let rec analyse_placement_instruction i base reg = 
  match i with
  | AstType.Declaration(_, info) -> 
    begin
      match info_ast_to_info info with
      | InfoVar (_,t,_,_) -> modifier_adresse_info base reg info; (getTaille t)
      | _ -> failwith ""
    end
  | AstType.Conditionnelle(_, t, e) ->
      analyse_placement_bloc t base reg;
      analyse_placement_bloc e base reg;
      0
  | AstType.TantQue(_, b) ->
      analyse_placement_bloc b base reg;
      0
  | _ -> 0
and analyse_placement_bloc li base reg = 
  match li with
  | t::q -> 
      let taille = analyse_placement_instruction t base reg in 
      analyse_placement_bloc q (base + taille) reg
  | [] -> ()

 
  (* Les deux méthodes suivantes sont en commentaire, car elles ne sont jamais utilisées *)
  (* let analyser_placement_parametre info base =
        match info_ast_to_info info with
        | InfoVar(_,t,_,_) -> 
            let _ = modifier_adresse_info (base - getTaille t) "LB" info in getTaille t
        | _ -> failwith "internal error: parametre not found"

    
    let rec analyse_placement_paramteres lp = 
       match lp with
       | [] -> 0
       | t::q -> 
           let tailleq = analyse_placement_paramteres q in 
               let taillet = analyser_placement_parametre t (-tailleq) in tailleq + taillet*)
(*  AstType.fonction -> AstPlacement.fonction *)


(* analyse_placement_fonction : AstType.fonction -> AstPlacement.fonction *)
let analyse_placement_fonction(AstType.Fonction(n,lp,li,e)) = 
  let calcul param d =
    match info_ast_to_info param with
    | InfoVar(_,t,_,_) ->  
        let nd = d-getTaille t in 
        modifier_adresse_info nd "LB" param;
        nd
    | _ -> failwith ""
  in
  let _ = List.fold_right calcul lp 0 in
  let _ = analyse_placement_bloc li 3 "LB" in
  Fonction(n, lp, li, e)

(* AstType.programme -> AstPlacement.programme *)
let analyser (AstType.Programme(fonctions, prog)) = 
  let _ = analyse_placement_bloc prog 0 "SB" in 
  let fcts = List.map analyse_placement_fonction fonctions in 
  Programme(fcts, prog)

end