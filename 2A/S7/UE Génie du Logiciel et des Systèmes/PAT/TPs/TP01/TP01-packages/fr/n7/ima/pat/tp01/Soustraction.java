package fr.n7.ima.pat.tp01;

public class Soustraction implements OperateurBinaire {

	@Override
	public <R> R accepter(VisiteurExpression<R> visiteur) {
		return visiteur.visiterSoustraction(this);
	}

}
