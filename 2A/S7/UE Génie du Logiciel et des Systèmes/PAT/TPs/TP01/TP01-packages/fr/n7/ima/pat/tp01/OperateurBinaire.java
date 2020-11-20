package fr.n7.ima.pat.tp01;

/**
  * Opérateur binaire.
  *
  * @author	Xavier Crégut
  * @version	$Revision$
  */
public interface OperateurBinaire {

	<R> R accepter(VisiteurExpression<R> visiteur);

}
