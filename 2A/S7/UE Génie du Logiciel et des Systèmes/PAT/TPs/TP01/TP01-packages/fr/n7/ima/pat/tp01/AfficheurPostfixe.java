package fr.n7.ima.pat.tp01;

public class AfficheurPostfixe implements VisiteurExpression<String> {

	@Override
	public String visiterAccesVariable(AccesVariable v) {
		return v.getNom();
	}

	@Override
	public String visiterConstante(Constante c) {
		return String.valueOf(c.getValeur());
	}

	@Override
	public String visiterExpressionBinaire(ExpressionBinaire e) {
		return e.getOperandeGauche().accepter(this) 
				+ " " + e.getOperandeDroite().accepter(this) 
				+ " " + e.getOperateur().accepter(this);
	}

	@Override
	public String visiterAddition(Addition a) {
		return "+";
	}

	@Override
	public String visiterMultiplication(Multiplication m) {
		return "*";
	}

	@Override
	public String visiterExpressionUnaire(ExpressionUnaire e) {
		return e.getOperande().accepter(this)
				+ " " + e.getOperateur().accepter(this);
	}

	@Override
	public String visiterNegation(Negation n) {
		return "~";
	}

	@Override
	public String visiterSoustraction(Soustraction s) {
		return "-";
	}

}
