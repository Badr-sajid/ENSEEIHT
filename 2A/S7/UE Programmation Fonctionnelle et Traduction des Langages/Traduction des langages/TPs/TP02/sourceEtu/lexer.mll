{
  open Parser
  open Lexing

  exception Error of string

}

rule token = parse
  | '\n'  (* ignore newlines but count them *)
      { new_line lexbuf; token lexbuf }
| [' ' '\t'] (* ignore whitespaces and tabs *)
    { token lexbuf }
| "//"[^'\n']*    { token lexbuf }

| "return"  {RETURN}
| ";"       {PV}
| "{"       {AO}
| "}"       {AF}
| "("       {PO}
| ")"       {PF}
| "="       {EQUAL}
| "const"   {CONST}
| "print"   {PRINT}
| "if"      {IF}
| "else"    {ELSE}
| "while"   {WHILE}
| "bool"    {BOOL}
| "int"     {INT}
| "rat"     {RAT}
| "call"    {CALL} 
| "["       {CO}
| "]"       {CF}
| "/"       {SLASH}
| "num"     {NUM}
| "denom"   {DENOM}
| "true"    {TRUE}
| "false"   {FALSE}
| "+"       {PLUS}
| "*"       {MULT}
| "<"       {INF}
| ['0'-'9']+ as i
    { ENTIER (int_of_string i) }
| ['a'-'z'](['A'-'Z''a'-'z''0'-'9']|"-"|"_")* as n
    { ID n }
| eof
    { EOF }
| _
{ raise (Error ("Unexpected char: "^(Lexing.lexeme lexbuf)^" at "^(string_of_int (Lexing.lexeme_start
lexbuf))^"-"^(string_of_int (Lexing.lexeme_end lexbuf)))) }
