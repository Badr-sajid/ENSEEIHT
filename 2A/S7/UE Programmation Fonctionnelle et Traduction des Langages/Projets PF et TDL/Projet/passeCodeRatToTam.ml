module PasseCodeRatToTam : Passe.Passe  with type t1 = Ast.AstPlacement.programme and type t2 = string =
struct

open Ast
open Tds
open AstPlacement
open Type
open Code

type t1 = Ast.AstPlacement.programme
type t2 = string

(* analyse_code_affectable : affectble -> string *)
let rec analyse_code_affectable a = 
  match a with 
  | AstType.Ident infoast -> 
    begin
      match info_ast_to_info infoast with
      | InfoVar(_, t, reg, dep) -> ("LOAD ("^(string_of_int(getTaille t))^") "^(string_of_int reg)^"["^dep^"]\n",t)
      | InfoConst(_,v) -> ("LOADL "^(string_of_int v)^"\n", Int)
      | _ -> failwith ""
    end
  | AstType.Valeur a1 ->  
      let (na,t) = analyse_code_affectable a1 in
      (na^"LOADI ("^(string_of_int(getTaille t))^")\n",t)

(* analyse_code_expression : expression -> string *)
(* Produit le code correspondant à l'instruction. L'execution de ce code 
   laissera en sommet de pile le résultat de l'évaluation de cette expression *)
let rec analyse_code_expression e = 
  match e with
  | AstType.AppelFonction(info, le) ->
    begin
      match info_ast_to_info info with
      | InfoFun(n,_,_) -> (List.fold_left (fun e1 e2 -> e1 ^ analyse_code_expression e2) "" le) ^ "CALL (ST) " ^ n ^ "\n"
      | _ -> failwith "Erreur"
    end
  | AstType.Rationnel(e1, e2) -> (analyse_code_expression e1) ^ (analyse_code_expression e2)
  | AstType.Numerateur e1 -> (analyse_code_expression e1) ^ "POP (0) 1\n"
  | AstType.Denominateur e1 -> (analyse_code_expression e1) ^ "POP (1) 1\n"
  | AstType.Affectable a -> let (na,_) = analyse_code_affectable a in na
  | AstType.True -> "LOADL 1\n"
  | AstType.False -> "LOADL 0 \n"
  | AstType.Entier i -> "LOADL "^(string_of_int i)^"\n"
  | AstType.Binaire(b, e1, e2) -> 
      let code1 = analyse_code_expression e1 in 
      let code2 = analyse_code_expression e2 in 
      begin 
        match b with 
        | PlusInt -> code1^code2^"SUBR IAdd\n"
        | PlusRat -> code1^code2^"CALL (ST) RAdd\n"
        | MultInt -> code1^code2^"SUBR Imul\n"
        | MultRat -> code1^code2^"CALL (ST) RMUL\n"
        | EquInt -> code1^code2^"SUBR IEq\n"
        | EquBool -> code1^code2^"SUBR IEq\n"
        | EquEnum -> ""
        | Inf -> code1^code2^"SUBR ILss\n"
      end
  | AstType.Null -> ""
  | AstType.New t -> "LOADL "^(string_of_int(getTaille t))^"SUBR Malloc \n"
          
  | AstType.Adresse infoast -> 
    begin
      match info_ast_to_info infoast with
      | InfoVar(_, t, reg, dep) -> "LOADA ("^(string_of_int(getTaille t))^") "^(string_of_int reg)^"["^dep^"]\n"
      | _ -> failwith ""
    end
  | AstType.ValEnum infoast -> 
    begin
      match info_ast_to_info infoast with
      | InfoEnum(_, t) -> "LOADA ("^(string_of_int(getTaille t))^")\n"
      | _ -> failwith ""
    end

(* analyse_code_instruction : instruction -> string *)
let rec analyse_code_instruction i = 
  match i with
  | AstType.Declaration(e, info) -> 
    begin
      match (info_ast_to_info info) with 
      | InfoVar (_, t, reg, dep) -> 
          let ne = analyse_code_expression e in 
          "PUSH "^(string_of_int (getTaille t))^"\n"^ne^
          "STORE ("^(string_of_int (getTaille t))^") "^(string_of_int reg)^"["^dep^"]\n"
      | _ -> failwith ""
    end
  | AstType.Affectation(a, e) -> 
    begin
      match a with 
      | AstType.Ident infoast -> 
        begin
          match info_ast_to_info infoast with 
          | InfoVar(_, t, reg, dep) -> 
              let ne = analyse_code_expression e in 
              ne^"STORE ("^(string_of_int (getTaille t))^") "^(string_of_int reg)^"["^dep^"]\n"
          | _ -> failwith ""
        end           
      | AstType.Valeur _ -> 
          let ne = analyse_code_expression e in
          let (na,ta) = analyse_code_affectable a in
          ne^na^"STOREI ("^(string_of_int (getTaille ta))^")\n"
    end

  | AstType.AffichageInt e -> (analyse_code_expression e) ^ "SUBR IOut\n"
  | AstType.AffichageRat e -> (analyse_code_expression e) ^ "CALL (ST) ROut\n"
  | AstType.AffichageBool e -> (analyse_code_expression e) ^ "SUBR BOut\n"
  | AstType.AffichageEnum e -> (analyse_code_expression e) ^ "\n"
  | AstType.Conditionnelle (cond, b1, b2) -> 
      let ne = analyse_code_expression cond in 
      let nb1, pop_taille_if = analyse_code_bloc b1 in 
      let nb2, pop_taille_else = analyse_code_bloc b2 in 
      let etiq_else = getEtiquette() in
      let etiq_fin_if = getEtiquette() in 
      ne^"JUMPIF (0) "^etiq_else^"\n"^nb1^"POP (0)"^(string_of_int pop_taille_if)^"\n"^
      "JUMP "^etiq_fin_if^"\n"^etiq_else^"\n"^nb2^"POP (0)"^(string_of_int pop_taille_else)^"\n"^
      etiq_fin_if^"\n"
  | AstType.TantQue(c, b) ->
      let nc = analyse_code_expression c in 
      let nb, pop_taille_tq = analyse_code_bloc b in 
      let etiq = getEtiquette() in
      let etiq2 = getEtiquette() in 
      etiq^"\n"^nc^"JUMPIF (0) "^etiq2^"\n"^nb^"POP (0)"^(string_of_int pop_taille_tq)^"\n"^
      "JUMP "^etiq^"\n"^etiq2^"\n"             
  | Empty -> ""
  | Switch _ -> ""


  and analyse_code_bloc li = 
    let taille_variables_declarees i = 
    match i with
    | AstType.Declaration (_,info) -> 
      begin
        match info_ast_to_info info with
        | InfoVar(_,t,_,_) -> getTaille t
        | InfoFun(_,t,_) -> getTaille t
        | InfoConst(_,_) -> getTaille Int
        | InfoEnum(_,t) -> getTaille t
      end
    | _ -> 0
    in 
    let taille = List.fold_right (fun i ti -> (taille_variables_declarees i) + ti) li 0 in
    let _ = "POP (0) "^(string_of_int taille)^"\n" in (analyse_code_li li), taille

(* une liste d'instructions est un bloc donc on ignore la taille des variables locales *)
and analyse_code_li li = String.concat "" (List.map analyse_code_instruction li)

(* analyse_code_fonction : AstPlacement.fonction -> string *)
let analyse_code_fonction (Fonction(info, _, li, e)) = 
  match info_ast_to_info info with 
  | InfoFun(nom, t, list_types) ->  
      let anal_b,pop_bloc = analyse_code_bloc li in
      let anal_e = analyse_code_expression e in
      nom^"\n"^anal_b^anal_e^
      "POP ("^(string_of_int (getTaille t))^")"^(string_of_int pop_bloc)^
      "\nRETURN ("^(string_of_int (getTaille t))^")"^
      (string_of_int(List.fold_left (fun nb t -> (getTaille t) + nb) 0 list_types))^"\n"            
  | _ -> failwith ""

let analyser (Programme(fcts, prog)) = 
  let prog_i = getEntete() in 
  let ltf = List.map (analyse_code_fonction) fcts in 
  let rec aux liste =  
    match liste with
    | [] -> ""
    | t::q -> t^"\n"^(aux q)
  in 
  let prog_f = aux ltf in 
  let prog_b,blc_p = analyse_code_bloc prog in
  let s = prog_i^"LABEL "^prog_f^"main\n"^prog_b^"POP (0)"^(string_of_int blc_p)^"\n\nHALT" 
  in s

end
