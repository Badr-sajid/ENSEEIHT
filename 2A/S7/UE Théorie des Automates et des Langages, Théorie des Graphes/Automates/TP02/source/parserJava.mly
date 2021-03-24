%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

(* let nbrVariables = ref 0;; *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token IMPORT
%token <string> IDENT TYPEIDENT
%token INT FLOAT BOOL CHAR VOID STRING
%token ACCOUV ACCFER PAROUV PARFER CROOUV CROFER
%token PTVIRG VIRG
%token SI SINON TANTQUE RETOUR
/* Defini le type des donnees associees a l'unite lexicale */
%token <int> ENTIER
%token <float> FLOTTANT
%token <bool> BOOLEEN
%token <char> CARACTERE
%token <string> CHAINE
%token VIDE
%token NOUVEAU
%token ASSIGN
%token OPINF OPSUP OPINFEG OPSUPEG OPEG OPNONEG
%token OPPLUS OPMOINS OPOU
%token OPMULT OPMOD OPDIV OPET
%token OPNON
%token OPPT
/* Unite lexicale particuliere qui represente la fin du fichier */
%token FIN

/* Declarations des regles d'associative et de priorite pour les operateurs */
/* La priorite est croissante de haut en bas */
/* Associatif a droite */
%right ASSIGN /* Priorite la plus faible */
/* Non associatif */
%nonassoc OPINF OPSUP OPINFEG OPSUPEG OPEG OPNONEG
/* Associatif a gauche */
%left OPPLUS OPMOINS OPOU
%left OPMULT OPMOD OPDIV OPET
%right OPNON
%left OPPT PAROUV CROOUV /* Priorite la plus forte */

/* Type renvoye pour le nom terminal fichier */
%type <unit> fichier
%type <int> variables

/* Le non terminal fichier est l'axiome */
%start fichier

%% /* Regles de productions */

fichier : programme FIN { (print_endline "fichier : programme FIN") }

programme : /* Lambda, mot vide */ { (print_endline "programme : /* Lambda, mot vide */") }
          | fonction programme { (print_endline "programme : fonction programme") }

typeStruct : typeBase declTab { (print_endline "typeStruct : typeBase declTab") }

typeBase : INT { (print_endline "typeBase : INT") }
         | FLOAT { (print_endline "typeBase : FLOAT") }
         | BOOL { (print_endline "typeBase : BOOL") }
         | CHAR { (print_endline "typeBase : CHAR") }
         | STRING { (print_endline "typeBase : STRING") }
         | TYPEIDENT { (print_endline "typeBase : TYPEIDENT") }

declTab : /* Lambda, mot vide */ { (print_endline "declTab : /* Lambda, mot vide */") }
        | CROOUV CROFER { (print_endline "declTab : CROOUV CROFER") }

fonction : entete bloc  { (print_endline "fonction : entete bloc") }

entete : typeStruct IDENT PAROUV parsFormels PARFER { (print_endline "entete : typeStruct IDENT PAROUV parsFormels PARFER") }
       | VOID IDENT PAROUV parsFormels PARFER { (print_endline "entete : VOID IDENT PAROUV parsFormels PARFER") }

parsFormels : /* Lambda, mot vide */ { (print_endline "parsFormels : /* Lambda, mot vide */") }
            | typeStruct IDENT suiteParsFormels { (print_endline "parsFormels : typeStruct IDENT suiteParsFormels") }

suiteParsFormels : /* Lambda, mot vide */ { (print_endline "suiteParsFormels : /* Lambda, mot vide */") }
                 | VIRG typeStruct IDENT suiteParsFormels { (print_endline "suiteParsFormels : VIRG typeStruct IDENT suiteParsFormels") }

bloc : ACCOUV variables instructions ACCFER { (print_endline "bloc : ACCOUV variables instructions ACCFER"); (print_string "Nombre de variables = "); (print_int $2); (print_newline ()) }

variables : /* Lambda, mot vide */ { (print_endline "variables : /* Lambda, mot vide */"); 0 }
          | variable variables { (print_endline "variables : variable variables"); ($2 + 1) }

variable : typeStruct IDENT PTVIRG { (print_endline "variable : typeStruct IDENT PTVIRG") }

/* A FAIRE : Completer pour decrire une liste d'instructions eventuellement vide */
instructions : /* Lambda, mot vide */ { (print_endline "instructions : /* Lambda, mot vide */") }
           | instruction instructions { (print_endline "instructions : instruction instructions") }

/* A FAIRE : Completer pour ajouter les autres formes d'instructions */
instruction : expression PTVIRG { (print_endline "instruction : expression PTVIRG") }
           | SI PAROUV expression PARFER bloc { (print_endline "instruction : SI PAROUV expression PARFER bloc") }
           | SI PAROUV expression PARFER bloc SINON bloc{ (print_endline "instruction : SI PAROUV expression PARFER bloc SINON bloc") }
           | TANTQUE PAROUV expression PARFER bloc { (print_endline "instruction : TANTQUE PAROUV expression PARFER bloc") }
           | RETOUR expression PTVIRG  { (print_endline "instruction : RETURN expression PTVIRG") }

/* A FAIRE : Completer pour ajouter les autres formes d'expressions */
expression : unaires partieexpression { (print_endline "expression : unaires partieexpression") }
	   | unaires partieexpression binaire expression { (print_endline "expression : unaires partieexpression binaire expression") }

unaire : PAROUV typeBase PARFER { (print_endline "unaire : PAROUV typeBase PARFER") }
	   | OPPLUS { (print_endline "unaire : OPPLUS") }
           | OPMOINS { (print_endline "unaire : OPMOINS") }
           | OPNON { (print_endline "unaire : OPNON") }

binaire :    ASSIGN { (print_endline "binaire : ASSIGN") }
	   | OPINF { (print_endline "binaire : OPINF") }
	   | OPSUP { (print_endline "binaire : OPSUP") }
	   | OPINFEG { (print_endline "binaire : OPINFEG") }
	   | OPSUPEG { (print_endline "binaire : OPSUPEG") }
	   | OPEG { (print_endline "binaire : OPEG") }
	   | OPNONEG { (print_endline "binaire : OPNONEG") }
	   | OPPLUS { (print_endline "binaire : OPPLUS") }
	   | OPMOINS { (print_endline "binaire : OPMOINS") }
	   | OPOU { (print_endline "binaire : OPOU") }
	   | OPMULT { (print_endline "binaire : OPMULT") }
	   | OPMOD { (print_endline "binaire : OPMOD") }
	   | OPDIV { (print_endline "binaire : OPDIV") }
	   | OPET { (print_endline "binaire : OPET") }
	   | OPNON { (print_endline "binaire : OPNON") }
	   | OPPT { (print_endline "binaire : OPPT") }

suffixes : /* Lambda, mot vide */ { (print_endline "suffixes : /* Lambda, mot vide */") }
	   | suffixe suffixes { (print_endline "suffixes : suffixe suffixes") }

suffixe :    CROOUV expression CROFER { (print_endline "suffixe : CROOUV expression CROFER") }
	   | PAROUV PARFER { (print_endline "suffixe : PAROUV PARFER") }
           | PAROUV expression expressionvirgule PARFER { (print_endline "suffixe : PAROUV expression expressionvirgule PARFER") }

expressionvirgule : /* Lambda, mot vide */ { (print_endline "expressionvirgule : /* Lambda, mot vide */") }
	   | VIRG expression expressionvirgule { (print_endline "expressionvirgule : VIRG expression expressionvirgule") }

unaires : /* Lambda, mot vide */ { (print_endline "unaires : /* Lambda, mot vide */") }
	   | unaire unaires { (print_endline "expressionvirgule : VIRG expression expressionvirgule") }

partieexpression : ENTIER { (print_endline "partieexpression : ENTIER") }
	   | FLOTTANT { (print_endline "partieexpression : FLOTTANT") }
	   | CARACTERE { (print_endline "partieexpression : CARACTERE") }
	   | BOOLEEN { (print_endline "partieexpression : BOOLEEN") }
	   | VIDE { (print_endline "partieexpression : VIDE") }
           | NOUVEAU IDENT PAROUV PARFER { (print_endline "partieexpression : NOUVEAU IDENT PAROUV PARFER") }
           | NOUVEAU IDENT CROOUV expression CROFER { (print_endline "partieexpression : NOUVEAU IDENT CROOUV expression CROFER") }
           | IDENT suffixes { (print_endline "partieexpression : IDENT suffixes") }
           | PAROUV expression PARFER suffixes { (print_endline "partieexpression : PAROUV expression PARFER suffixes") }


%%
