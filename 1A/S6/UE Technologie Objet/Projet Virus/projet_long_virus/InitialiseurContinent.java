package projet_long_virus;

public final class InitialiseurContinent {
	
	
	public static Continent initialiserContinent() {
		
		Continent continent = new Continent("Monde");
		// Creation des pays 
		Pays USA = new Pays("USA", 300000000, 265, 260, continent);
		Pays France = new Pays("France", 65000000, 550, 225, continent);
		Pays Maroc = new Pays("Maroc", 30000000, 515, 290, continent);
		Pays Chine = new Pays("Chine", 1300000000, 820, 300, continent);
		Pays Italie = new Pays("Italie", 60000000, 575, 245, continent);
		Pays Russie = new Pays("Russiee", 144000000, 725, 210, continent);
		Pays Espagne = new Pays("Espagne", 46000000, 529, 252, continent);
		Pays Angleterre = new Pays("Angleterre", 55000000, 534, 205, continent);
		Pays Allemagne = new Pays("Allemagne", 83000000, 570, 215, continent);
		Pays Norvege = new Pays("Norvege", 5000000, 570, 167, continent);
		Pays Suede = new Pays("Suede", 10000000, 580, 167, continent);
		Pays Finlande = new Pays("Finlande", 5000000, 610, 161, continent);
		Pays Algerie = new Pays("Algerie", 42000000, 545, 275, continent);
		Pays Tunisie = new Pays("Tunisie", 11000000, 563, 270, continent);
		Pays Brazil = new Pays("Brazil", 209000000, 415, 420, continent);
		Pays Mexique = new Pays("Mexique", 126000000, 260, 316, continent);
		
			
		// ajout des pays
		continent.ajouterPays(France);
		continent.ajouterPays(USA);
		continent.ajouterPays(Maroc);
		continent.ajouterPays(Chine);
		continent.ajouterPays(Italie);
		continent.ajouterPays(Russie);
		continent.ajouterPays(Espagne);
		continent.ajouterPays(Angleterre);
		continent.ajouterPays(Allemagne);
		continent.ajouterPays(Norvege);
		continent.ajouterPays(Suede);
		continent.ajouterPays(Finlande);
		continent.ajouterPays(Algerie);
		continent.ajouterPays(Tunisie);
		continent.ajouterPays(Brazil);
		continent.ajouterPays(Mexique);
		
		
		
		initialiserPays(continent);
		
		
		return continent;
	}
	

	// Apres un reset, on remet le nb_infecte a 1 dans tous les pays du continent
	public static void initialiserPays(Continent c) {
		for(Pays p: c.getContinent()) {
			p.setNbInfectes(0);
			p.setNbMort(0);
			p.setNbRetablis(0);
			p.setNbSains(p.getPopTotal());
			p.setNbIncubation(0);
		}
		Pays p = c.getContinent().get(1);
		p.setNbInfectes(1);
		p.setNbSains(p.getPopTotal()-1);
		
		
	}

}
