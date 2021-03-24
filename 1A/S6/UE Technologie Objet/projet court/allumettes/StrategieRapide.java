package allumettes;

public class StrategieRapide implements Strategie {

	public StrategieRapide() { }

	@Override
	public int nbPrise(Jeu jeu) {

		assert (jeu.getNombreAllumettes() > 0);

		return Math.min(jeu.getNombreAllumettes(),
				Jeu.PRISE_MAX);
	}
}
