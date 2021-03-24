
(* Module de la passe de gestion des identifiants *)
module PasseTypeRat : Passe.Passe with type t1 = Ast.AstTds.programme and type t2 = Ast.AstType.programme =
struct

open Tds
open Exceptions
open Ast
open AstType
open Type

type t1 = Ast.AstTds.programme
type t2 = Ast.AstType.programme

(* analyse_type_affectable : AstTds.affectable -> AstType.affectable *)
(* Paramètre e : l'affectable à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'affectable
en un affectable de type AstType.affectable *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_type_affectable a =
  match a with
  | AstTds.Ident infoast -> 
  begin
    match (info_ast_to_info infoast) with
    | InfoConst _ -> (Ident(infoast), Int)
    | InfoVar(_,t,_,_) -> (Ident(infoast), t)
    | _ -> failwith ("Internal error")
  end
  | AstTds.Valeur a1 -> 
  begin
    match (analyse_type_affectable a1) with
    | (na, Pointeur ta) -> (Valeur(na), ta)
    | _ -> raise(NotAPointer)
  end

(* analyse_type_enumeration : AstTds.Enumeration -> AstType.Enumeration *)
(* Paramètre : l'Enumeration à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'Enumeration
en une Enumeration de type AstType.Enumeration *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyse_type_enumeration (AstTds.Enumeration(n,li)) =
  let rec modifierTypeEnum l =
    match l with
    | [] -> []
    | info::q -> 
        (match (info_ast_to_info info) with
        | InfoEnum (nom,_) -> modifier_type_info (Enumere n) info; (info_to_info_ast(InfoEnum (nom,Enumere(n)))::modifierTypeEnum q)
        | _ -> failwith "Internal Error")
  in 
  let lim = modifierTypeEnum li in
  Enumeration(Enumere(n),lim)

(* choixfunction : Tds.info_ast list -> Tds.info_ast *)
(* Paramètre n : nom de la fonction *)
(* Paramètre l : liste des infos *)
(* Paramètre lp : liste des parametres *)
(* Trouver l'info qui verifie que ces liste de parametre *)
(* est compatible avec la liste entrée en parametre *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec choixfunction n l lp = 
  match l with
  | [] -> raise (TypesParametresInattendus ([],lp))
  | info::q -> 
  begin
    match (info_ast_to_info info) with
    | InfoFun (_,typeRet,typeParams) ->
        if (est_compatible_list typeParams lp) then (info,typeRet)
        else  (choixfunction n q lp)
    | _ -> failwith ("Internal error")
  end 

(* analyse_type_expression : AstTds.expression -> AstType.expression *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'expression
en une expression de type AstType.expression *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_type_expression e = 
  match e with
  | AstTds.AppelFonction (listeinfo,le) -> 
    let (nle,ltype) = List.split(List.map analyse_type_expression le) in
    begin
      match info_ast_to_info(List.hd listeinfo) with
      | InfoFun(n,_,_) -> 
          let (info,typeRet) = (choixfunction n listeinfo ltype) in
          (AppelFonction(info,nle), typeRet)
      | _ -> failwith "Error"
    end
      

  | AstTds.Rationnel (e1,e2) -> 
      let (ne1,t1) = analyse_type_expression e1
      and (ne2,t2) = analyse_type_expression e2 in 
      if est_compatible t1 Int then
          if est_compatible t2 Int then
              (Rationnel(ne1,ne2),Rat)
          else raise(TypeInattendu (t2, Int))
      else raise(TypeInattendu (t1, Int))

  | AstTds.Numerateur e1 -> 
      let (ne1,t1) = analyse_type_expression e1 in
      if est_compatible t1 Rat then
              (Numerateur (ne1), Int)
      else raise(TypeInattendu (t1, Rat))

  | AstTds.Denominateur e1 -> 
      let (ne1,t1) = analyse_type_expression e1 in
      if est_compatible t1 Rat then
              (Denominateur (ne1), Int)
      else raise(TypeInattendu (t1, Rat))

  | AstTds.Affectable a ->
      let (na,ta) = analyse_type_affectable a in
      (Affectable(na),ta)

  | AstTds.Binaire (b,e1,e2) ->   
      let (ne1,t1) = analyse_type_expression e1 in
      let (ne2,t2) = analyse_type_expression e2 in 
      begin 
          match b with
          | Plus -> 
              if (est_compatible t1 Int) && (est_compatible t2 Int) then (Binaire(PlusInt,ne1,ne2),Int)
              else if (est_compatible t1 Rat) && (est_compatible t2 Rat) then (Binaire(PlusRat,ne1,ne2),Rat)
              else raise(TypeBinaireInattendu(b,t1,t2))

          | Mult -> 
              if (est_compatible t1 Int) && (est_compatible t2 Int) then
                  (Binaire(MultInt,ne1,ne2),Int)
              else if (est_compatible t1 Rat) && (est_compatible t2 Rat) then
                  (Binaire(MultRat,ne1,ne2),Rat)
              else raise(TypeBinaireInattendu(b,t1,t2))

          | Equ -> 
              if (est_compatible t1 t2) then 
                  (match (t1,t2) with
                  | (Int,Int) ->  (Binaire(EquInt,ne1,ne2),Bool)
                  | (Bool,Bool) -> (Binaire(EquBool,ne1,ne2),Bool)
                  | (Enumere _, Enumere _) -> (Binaire(EquEnum,ne1,ne2),Bool)
                  | _ -> raise(TypeBinaireInattendu(b,t1,t2)) )
              else raise(TypeBinaireInattendu(b,t1,t2))

          | Inf -> 
              if (est_compatible t1 Int) && (est_compatible t2 Int) then
                  (Binaire(Inf,ne1,ne2),Bool)
              else raise(TypeBinaireInattendu(b,t1,t2))
      end
  | AstTds.ValEnum infoast -> 
      begin
        match (info_ast_to_info infoast) with
        | InfoEnum(_,t) -> ((ValEnum infoast), t)
        | _ -> failwith ("Internal error")
      end
  | AstTds.True -> (True, Bool)
  | AstTds.False -> (False, Bool)
  | AstTds.Entier i -> (Entier i, Int)
  | AstTds.Null -> (Null, Pointeur Undefined)
  | AstTds.New t -> (New(t),Pointeur t)
  | AstTds.Adresse infoast -> 
      begin
        match (info_ast_to_info infoast) with
        | InfoVar(_,t,_,_) -> (Adresse(infoast), Pointeur t)
        | _ -> failwith ("Internal error")
      end



(* analyse_type_instruction : AstTds.instruction -> AstType.instruction *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'instruction
en une instruction de type AstType.instruction *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_type_instruction i =
  match i with
  | AstTds.Declaration (t, e, info) ->
      let (ne,te) = analyse_type_expression e in
      modifier_type_info t info;
      if est_compatible t te then
          Declaration(ne,info)
      else raise(TypeInattendu(te,t))

  | AstTds.Affectation (a,e) ->
      let (na,ta) = analyse_type_affectable a in
      let (ne,te) = analyse_type_expression e in
      if est_compatible ta te then
          Affectation (na,ne)
      else raise(TypeInattendu (te, ta))
  
  | AstTds.Affichage e -> 
      let (ne,te) = analyse_type_expression e in
      begin
        match te with
        | Int -> AffichageInt(ne)
        | Rat -> AffichageRat(ne)
        | Bool -> AffichageBool(ne)
        | Enumere _ -> AffichageEnum(ne)
        | _ -> failwith ("Internal error : Type not found")
      end

  | AstTds.Conditionnelle (c,t,e) -> 
      let (nc,tc) = analyse_type_expression c in
      if est_compatible Bool tc then
          let nt = analyse_type_bloc t in
          let ne = analyse_type_bloc e in
          Conditionnelle (nc,nt,ne)
      else
          raise(TypeInattendu(tc,Bool))

  | AstTds.TantQue (c,b) -> 
      let (nc,tc) = analyse_type_expression c in
      if est_compatible Bool tc then
          let nb = analyse_type_bloc b in
          TantQue (nc,nb)
      else
          raise(TypeInattendu(tc,Bool))

  | AstTds.Empty -> Empty
  | AstTds.Switch(e,lc) ->
      let (ne,te) = analyse_type_expression e in
      let rec analyse_liste_case l = 
          begin 
            match l with
            | [] -> []
            | (AstTds.Default(li,b))::q -> (Default((analyse_type_bloc li),b))::(analyse_liste_case q)
            | (AstTds.Case(t,li,b))::q -> 
            begin
                match t with
                | TEnum(info) -> 
                begin
                  match info_ast_to_info info with
                  | InfoEnum(_,ten) -> 
                      if (est_compatible ten te) then 
                          (Case((TEnum(info)),(analyse_type_bloc li),b))::(analyse_liste_case q)
                      else raise (TypeInattendu(te,ten))
                  | _ -> failwith "Internal Error"
                end                   
                | TEntier n -> 
                    if (est_compatible Int te) then 
                        (Case((TEntier n),(analyse_type_bloc li),b))::(analyse_liste_case q)
                    else raise (TypeInattendu(te,Int))
                | TTrue -> 
                    if (est_compatible Bool te) then 
                        (Case(TTrue,(analyse_type_bloc li),b))::(analyse_liste_case q)
                    else raise (TypeInattendu(te,Bool))
                | TFalse -> 
                    if (est_compatible Bool te) then 
                        (Case(TFalse,(analyse_type_bloc li),b))::(analyse_liste_case q)
                    else raise (TypeInattendu(te,Bool))
              end
          end
                                          
      in Switch(ne,(analyse_liste_case lc))


and analyse_type_bloc li = List.map analyse_type_instruction li 


(* analyse_type_fonction : AstTds.fonction -> AstType.fonction *)
(* Paramètre : la fonction à analyser *)
(* Vérifie la bonne utilisation des types et tranforme la fonction
en une fonction de type AstType.fonction *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyse_type_fonction (AstTds.Fonction(t,n,lp,li,e))  =
    let list_type_arg = List.map (fun (a,_) -> a) lp in
    let list_arg = List.map (fun (_,a) -> a) lp in
    modifier_type_fonction_info t list_type_arg n;
    let inst = analyse_type_bloc li in
    let (ne,te) = analyse_type_expression e in
    if est_compatible t te then
        begin
        match (info_ast_to_info n) with
        | InfoFun(_,_,_) -> Fonction (n, list_arg, inst, ne)
        | _ -> failwith ("Internal error : symbol not found")
        end
    else raise(TypeInattendu(te,t))

(* analyser : AstTds.ast -> AstType.ast *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des types et tranforme le programme
en un programme de type AstType.ast *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyser (AstTds.Programme (enume,fonctions,prog)) =
    let _ = List.map analyse_type_enumeration enume in
    let nf = List.map analyse_type_fonction fonctions in 
    let nb = analyse_type_bloc prog in
    Programme(nf,nb)

end