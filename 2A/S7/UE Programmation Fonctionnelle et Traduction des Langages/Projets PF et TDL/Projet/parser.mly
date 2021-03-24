/* Imports. */

%{

open Type
open Ast.AstSyntax
%}


%token <int> ENTIER
%token <string> ID
%token <string> TID
%token RETURN
%token PV
%token AO
%token AF
%token PF
%token PO
%token EQUAL
%token CONST
%token PRINT
%token IF
%token ELSE
%token WHILE
%token BOOL
%token INT
%token RAT
%token CALL 
%token CO
%token CF
%token SLASH
%token NUM
%token DENOM
%token TRUE
%token FALSE
%token PLUS
%token MULT
%token INF
%token EOF
%token NULL
%token NEW
%token AMP
%token ENUM
%token VRG
%token SWITCH
%token CASE
%token DEFAULT
%token DPT
%token BREAK

(* Type de l'attribut synthétisé des non-terminaux *)
%type <programme> prog
%type <instruction list> bloc
%type <fonction> fonc
%type <instruction list> is
%type <instruction> i
%type <typ> typ
%type <(typ*string) list> dp
%type <expression> e 
%type <expression list> cp
%type <affectable> aff
%type <enum> en
%type <case list> lc

(* Type et définition de l'axiome *)
%start <Ast.AstSyntax.programme> main

%%

main : lfi = prog EOF     {lfi}

prog :
| len = en  lfi = prog   {let (Programme (len1,lf,li))=lfi in (Programme (len::len1,lf,li))}
| lf = fonc  lfi = prog   {let (Programme (len,lf1,li))=lfi in (Programme (len,lf::lf1,li))}
| ID li = bloc            {Programme ([],[],li)}

en : ENUM n=TID AO v=ids AF PV    {Enumeration(n,v)}

ids :
| n=TID                 {[n]}
| n=TID VRG lv=ids     {n::lv}

fonc : t=typ n=ID PO p=dp PF AO li=is RETURN exp=e PV AF {Fonction(t,n,p,li,exp)}

bloc : AO li = is AF      {li}

is :
|                         {[]}
| i1=i li=is              {i1::li}

i :
| t=typ n=ID EQUAL e1=e PV          {Declaration (t,n,e1)}
| a=aff EQUAL e1=e PV               {Affectation (a,e1)}
| CONST n=ID EQUAL e=ENTIER PV      {Constante (n,e)}
| PRINT e1=e PV                     {Affichage (e1)}
| IF exp=e li1=bloc ELSE li2=bloc   {Conditionnelle (exp,li1,li2)}
| WHILE exp=e li=bloc               {TantQue (exp,li)}
| SWITCH PO exp=e PF AO l=lc AF     {Switch (exp,l)}

dp :
|                         {[]}
| t=typ n=ID lp=dp        {(t,n)::lp}

typ :
| t=typ MULT            {Pointeur t}
| BOOL                  {Bool}
| INT                   {Int}
| RAT                   {Rat}
| n=TID                 {Enumere n}


e : 
| CALL n=ID PO lp=cp PF   {AppelFonction (n,lp)}
| CO e1=e SLASH e2=e CF   {Rationnel(e1,e2)}
| NUM e1=e                {Numerateur e1}
| DENOM e1=e              {Denominateur e1}
| a=aff                   {Affectable a}
| TRUE                    {True}
| FALSE                   {False}
| e=ENTIER                {Entier e}
| PO e1=e PLUS e2=e PF    {Binaire (Plus,e1,e2)}
| PO e1=e MULT e2=e PF    {Binaire (Mult,e1,e2)}
| PO e1=e EQUAL e2=e PF   {Binaire (Equ,e1,e2)}
| PO e1=e INF e2=e PF     {Binaire (Inf,e1,e2)}
| PO exp=e PF             {exp}
| PO NEW t=typ PF         {New t}
| AMP n=ID                {Adresse n}
| NULL                    {Null}
| n=TID                   {ValEnum n}

aff :
| n=ID                    {Ident n}
| PO MULT a=aff PF        {Valeur a}

cp :
|               {[]}
| e1=e le=cp    {e1::le}

lc :
|                   {[]}
| c=case l=lc       {c::l}

case : 
| CASE tc=typecase DPT l=is b=br  {Case (tc,l,b)}
| DEFAULT DPT l=is b=br  {Default (l,b)}

typecase :
| n=TID        {TEnum (n)}
| n=ENTIER     {TEntier (n)}
| TRUE         {TTrue}
| FALSE        {TFalse}

br :
|               {false}
| BREAK PV      {true}

