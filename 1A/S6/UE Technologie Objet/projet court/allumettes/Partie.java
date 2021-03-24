package allumettes;

/** Lance une partie des 13 allumettes en fonction des arguments fournis
 * sur la ligne de commande.
 * @author	Xavier Crégut
 * @version	$Revision: 1.5 $
 */
public class Partie {
	private static final int NB_ALLUMETTES_INITIAL = 13;
	private static final int NB_ARG = 3;


	/** Lancer une partie. En argument sont donnés les deux joueurs sous
	 * la forme nom@stratégie.
	 * @param args la description des deux joueurs
	 */
	public static void main(String[] args) {
		Joueur joueur1 = null;
		Joueur joueur2 = null;
		Arbitre arbitre;

		try {
			verifierNombreArguments(args);

			// Création du joueur 1
			joueur1 = creerJoueur(args, 2);

			// Création du joueur 2
			joueur2 = creerJoueur(args, 1);

		} catch (ConfigurationException e) {
			System.out.println();
			System.out.println("Erreur : " + e.getMessage());
			afficherUsage();
			System.exit(1);
		}


		// Création du jeu
		Jeu jeu = new JeuReel(NB_ALLUMETTES_INITIAL);

		arbitre = new Arbitre(joueur1, joueur2, (args.length == NB_ARG));
		arbitre.arbitrer(jeu);
	}

	private static void verifierNombreArguments(String[] args) {
		if (args.length < 2) {
			throw new ConfigurationException("Trop peu d'arguments : "
					+ args.length);
		} else if (args.length > NB_ARG) {
			throw new ConfigurationException("Trop d'arguments : "
					+ args.length);
		} else if (spliter(args[args.length - 2]).length != 2) {
			throw new ConfigurationException("Format du joueur incorrect : "
		+  args[0]);
		} else if (spliter(args[args.length - 1]).length != 2) {
			throw new ConfigurationException("Format du joueur incorrect : "
		+  args[1]);
		}
	}



	public static Strategie nommerStrategie(String str) {
		Strategie strategie = null;
		String nomStrategie = str.toLowerCase();

		switch (nomStrategie) {
		case "naif" :
			strategie = new StrategieNaif();
			break;

		case "rapide" :
			strategie = new StrategieRapide();
			break;

		case "expert" :
			strategie = new StrategieExpert();
			break;

		case "humain" :
			strategie = new StrategieHumain();
			break;

		case "tricheur" :
			strategie = new StrategieTricheur();
			break;

		default :
			throw new ConfigurationException("La strategie choisie est "
					+ "incorrecte");
		}
		return strategie;
	}

	public static Joueur creerJoueur(String[] args, int i) {
		String[] j;
		j = spliter(args[args.length - i]);
		return new Joueur(j[0], nommerStrategie(j[1]));
	}

	public static String[] spliter(String args) {
		String[] j;
		j = args.split("@");
		return j;
	}

	/** Afficher des indications sur la manière d'exécuter cette classe. */
	public static void afficherUsage() {
		System.out.println("\n" + "Usage :"
				+ "\n\t" + "java allumettes.Partie joueur1 joueur2"
				+ "\n\t\t" + "joueur est de la forme nom@stratégie"
				+ "\n\t\t" + "strategie = naif | rapide | expert "
						+ "| humain | tricheur"
				+ "\n"
				+ "\n\t" + "Exemple :"
				+ "\n\t" + "	java allumettes.Partie Xavier@humain "
					   + "Ordinateur@naif"
				+ "\n"
				);
	}

}
