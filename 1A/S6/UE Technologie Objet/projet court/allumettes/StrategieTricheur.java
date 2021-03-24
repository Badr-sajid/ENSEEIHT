package allumettes;

public class StrategieTricheur implements Strategie {

	@Override
	public int nbPrise(Jeu jeu) {

		assert (jeu.getNombreAllumettes() > 0);
		try {
			while (jeu.getNombreAllumettes() >= 2 * Jeu.PRISE_MAX - 1) {
				jeu.retirer(Jeu.PRISE_MAX);
				}
			jeu.retirer(jeu.getNombreAllumettes() - 2);

		} catch (CoupInvalideException e) {
			System.out.println(e);
		}

		return 1;
	}
}
