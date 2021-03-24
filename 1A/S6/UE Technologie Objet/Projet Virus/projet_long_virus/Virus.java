package projet_long_virus;

public class Virus {
	
	private int T_Guerison;
	private int R0;
	private int T_Incubation;
	private double Taux_Mortalite;
	
	public Virus(int t_guerison, int R0, int t_incu, double t_mort) {
		this.T_Guerison = t_guerison;
		this.R0 = R0;
		this.T_Incubation = t_incu;
		this.Taux_Mortalite = t_mort;
	}
	
	public int getTempsGuerison() {
		return T_Guerison;
	}
	public void setTempsGuerison(int t_Guerison) {
		T_Guerison = t_Guerison;
	}
	
	public int getR0() {
		return R0;
	}
	public void setR0(int r0) {
		R0 = r0;
	}
	
	public int getTempsIncubation() {
		return T_Incubation;
	}
	public void setTempsIncubation(int t_Incubation) {
		T_Incubation = t_Incubation;
	}
	
	public double getTauxMortalite() {
		return Taux_Mortalite;
	}
	public void setTauxMortalite(double mortalite_Virus_Utilisateur) {
		Taux_Mortalite = mortalite_Virus_Utilisateur;
	}

}
