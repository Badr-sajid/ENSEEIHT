
(* Module de la passe de gestion des identifiants *)
module PasseTdsRat : Passe.Passe with type t1 = Ast.AstSyntax.programme and type t2 = Ast.AstTds.programme =
struct

  open Tds
  open Type
  open Exceptions
  open Ast
  open AstTds

  type t1 = Ast.AstSyntax.programme
  type t2 = Ast.AstTds.programme



(* analyse_tds_affectable : AstSyntax.affectable -> AstTds.affectable *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre a : l'affectable à analyser *)
(* Paramètre modif : booléen qui indique si l’affectable est modifié *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'affectable
en un affectable de type AstTds.affectable *)
(* Erreur si mauvaise utilisation des identifiants *)
(* Erreur si l'identifiant est non Déclaré *)
let rec analyse_tds_affectable tds a modif =
  match a with
  | AstSyntax.Ident n -> 
  begin 
    match (chercherGlobalement tds n) with
    | Some infoast ->
    begin
      match (info_ast_to_info infoast) with
      | InfoVar _ -> Ident infoast
      | InfoConst _ -> if modif then raise(MauvaiseUtilisationIdentifiant n) else Ident infoast
      | InfoFun _ | InfoEnum _ -> raise(MauvaiseUtilisationIdentifiant n)
    end
    | None -> raise (IdentifiantNonDeclare n)
  end
  | AstSyntax.Valeur a2 -> Valeur(analyse_tds_affectable tds a2 modif)

(* analyse_tds_enumeration : AstSyntax.Enumeration -> AstTds.Enumeration *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre : l'Enumeration à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'Enumeration
en une Enumeration de type AstTds.affectable *)
(* Erreur si l'identifiant est Déclaré deux fois*)
let analyse_tds_enumeration tds (AstSyntax.Enumeration(n,lv)) = 
  let rec ajouterenum l =
    match l with
    | [] -> []
    | t::q -> 
    begin
      match (chercherGlobalement tds t) with
      | Some _ -> raise (DoubleDeclaration t)
      | None -> 
          let info = InfoEnum (t,Undefined) in
          let ia = info_to_info_ast info in
          ajouter tds t ia; ia::(ajouterenum q)
    end
  in Enumeration(n,(ajouterenum lv))


(* test_type_info_InfoFun : Tds.info_ast -> Tds.info_ast *)
(* Paramètre n : nom associé à l'info *)
(* Paramètre info : l'info à tester *)
(* Vérifie que l'info est bien une InfoFun et retourner cette info *)
(* Erreur si mauvaise utilisation des identifiants *)
let test_type_info_InfoFun n info = 
  match (info_ast_to_info info) with
    | InfoFun (_,_,_) -> info
    | _ -> raise(MauvaiseUtilisationIdentifiant n)

(* analyse_tds_expression : AstSyntax.expression -> AstTds.expression *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'expression
en une expression de type AstTds.expression *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_expression tds e = 
  match e with
  | AstSyntax.AppelFonction (id,le) ->
  begin 
    match (chercherGlobalementFunction tds id) with
    | [] -> raise (IdentifiantNonDeclare id)
    | liste ->  
        let l = List.map (fun info -> test_type_info_InfoFun id info) liste in
        let ne = List.map(analyse_tds_expression tds) le in
        AppelFonction(l,ne)
  end
  | AstSyntax.Affectable a -> Affectable(analyse_tds_affectable tds a false)
  | AstSyntax.Null -> Null
  | AstSyntax.New t -> New t
  | AstSyntax.Adresse n ->
  begin
    match (chercherGlobalement tds n) with
    | None -> raise(IdentifiantNonDeclare n)
    | Some infoast ->
    begin
      match (info_ast_to_info infoast) with
      | InfoVar _ -> Adresse infoast
      | _ -> raise(MauvaiseUtilisationIdentifiant n)
    end
  end
  | ValEnum n ->
  begin
    match (chercherGlobalement tds n) with
    | None -> raise(IdentifiantNonDeclare n)
    | Some infoast ->
    begin
      match (info_ast_to_info infoast) with
      | InfoEnum _ -> ValEnum infoast
      | _ -> raise(MauvaiseUtilisationIdentifiant n)
    end
  end
  | AstSyntax.Rationnel (e1,e2) -> Rationnel(analyse_tds_expression tds e1, analyse_tds_expression tds e2)
  | AstSyntax.Numerateur e1 -> Numerateur (analyse_tds_expression tds e1)
  | AstSyntax.Denominateur e1 -> Denominateur (analyse_tds_expression tds e1)
  | AstSyntax.True -> True
  | AstSyntax.False -> False
  | AstSyntax.Entier i -> Entier i
  | AstSyntax.Binaire (b,e1,e2) -> 
  begin 
    match b with
    | Plus -> Binaire (Plus, analyse_tds_expression tds e1, analyse_tds_expression tds e2)
    | Mult -> Binaire (Mult, analyse_tds_expression tds e1, analyse_tds_expression tds e2)
    | Equ -> Binaire (Equ, analyse_tds_expression tds e1, analyse_tds_expression tds e2)
    | Inf -> Binaire (Inf, analyse_tds_expression tds e1, analyse_tds_expression tds e2)
  end


(* analyse_tds_instruction : AstSyntax.instruction -> tds -> AstTds.instruction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'instruction
en une instruction de type AstTds.instruction *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_instruction tds i =
  match i with
  | AstSyntax.Declaration (t, n, e) ->
  begin
    match chercherLocalement tds n with
    | None ->
        (* L'identifiant n'est pas trouvé dans la tds locale, 
        il n'a donc pas été déclaré dans le bloc courant *)
        (* Vérification de la bonne utilisation des identifiants dans l'expression *)
        (* et obtention de l'expression transformée *) 
        let ne = analyse_tds_expression tds e in
        (* Création de l'information associée à l'identfiant *)
        let info = InfoVar (n,Undefined, 0, "") in
        (* Création du pointeur sur l'information *)
        let ia = info_to_info_ast info in
        (* Ajout de l'information (pointeur) dans la tds *)
        ajouter tds n ia;
        (* Renvoie de la nouvelle déclaration où le nom a été remplacé par l'information 
        et l'expression remplacée par l'expression issue de l'analyse *)
        (* print_string((string_of_type t)^" : "^n^"\n"); *)
        Declaration (t, ne, ia)          
    | Some _ ->
        (* L'identifiant est trouvé dans la tds locale, 
        il a donc déjà été déclaré dans le bloc courant *) 
        raise (DoubleDeclaration n)
  end
  | AstSyntax.Affectation (a,e) ->
      let na = analyse_tds_affectable tds a true in
      let ne = analyse_tds_expression tds e in
      Affectation (na,ne)
  | AstSyntax.Constante (n,v) -> 
      begin
        match chercherLocalement tds n with
        | None -> 
        (* L'identifiant n'est pas trouvé dans la tds locale, 
        il n'a donc pas été déclaré dans le bloc courant *)
        (* Ajout dans la tds de la constante *)
        ajouter tds n (info_to_info_ast (InfoConst (n,v))); 
        (* Suppression du noeud de déclaration des constantes devenu inutile *)
        Empty
        | Some _ ->
          (* L'identifiant est trouvé dans la tds locale, 
          il a donc déjà été déclaré dans le bloc courant *) 
          raise (DoubleDeclaration n)
      end
  | AstSyntax.Affichage e -> 
      (* Vérification de la bonne utilisation des identifiants dans l'expression *)
      (* et obtention de l'expression transformée *)
      let ne = analyse_tds_expression tds e in
      (* Renvoie du nouvel affichage où l'expression remplacée par l'expression issue de l'analyse *)
      Affichage (ne)
  | AstSyntax.Conditionnelle (c,t,e) -> 
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds c in
      (* Analyse du bloc then *)
      let tast = analyse_tds_bloc tds t in
      (* Analyse du bloc else *)
      let east = analyse_tds_bloc tds e in
      (* Renvoie la nouvelle structure de la conditionnelle *)
      Conditionnelle (nc, tast, east)
  | AstSyntax.TantQue (c,b) -> 
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds c in
      (* Analyse du bloc *)
      let bast = analyse_tds_bloc tds b in
      (* Renvoie la nouvelle structure de la boucle *)
      TantQue (nc, bast)
  | AstSyntax.Switch (e,cl) ->
    let ne = analyse_tds_expression tds e in
    let rec analyse_list_case l = 
      (match l with
      | [] -> []
      | (AstSyntax.Case(t,li,b))::q -> 
            (match t with
            | AstSyntax.TEnum(n) -> 
                (match (chercherGlobalement tds n) with 
                | None -> raise (IdentifiantNonDeclare n)
                | Some info -> (Case(TEnum(info),(analyse_tds_bloc tds li),b))::(analyse_list_case q))
            | AstSyntax.TEntier n -> (Case((TEntier n),(analyse_tds_bloc tds li),b))::(analyse_list_case q)
            | AstSyntax.TTrue -> (Case(TTrue,(analyse_tds_bloc tds li),b))::(analyse_list_case q)
            | AstSyntax.TFalse -> (Case(TFalse,(analyse_tds_bloc tds li),b))::(analyse_list_case q))
      | (AstSyntax.Default(li,b))::q -> (Default((analyse_tds_bloc tds li),b))::(analyse_list_case q))
    in Switch (ne,analyse_list_case cl)

      
(* analyse_tds_bloc : AstSyntax.bloc -> AstTds.bloc *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le bloc
en un bloc de type AstTds.bloc *)
(* Erreur si mauvaise utilisation des identifiants *)
and analyse_tds_bloc tds li =
  (* Entrée dans un nouveau bloc, donc création d'une nouvelle tds locale 
  pointant sur la table du bloc parent *)
  let tdsbloc = creerTDSFille tds in
  (* Analyse des instructions du bloc avec la tds du nouveau bloc 
  Cette tds est modifiée par effet de bord *)
   let nli = List.map (analyse_tds_instruction tdsbloc) li in
   (* afficher_locale tdsbloc ; *) (* décommenter pour afficher la table locale *)
   nli


(* definitionfunction : AstSyntax.fonction -> AstTds.fonction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre : la fonction à transformer *)
(* fonction auxilière qui tranforme la fonction en une fonction *)
(* de type AstTds.fonction sans verifier l'utilisation*)
let definitionfunction maintds (AstSyntax.Fonction(t,n,lp,li,e)) = 
  let tds = creerTDSFille maintds in
  let aux tds (t,s) =
  begin
    match chercherLocalement tds s with
    | Some _ -> raise (DoubleDeclaration s)
    | None -> let lia = info_to_info_ast (InfoVar(s,t, 0, "")) 
              in ajouter tds s lia;
              (t,lia)
  end
  in
  let list_arg = List.map (aux tds)lp in
  let ltp = List.map (fun (a,_) -> a) lp in
  let ia = info_to_info_ast (InfoFun(n,Undefined, ltp)) in ajouter maintds n ia;
  let blc = List.map (analyse_tds_instruction tds) li in
  let ret = analyse_tds_expression tds e in
  Fonction(t, ia, list_arg, blc,ret)

(* analyse_tds_fonction : AstSyntax.fonction -> AstTds.fonction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre : la fonction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme la fonction
en une fonction de type AstTds.fonction *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyse_tds_fonction maintds (AstSyntax.Fonction(t,n,lp,li,e))  =
  match (chercherLocalement maintds n) with
  | None -> definitionfunction maintds (AstSyntax.Fonction(t,n,lp,li,e))
  | Some infoast -> 
  begin 
    match (info_ast_to_info infoast) with
    | InfoFun (_,_,tl) -> 
        let ltp = List.map (fun (a,_) -> a) lp in
        if (est_compatible_list ltp tl)
        then raise (DoubleDeclaration n)
        else definitionfunction maintds (AstSyntax.Fonction(t,n,lp,li,e))
    | _ -> raise(MauvaiseUtilisationIdentifiant n)
  end


(* analyser : AstSyntax.ast -> AstTds.ast *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le programme
en un programme de type AstTds.ast *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyser (AstSyntax.Programme (enume,fonctions,prog)) =
  let tds = creerTDSMere () in
  let ne = List.map (analyse_tds_enumeration tds) enume in
  let nf = List.map (analyse_tds_fonction tds) fonctions in 
  let nb = analyse_tds_bloc tds prog in
  Programme (ne,nf,nb)

end
