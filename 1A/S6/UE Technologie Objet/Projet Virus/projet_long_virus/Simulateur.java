package projet_long_virus;

public class Simulateur {
	
	private Virus virus;
	//Amine Ajout
	private boolean confinement = false;
	private boolean vaccin = false;
	
	public Simulateur(Virus V) {
		this.virus = V;
	}

	public void simuler(Pays pays) {
		
		//Variables necessaires dans le pays
		double NbSains = pays.getNbSains();
		double NbInfectes = pays.getNbInfectes();
		double NbRetablis = pays.getNbRetablis();
		double NbIncubation = pays.getNbIncubation();
		double PopTotal = pays.getPopTotal();
		double NbMort = pays.getNbMort();
		//Nayel Ajout
		Continent ContinentDuPays = pays.getContinent();
		double[][] ProbaInfectionContinent= ContinentDuPays.getProbaInfectionContinent();
		int [][] NbrVoyageurEntrePaysParJour = ContinentDuPays.getNbrVoyageurEntrePaysParJour();
		int NbrPaysdansContinent = ContinentDuPays.getNbrPays();

		
		//Variables necessaires du virus
		int T_Guerison = virus.getTempsGuerison();
		int R0 = virus.getR0();
		int T_Incubation = virus.getTempsIncubation();
		double Taux_Mortalite = virus.getTauxMortalite();
		//Amine Ajout
		if (confinement) {
			R0 = R0 / 2;
		} else if (vaccin) {
			R0 = R0 / 2;
			if (T_Guerison > 2) {
				T_Guerison = 2;
			}
			
		}
		
		//Taux d'incidence
		double Beta = R0 / (PopTotal * T_Guerison);
		//S'il y a des infectes dans le pays
		if (NbInfectes > 0) {

		//Calcul de l'etape suivante (J+1) 
		double NbSainsNext = NbSains - NbSains * NbInfectes * Beta;
		double NbIncubationNext = NbIncubation + NbSains * NbInfectes * Beta - NbIncubation / T_Incubation;
		double NbInfectesNext = NbInfectes + NbIncubation / T_Incubation - NbInfectes / T_Guerison - NbInfectes * Taux_Mortalite / T_Guerison;
		double NbRetablisNext = NbRetablis + NbInfectes / T_Guerison;
		double NbMortNext = NbMort + NbInfectes * Taux_Mortalite / T_Guerison;
		double PopTotalNext = PopTotal - NbInfectes * Taux_Mortalite / T_Guerison;
		

		
		
		
		
		//Modification des variables du pays
		pays.setNbSains(NbSainsNext);
		pays.setNbInfectes(NbInfectesNext);
		pays.setNbRetablis(NbRetablisNext);
		pays.setNbIncubation(NbIncubationNext);
		pays.setPopTotal(PopTotalNext);
		pays.setNbMort(NbMortNext);
		} 
		
		
		//S'il n'y a toujours pas d'infectes dans le pays
		// NAYEL AJOUT
		// On regarde s'il y a un infectÈ qui vient d'un autre pays		
		else {
			//Amine Ajout
			if (!confinement) {
			int colonne = pays.getId();
			// On boucle sur tous les pays du continent
			for (int ligne=0;ligne<NbrPaysdansContinent;ligne++) {
				// On regarde parmi les personnes qui vont voyager celles qui seront infectÈes
				
				// Pour le pays des voyageurs on rÈcupËre son nombre de voyageurs...
				int NbrVoyageurs = NbrVoyageurEntrePaysParJour[ligne][colonne];
				
				// ... sa proportion d'infectÈs ...
				Pays PaysVoyageurs = ContinentDuPays.getContinent().get(ligne);
				double InfecterPaysVoyageurs = PaysVoyageurs.getNbInfectes();
				double PopTotalePaysVoyageurs = PaysVoyageurs.getPopTotal();
				double ProportionInfecterDansPaysDesVoyageurs = InfecterPaysVoyageurs/PopTotalePaysVoyageurs;
				
				// ... pour en dÈduire le nombre  d'infectÈs parmis ses voyageurs !
				double NbrVoyageurInfecter = ProportionInfecterDansPaysDesVoyageurs*NbrVoyageurs;
				
				// On conditionne et on ajoute
				if (NbrVoyageurInfecter>10) {
					pays.setNbInfectes(1);
				}
			}
			}
			
			
		}
		
		
		/*
		else {
			for (int pays_voisins_i = 0; pays_voisins_i < pays.getVoisins().size(); pays_voisins_i++) {
				
				Pays voisin = pays.getVoisin_i(pays_voisins_i); // le pays voisin
				if (voisin.getNbInfectes() / voisin.getPopTotal() > 0.1) {
					pays.setNbInfectes(1);
				}
				
			}
		}*/
		
		
	}
	
	public void SetConfinement(boolean etat) {
		 confinement = etat;
	}
	
	public void SetVaccinc(boolean etat) {
		 vaccin = etat;
	}

}
