package allumettes;
import java.util.Random;

public class StrategieNaif implements Strategie {

	private Random rnd;

	public StrategieNaif() {
		this.rnd = new Random();
	}
	@Override
	public int nbPrise(Jeu jeu) {
		return this.rnd.nextInt(Math.min(jeu.getNombreAllumettes(),
				Jeu.PRISE_MAX)) + 1;
	}
}
