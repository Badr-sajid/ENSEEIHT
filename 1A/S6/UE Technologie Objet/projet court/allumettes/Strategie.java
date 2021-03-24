package allumettes;

public interface Strategie {

	/** Obtenir le nombre d'allumettes à tirer.
	 * @param nbAllumette nombre d'allumettes encore en jeu
	 * @return nombre d'allumettes à tirer
	 */
	int nbPrise(Jeu jeu);
}
