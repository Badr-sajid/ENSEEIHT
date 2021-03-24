open Compilateur
open Exceptions 

exception ErreurNonDetectee;;

let%test_unit "testEnum1" = 
  let _ = compiler "../../fichiersRat/src-rat-enumeration-test/testEnum1.rat" in ()

let%test_unit "testEnum2" = 
  let _ = compiler "../../fichiersRat/src-rat-enumeration-test/testEnum2.rat" in ()


let%test_unit "testEnum3" = 
  let _ = compiler "../../fichiersRat/src-rat-enumeration-test/testEnum3.rat" in ()

let%test_unit "testEnum4" = 
  try
    let _ = compiler "../../fichiersRat/src-rat-enumeration-test/testEnum4.rat"
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("Fevrier") -> ()

let%test_unit "testEnum5" = 
  let _ = compiler "../../fichiersRat/src-rat-enumeration-test/testEnum5.rat" in ()