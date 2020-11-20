package fr.n7.ima.pat.tp01;
import java.util.HashMap;

public class EvaluateurExpression implements VisiteurExpression<Integer> {

	private HashMap<String,Integer> Environnement = new HashMap<String,Integer>();
	private Expression gauche;
	private Expression droite;
	private Expression unaire;
	
	public EvaluateurExpression(HashMap<String, Integer> env) {
		this.Environnement = env;
	}

	@Override
	public Integer visiterAccesVariable(AccesVariable v) {
		return Environnement.get(v.getNom());
	}

	@Override
	public Integer visiterConstante(Constante c) {
		return c.getValeur();
	}

	@Override
	public Integer visiterExpressionBinaire(ExpressionBinaire e) {
		this.gauche = e.getOperandeGauche();
		this.droite = e.getOperandeDroite();
		return e.getOperateur().accepter(this);
	}

	@Override
	public Integer visiterAddition(Addition a) {
		return this.gauche.accepter(new EvaluateurExpression(this.Environnement)) + this.droite.accepter(new EvaluateurExpression(this.Environnement));
	}

	@Override
	public Integer visiterMultiplication(Multiplication m) {
		// TODO Auto-generated method stub
		return this.gauche.accepter(new EvaluateurExpression(this.Environnement)) * this.droite.accepter(new EvaluateurExpression(this.Environnement));
	}

	@Override
	public Integer visiterSoustraction(Soustraction s) {
		return this.gauche.accepter(new EvaluateurExpression(this.Environnement)) - this.droite.accepter(new EvaluateurExpression(this.Environnement));
	}

	@Override
	public Integer visiterExpressionUnaire(ExpressionUnaire e) {
		this.unaire = e.getOperande();
		return e.getOperateur().accepter(this);
	}

	@Override
	public Integer visiterNegation(Negation n) {
		return -this.unaire.accepter(new EvaluateurExpression(this.Environnement));
	}

}
