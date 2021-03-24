%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token UL_MACHINE 
%token UL_ACCOUV UL_ACCFER
%token UL_PT
%token UL_EVENT UL_REGION UL_STATE UL_FROM UL_TO UL_ON UL_STARTS UL_ENDS

/* Defini le type des donnees associees a l'unite lexicale */
%token <string> UL_IDENT

/* Unite lexicale particuliere qui represente la fin du fichier */

%token UL_FIN

/* Type renvoye pour le nom terminal document */
%type <unit> machine

/* Le non terminal document est l'axiome */
%start machine

%% /* Regles de productions */

machine : UL_MACHINE UL_IDENT UL_ACCOUV sub_machine UL_ACCFER UL_FIN { (print_endline "machine : MACHINE IDENT { ... } FIN ") }

sub_machine : /*lambda, mot vide*/ { (print_endline "/*lambda, mot vide*/") }
            | suite_sub_machine sub_machine {}

suite_sub_machine : UL_EVENT UL_IDENT {(print_endline "suite_sub_machine : MACHINE IDENT { ... } FIN ") }
                  | transition  {(print_endline "suite_sub_machine : transition") }
                  | region  {(print_endline "suite_sub_machine : region")  }

transition : UL_FROM nom_qualifie UL_TO nom_qualifie UL_ON UL_IDENT {(print_endline "UL_FROM nom_qualifie UL_TO nom_qualifie UL_ON UL_IDENT  ") }

nom_qualifie : UL_IDENT {(print_endline "nom_qualifie : UL_IDENT ") }
             | UL_IDENT UL_PT nom_qualifie {(print_endline "nom_qualifie : UL_IDENT UL_PT nom_qualifie") }


region : UL_REGION UL_IDENT UL_ACCOUV suite_etat UL_ACCFER {(print_endline "region : UL_REGION UL_IDENT UL_ACCOUV suite_etat UL_ACCFER")}


suite_etat : /*lambda, mot vide*/ { (print_endline "/*lambda, mot vide*/") }
           | etat suite_etat {(print_endline "suite_etat : etat suite_etat")}

etat : UL_STATE UL_IDENT sub_starts sub_ends sub_region {(print_endline "etat : UL_STATE UL_IDENT sub_starts sub_ends sub_region")}

sub_starts : /*lambda, mot vide*/ { (print_endline "/*lambda, mot vide*/") }
           | UL_STARTS {(print_endline "sub_starts : UL_STARTS")}


sub_ends : /*lambda, mot vide*/ { (print_endline "/*lambda, mot vide*/") }
           | UL_ENDS {(print_endline "sub_ends : UL_ENDS")}

sub_region : /*lambda, mot vide*/ { (print_endline "/*lambda, mot vide*/") }
           | UL_ACCOUV  suite_region UL_ACCFER {(print_endline "sub_region : UL_ACCOUV  suite_region ")}

suite_region : /*lambda, mot vide*/ { (print_endline "/*lambda, mot vide*/") }
             | region suite_region {(print_endline "suite_region : region suite_region ")}
           


%%
