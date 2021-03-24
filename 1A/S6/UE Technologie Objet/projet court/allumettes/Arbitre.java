package allumettes;

public class Arbitre {
	private Joueur joueur1;
	private Joueur joueur2;
	private boolean confiant;

	public Arbitre(Joueur j1, Joueur j2) {
		assert (j1 != null && j2 != null);
		this.joueur1 = j1;
		this.joueur2 = j2;
	}

	public Arbitre(Joueur j1, Joueur j2, boolean confiant) {
		this(j1, j2);
		this.confiant = confiant;
	}

	public void arbitrer(allumettes.Jeu jeu) {
		Joueur tour = this.joueur1;
		boolean tourJ1 = true;

		while (jeu.getNombreAllumettes() > 0) {

			// attribuer le tour au joueur correspondant.
			tour = donnerTour(jeu, tourJ1);

			try {
				// Demander le nombre de prise.
				int nbPrises = 0;
				nbPrises = getPrise(jeu, tour);

				// Affichage du nombre de prise
				afficherPrise(tour, nbPrises);

				jeu.retirer(nbPrises);
				System.out.println();
				tourJ1 = !tourJ1;
			} catch (CoupInvalideException e) {
				if (e.getNombreAllumettes() > jeu.getNombreAllumettes()) {

					System.out.println("Erreur ! Prise invalide : "
							+ e.getNombreAllumettes() + "(>"
							+ jeu.getNombreAllumettes()
							+ ")");
				} else if (e.getNombreAllumettes() > Jeu.PRISE_MAX) {

					System.out.println("Erreur ! Prise invalide : "
							+ e.getNombreAllumettes() + "(>"
							+ Jeu.PRISE_MAX + ")");
				} else if (e.getNombreAllumettes() < 1) {

					System.out.println("Erreur ! Prise invalide : "
							+ e.getNombreAllumettes()
							+ "(<" + 1 + ")");
				}
				System.out.println("Recommencez !");
				System.out.println("");
			} catch (OperationInterditeException f) {
				System.out.println("Partie abandonnée car "
						+ tour.getNom() + " a triché !");
				break;
			}
		}

		if (jeu.getNombreAllumettes() == 0) {
			afficherResultat(tourJ1);
		}
	}


	public Joueur donnerTour(Jeu jeu, boolean tourJ1) {
		Joueur tour;
		System.out.println("Nombre d'allumettes restantes : "
		+ jeu.getNombreAllumettes());

		if (!tourJ1) {
			tour = this.joueur2;
		} else {
			tour = this.joueur1;
		}
		System.out.println("Au tour de " + tour.getNom() + ".");
		return tour;
	}

	public int getPrise(Jeu jeu, Joueur tour) {
		int nbPrises;
		if (this.confiant) {
			nbPrises = tour.getPrise(jeu);
		} else {
			nbPrises = tour.getPrise(new JeuProcuration(jeu));
		}
		return nbPrises;
	}

	public void afficherPrise(Joueur tour, int nbPrises) {
		if (nbPrises > 1) {
			System.out.println(tour.getNom() + " prend " + nbPrises
					+ " allumettes .");
		} else {
			System.out.println(tour.getNom() + " prend " + nbPrises
					+ " allumette .");
		}
	}

	public void afficherResultat(boolean tour) {
		Joueur gagnant = this.joueur1;
		Joueur perdant = this.joueur2;

		if (!tour) {
			gagnant = this.joueur2;
			perdant = this.joueur1;
		}

		System.out.println(perdant.getNom() + " a perdu !");
		System.out.println(gagnant.getNom() + " a gagné !");
	}
}
