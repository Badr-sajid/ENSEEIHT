type typ = Bool | Int | Rat | Undefined | Pointeur of typ | Enumere of string
let rec string_of_type t = 
  match t with
  | Bool ->  "Bool"
  | Int  ->  "Int"
  | Rat  ->  "Rat"
  | Undefined -> "Undefined"
  | Pointeur t1 -> "Pointeur "^string_of_type t1
  | Enumere t -> "Enumere "^t


let rec est_compatible t1 t2 =
  match t1, t2 with
  | Bool, Bool -> true
  | Int, Int -> true
  | Rat, Rat -> true 
  | Pointeur pt1, Pointeur pt2 -> est_compatible pt1 pt2
  | Enumere t1, Enumere t2 -> t1=t2
  | _ -> false 

let est_compatible_list lt1 lt2 =
  try
    List.for_all2 est_compatible lt1 lt2
  with Invalid_argument _ -> false

let rec getTaille t =
  match t with
  | Int -> 1
  | Bool -> 1
  | Rat -> 2
  | Undefined -> 0
  | Pointeur t1 -> getTaille t1
  | Enumere _ -> 1
  
