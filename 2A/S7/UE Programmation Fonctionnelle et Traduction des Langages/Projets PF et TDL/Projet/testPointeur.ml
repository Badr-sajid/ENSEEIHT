open Compilateur

let%test_unit "testPointeur1" = 
  let _ = compiler "../../fichiersRat/src-rat-pointeur-test/testPointeur1.rat" in ()

let%test_unit "testPointeur2" = 
  let _ = compiler "../../fichiersRat/src-rat-pointeur-test/testPointeur2.rat" in ()

let%test_unit "testPointeur3" = 
  let _ = compiler "../../fichiersRat/src-rat-pointeur-test/testPointeur3.rat" in ()