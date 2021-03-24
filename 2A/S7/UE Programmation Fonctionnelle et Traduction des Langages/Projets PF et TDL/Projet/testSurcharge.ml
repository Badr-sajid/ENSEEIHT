open Compilateur

let%test_unit "testSurcharge1" = 
  let _ = compiler "../../fichiersRat/src-rat-surcharge-test/testSurcharge1.rat" in ()

let%test_unit "testSurcharge2" = 
  let _ = compiler "../../fichiersRat/src-rat-surcharge-test/testSurcharge2.rat" in ()

let%test_unit "testSurcharge3" = 
  let _ = compiler "../../fichiersRat/src-rat-surcharge-test/testSurcharge3.rat" in ()