package allumettes;

public class JeuReel implements Jeu {

	private int nbAllumette;
	private Jeu jeu;

	public JeuReel(Jeu jeu) {
		assert (jeu != null);
		this.jeu = jeu;
	}

	public JeuReel(int nombre) {
		assert (nombre > 0);
		this.nbAllumette = nombre;
	}
	@Override
	public int getNombreAllumettes() {
		return  this.nbAllumette;
	}

	@Override
	public void retirer(int nbPrises) throws CoupInvalideException {
		if (nbPrises > 0 && nbPrises <= JeuReel.PRISE_MAX
				&& nbPrises <= this.nbAllumette) {
			this.nbAllumette -= nbPrises;
		} else {
			throw new CoupInvalideException(nbPrises,
					"Le coup choisis est invalid");
		}
	}
}
