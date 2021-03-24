open Type

(* Interface des arbres abstraits *)
module type Ast =
sig
   type expression
   type instruction
   type fonction
   type programme
end

(* Interface d'affichage des arbres abstraits *)
module type PrinterAst =
sig
  module A:Ast

(* string_of_expression :  expression -> string *)
(* transforme une expression en chaîne de caractère *)
val string_of_expression : A.expression -> string

(* string_of_instruction :  instruction -> string *)
(* transforme une instruction en chaîne de caractère *)
val string_of_instruction : A.instruction -> string

(* string_of_fonction :  fonction -> string *)
(* transforme une fonction en chaîne de caractère *)
val string_of_fonction : A.fonction -> string

(* string_of_ast :  ast -> string *)
(* transforme un ast en chaîne de caractère *)
val string_of_programme : A.programme -> string

(* print_ast :  ast -> unit *)
(* affiche un ast *)
val print_programme : A.programme -> unit

end


(* *************************************** *)
(* AST après la phase d'analyse syntaxique *)
(* *************************************** *)
module AstSyntax =
struct

(* Opérateurs binaires de Rat *)
type binaire = Plus | Mult | Equ | Inf

type typecase = TEnum of string | TEntier of int | TTrue | TFalse

(* Definition du type affectable qui peut etre soit un identifiant ou la valeur d'une autre valeur *)
type affectable = 
  | Ident of string
  | Valeur of affectable

(* Definition du type enumere ou on trouve le nom du type et la liste des ids *)
type enum = Enumeration of string * string list



(* Expressions de Rat *)
type expression =
  (* Appel de fonction représenté par le nom de la fonction et la liste des paramètres réels *)
  | AppelFonction of string * expression list 
  (* Rationnel représenté par le numérateur et le dénominateur *)
  | Rationnel of expression * expression 
  (* Accès au numérateur d'un rationnel *)
  | Numerateur of expression
  (* Accès au dénominateur d'un rationnel *)
  | Denominateur of expression
  (* Accès à un affectable *)
  | Affectable of affectable
  (* Booléen vrai *)
  | True
  (* Booléen faux *)
  | False
  (* Entier *)
  | Entier of int
  (* Opération binaire représentée par l'opérateur, l'opérande gauche et l'opérande droite *)
  | Binaire of binaire * expression * expression
  (* Definition d'un nouveau type pointeur *)
  | New of typ
  (* Adresse *)
  | Adresse of string
  (* Null *)
  | Null
  (* Valeur de type Enumere *)
  | ValEnum of string

(* Instructions de Rat *)
type bloc = instruction list
and instruction =
  (* Déclaration de variable représentée par son type, son nom et l'expression d'initialisation *)
  | Declaration of typ * string * expression
  (* Affectation d'une variable représentée par son nom et la nouvelle valeur affectée *)
  | Affectation of affectable * expression
  (* Déclaration d'une constante représentée par son nom et sa valeur (entier) *)
  | Constante of string * int
  (* Affichage d'une expression *)
  | Affichage of expression
  (* Conditionnelle représentée par la condition, le bloc then et le bloc else *)
  | Conditionnelle of expression * bloc * bloc
  (* Boucle TantQue représentée par la condition d'arrêt de la boucle et le bloc d'instructions *)
  | TantQue of expression * bloc
  (* Structure de controle Switch/Case representée par une expression liste des cas de test et les instructions à faire *)
  | Switch of expression * case list

(* Definition des cas correspondant à case *)
and case = 
  | Case of typecase * instruction list * bool
  | Default of instruction list * bool

(* Structure des fonctions de Rat *)
(* type de retour - nom - liste des paramètres (association type et nom) - corps de la fonction - expression de retour *)
type fonction = Fonction of typ * string * (typ * string) list * instruction list * expression

(* Structure d'un programme Rat *)
(* liste de fonction - programme principal *)
type programme = Programme of enum list * fonction list * bloc

end


(*Module d'affiche des AST issus de la phase d'analyse syntaxique *)
module PrinterAstSyntax : PrinterAst with module A = AstSyntax =
struct

  module A = AstSyntax
  open A

  (* Conversion des opérateurs binaires *)
  let string_of_binaire b =
    match b with
    | Plus -> "+ "
    | Mult -> "* "
    | Equ -> "= "
    | Inf -> "< "


  let rec string_of_affectable a =
    match a with
    | Ident n -> n^" "
    | Valeur a2 -> "*"^(string_of_affectable a2)^" "

  let string_of_enumere nom liste =
    let rec ajouter l =
      match l with
      | [] -> "]"
      | t::q -> ", "^t^(ajouter q)
    in
    "Enum "^nom^": ["^(List.hd liste)^(ajouter (List.tl liste))

  (* Conversion des expressions *)
  let rec string_of_expression e =
    match e with
    | AppelFonction (n,le) -> "call "^n^"("^((List.fold_right (fun i tq -> (string_of_expression i)^tq) le ""))^") "
    | Rationnel (e1,e2) -> "["^(string_of_expression e1)^"/"^(string_of_expression e2)^"] "
    | Numerateur e1 -> "num "^(string_of_expression e1)^" "
    | Denominateur e1 ->  "denom "^(string_of_expression e1)^" "
    | Affectable a -> "Affec "^(string_of_affectable a)^" "
    | Null -> "null "
    | New t -> "(new "^(string_of_type t)^") "
    | Adresse n -> "&"^n^" "
    | True -> "true "
    | False -> "false "
    | Entier i -> (string_of_int i)^" "
    | Binaire (b,e1,e2) -> (string_of_expression e1)^(string_of_binaire b)^(string_of_expression e2)^" "
    | ValEnum v -> "Enum : "^v


  (* Conversion des instructions *)
  let rec string_of_instruction i =
    match i with
    | Declaration (t, n, e) -> "Declaration  : "^(string_of_type t)^" "^n^" = "^(string_of_expression e)^"\n"
    | Affectation (a,e) ->  "Affectation  : "^(string_of_affectable a)^" = "^(string_of_expression e)^"\n"
    | Constante (n,i) ->  "Constante  : "^n^" = "^(string_of_int i)^"\n"
    | Affichage e ->  "Affichage  : "^(string_of_expression e)^"\n"
    | Conditionnelle (c,t,e) ->  "Conditionnelle  : IF "^(string_of_expression c)^"\n"^
                                  "THEN \n"^((List.fold_right (fun i tq -> (string_of_instruction i)^tq) t ""))^
                                  "ELSE \n"^((List.fold_right (fun i tq -> (string_of_instruction i)^tq) e ""))^"\n"
    | TantQue (c,b) -> "TantQue  : TQ "^(string_of_expression c)^"\n"^
                                  "FAIRE \n"^((List.fold_right (fun i tq -> (string_of_instruction i)^tq) b ""))^"\n"
    | Switch (e, lc) -> "Switch : SWITCH ("^(string_of_expression e)^") {"^string_of_list_case lc

and string_of_list_case lc =
  match lc with 
  | [] -> ""
  | (Case(t,li,b))::q ->  
        let cas = (match t with
            | TEnum n -> n
            | TEntier n -> string_of_int n
            | TTrue -> "True"
            | TFalse -> "False")
        in "Case "^cas^" : "^((List.fold_right (fun i tq -> (string_of_instruction i)^tq) li ""))^(if b then "Break" else "")^"\n"^(string_of_list_case q)
  | (Default(li,b))::q -> "Default : "^((List.fold_right (fun i tq -> (string_of_instruction i)^tq) li ""))^(if b then "Break" else "")^"\n"^(string_of_list_case q)

                    
  
  (* Conversion des fonctions *)
  let string_of_fonction (Fonction(t,n,lp,li,e)) = (string_of_type t)^" "^n^" ("^((List.fold_right (fun (t,n) tq -> (string_of_type t)^" "^n^" "^tq) lp ""))^") = \n"^
                                        ((List.fold_right (fun i tq -> (string_of_instruction i)^tq) li ""))^
                                        "Return "^(string_of_expression e)^"\n"

  (* Conversion d'un programme Rat *)
  let string_of_programme (Programme (enumere, fonctions, instruction)) =
    (List.fold_right (fun en tq -> let Enumeration(nom,valeur) = en in (string_of_enumere nom valeur)^tq) enumere "")^
    (List.fold_right (fun f tq -> (string_of_fonction f)^tq) fonctions "")^
    (List.fold_right (fun i tq -> (string_of_instruction i)^tq) instruction "")

  (* Affichage d'un programme Rat *)
  let print_programme programme =
    print_string "AST : \n";
    print_string (string_of_programme programme);
    flush_all ()

end

(* ********************************************* *)
(* AST après la phase d'analyse des identifiants *)
(* ********************************************* *)
module AstTds =
struct

  type affectable =
    | Ident of Tds.info_ast 
    | Valeur of affectable

  type typecase = TEnum of Tds.info_ast | TEntier of int | TTrue | TFalse
  
  type enumere = Enumeration of string * (Tds.info_ast )list

  (* Expressions existantes dans notre langage *)
  (* ~ expression de l'AST syntaxique où les noms des identifiants ont été 
  remplacés par les informations associées aux identificateurs *)
  type expression =
    | AppelFonction of (Tds.info_ast list) * expression list
    | Rationnel of expression * expression
    | Numerateur of expression
    | Denominateur of expression
    | Affectable of affectable (* le nom de l'identifiant est remplacé par ses informations *)
    | True
    | False
    | Entier of int
    | Binaire of AstSyntax.binaire * expression * expression
    | Null
    | New of typ
    | Adresse of Tds.info_ast
    | ValEnum of Tds.info_ast

  (* instructions existantes dans notre langage *)
  (* ~ instruction de l'AST syntaxique où les noms des identifiants ont été 
  remplacés par les informations associées aux identificateurs 
  + suppression de nœuds (const) *)
  type bloc = instruction list
  and instruction =
    | Declaration of typ * expression * Tds.info_ast (* le nom de l'identifiant est remplacé par ses informations *)
    | Affectation of affectable * expression (* le nom de l'identifiant est remplacé par ses informations *)
    | Affichage of expression
    | Conditionnelle of expression * bloc * bloc
    | TantQue of expression * bloc
    | Empty (* les nœuds ayant disparus: Const *)
    | Switch of expression * case list

and case = 
  | Case of typecase * instruction list * bool 
  | Default of instruction list * bool


  (* Structure des fonctions dans notre langage *)
  (* type de retour - informations associées à l'identificateur (dont son nom) - liste des paramètres (association type et information sur les paramètres) - corps de la fonction - expression de retour *)
  type fonction = Fonction of typ * Tds.info_ast * (typ * Tds.info_ast ) list * instruction list * expression 

  (* Structure d'un programme dans notre langage *)
  type programme = Programme of enumere list * fonction list * bloc

end
    

(* ******************************* *)
(* AST après la phase de typage *)
(* ******************************* *)
module AstType =
struct

type typecase = TEnum of Tds.info_ast | TEntier of int | TTrue | TFalse

(* Opérateurs binaires existants dans Rat - résolution de la surcharge *)
type binaire = PlusInt | PlusRat | MultInt | MultRat | EquInt | EquBool | EquEnum | Inf

type affectable =
  | Ident of Tds.info_ast 
  | Valeur of affectable

type enumere = Enumeration of typ * (Tds.info_ast )list

(* Expressions existantes dans Rat *)
(* = expression de AstTds *)
type expression =
  | AppelFonction of Tds.info_ast * expression list
  | Rationnel of expression * expression
  | Numerateur of expression
  | Denominateur of expression
  | Affectable of affectable
  | True
  | False
  | Entier of int
  | Binaire of binaire * expression * expression
  | Null
  | New of typ
  | Adresse of Tds.info_ast
  | ValEnum of Tds.info_ast

(* instructions existantes Rat *)
(* = instruction de AstTds + informations associées aux identificateurs, mises à jour *)
(* + résolution de la surcharge de l'affichage *)
type bloc = instruction list
 and instruction =
  | Declaration of expression * Tds.info_ast
  | Affectation of affectable * expression
  | AffichageInt of expression
  | AffichageRat of expression
  | AffichageBool of expression
  | AffichageEnum of expression
  | Conditionnelle of expression * bloc * bloc
  | TantQue of expression * bloc
  | Empty (* les nœuds ayant disparus: Const *)
  | Switch of expression * case list

and case = 
  | Case of typecase * bloc * bool 
  | Default of instruction list * bool

(* informations associées à l'identificateur (dont son nom), liste des paramètres, corps, expression de retour *)
type fonction = Fonction of Tds.info_ast * Tds.info_ast list * instruction list * expression 

(* Structure d'un programme dans notre langage *)
type programme = Programme of fonction list * bloc

let taille_variables_declarees i = 
  match i with
  | Declaration (_,info) -> 
    begin
    match Tds.info_ast_to_info info with
    | InfoVar (_,t,_,_) -> getTaille t
    | _ -> failwith "internal error"
    end
  | _ -> 0 ;;

end

(* ******************************* *)
(* AST après la phase de placement *)
(* ******************************* *)
module AstPlacement =
struct

(* Expressions existantes dans notre langage *)
(* = expression de AstType  *)
type expression = AstType.expression

(* instructions existantes dans notre langage *)
(* = instructions de AstType  *)
type bloc = instruction list
 and instruction = AstType.instruction

(* informations associées à l'identificateur (dont son nom), liste de paramètres, corps, expression de retour *)
(* Plus besoin de la liste des paramètres mais on la garde pour les tests du placements mémoire *)
type fonction = Fonction of Tds.info_ast * Tds.info_ast list * instruction list * expression

(* Structure d'un programme dans notre langage *)
type programme = Programme of fonction list * bloc

end


