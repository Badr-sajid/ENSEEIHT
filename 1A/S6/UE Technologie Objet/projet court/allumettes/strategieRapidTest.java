package allumettes;

import org.junit.*;
import static org.junit.Assert.*;


/** Programme de test de la classe StratgieRapide.
  * @author	Sajid Badr
  */
public class strategieRapidTest {

	private static final int NB_ALLUMETTES_INITIAL = 13;

	private Joueur joueurRapide;
	private Joueur Ordinateur;
	private Jeu jeu;

	@Before
	public void setUp() {
		joueurRapide = new Joueur("Rapide", new StrategieRapide());

		Ordinateur = new Joueur("Ordinateur", new StrategieHumain());
	}

	@Test
	public void testPremierCas() throws Exception {
		// Premier cas où le nombre d'allumettes tiré
		// est >= 3
		System.out.println("------ Premier cas !! --------");
		jeu = new JeuReel(NB_ALLUMETTES_INITIAL);
		System.out.println("");
		faireTour(joueurRapide,13,3);
		faireTour(Ordinateur,10,2);
		faireTour(joueurRapide,8,3);
		faireTour(Ordinateur,5,2);
		faireTour(joueurRapide,3,3);
		afficherResultat(Ordinateur, joueurRapide);
	}

	@Test
	public void testDeuxiemeCas() throws Exception {
		// Premier cas où le nombre d'allumettes tiré
		// est ( > 3 ou = 2 )
		System.out.println("------ Deuxième cas !! --------");
		jeu = new JeuReel(NB_ALLUMETTES_INITIAL);
		System.out.println("");
		faireTour(joueurRapide,13,3);
		faireTour(Ordinateur,10,3);
		faireTour(joueurRapide,7,3);
		faireTour(Ordinateur,4,2);
		faireTour(joueurRapide,2,2);
		afficherResultat(Ordinateur, joueurRapide);
	}

	@Test
	public void testTroisiemeCas() throws Exception {
		// Premier cas où le nombre d'allumettes tiré
		// est ( > 3 ou = 1 )
		System.out.println("------ Troisème cas !! --------");
		jeu = new JeuReel(NB_ALLUMETTES_INITIAL);
		System.out.println("");
		faireTour(joueurRapide,13,3);
		faireTour(Ordinateur,10,3);
		faireTour(joueurRapide,7,3);
		faireTour(Ordinateur,4,3);
		faireTour(joueurRapide,1,1);
		afficherResultat(Ordinateur, joueurRapide);
	}

	@Test
	public void testQuatriemeCas() throws Exception {
		// Premier cas où le nombre d'allumettes tiré
		// est ( > 3 ou = 1 ) et gagne
		System.out.println("------ Quatrième cas !! --------");
		jeu = new JeuReel(NB_ALLUMETTES_INITIAL);
		faireTour(joueurRapide,13,3);
		faireTour(Ordinateur,10,2);
		faireTour(joueurRapide,8,3);
		faireTour(Ordinateur,5,1);
		faireTour(joueurRapide,4,3);
		faireTour(Ordinateur,1,1);
		afficherResultat(joueurRapide, Ordinateur);
	}

	public void afficherPrise(Joueur joueur, int nbPrises) {
		if (nbPrises > 1) {
			System.out.println(joueur.getNom() + " prend " + nbPrises
					+ " allumettes .");
		} else {
			System.out.println(joueur.getNom() + " prend " + nbPrises
					+ " allumette .");
		}
	}
	
	private void afficherMessage(Jeu jeu) {
		System.out.println("Nombre d'allumettes restantes : "
				+ jeu.getNombreAllumettes());
	}

	private void afficherTour(Joueur joueur) {
		System.out.println("Au tour de " + joueur.getNom() + ".");
	}

	private void faireTour(Joueur joueur, int NbAllumettesInit, int laPrises) throws Exception {

		int nbPrises = 0;

		assertTrue(jeu.getNombreAllumettes() == NbAllumettesInit);

		afficherMessage(jeu);

		afficherTour(joueur);
		if (joueur.getNom() == "Rapide") {
			nbPrises = joueur.getPrise(jeu);
		} else {
			nbPrises = laPrises;
		}

		assertTrue(nbPrises == laPrises);

		afficherPrise(joueur, nbPrises);

		jeu.retirer(nbPrises);

		System.out.println("");
	}

	public void afficherResultat(Joueur gagnant, Joueur perdant) {
		System.out.println(perdant.getNom() + " a perdu !");
		System.out.println(gagnant.getNom() + " a gagné !");
		System.out.println("\n\n");
	}
}
