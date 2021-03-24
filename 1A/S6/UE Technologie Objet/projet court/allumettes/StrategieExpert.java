package allumettes;
import java.util.Random;

public class StrategieExpert implements Strategie {

	private Random random = new Random();

	public StrategieExpert() { }

	@Override
	public int nbPrise(Jeu jeu) {

		assert (jeu.getNombreAllumettes() > 0);

		if ((jeu.getNombreAllumettes() - 1) %  (Jeu.PRISE_MAX + 1) == 0) {
			return this.random.nextInt(Math.min(Jeu.PRISE_MAX,
					jeu.getNombreAllumettes())) + 1;

		} else {
			return (jeu.getNombreAllumettes() - 1) % (Jeu.PRISE_MAX + 1);
		}
	}
}
