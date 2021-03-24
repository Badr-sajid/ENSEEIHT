package allumettes;
import java.util.Scanner;

public class StrategieHumain implements Strategie {
	private Scanner scanner;
	private int prise;

	public StrategieHumain() {
		this.scanner = new Scanner(System.in);
	}

	@Override
	public int nbPrise(Jeu jeu)  {

		assert (jeu.getNombreAllumettes() > 0);

		boolean fin = false;

		while (!fin) {
			try {
				System.out.print("Combien prenez-vous d'allumettes ? ");
				prise = Integer.parseInt(this.scanner.nextLine());
				fin = true;
			} catch (NumberFormatException e) {
				System.out.println("Vous devez donner un entier.");
			}
		}
		return prise;
	}
}
