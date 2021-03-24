package allumettes;

public class JeuProcuration implements Jeu {

	private Jeu jeu;

	public JeuProcuration(Jeu jeu) {
		assert (jeu != null);
		this.jeu = jeu;
	}

	@Override
	public int getNombreAllumettes() {

		return this.jeu.getNombreAllumettes();
	}

	@Override
	public void retirer(int nbPrises) throws OperationInterditeException {
		throw new OperationInterditeException("..");
	}
}
