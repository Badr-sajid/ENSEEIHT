package projet_long_virus;

public class Programme {
/*
	public static void main(String[] args) throws InterruptedException {

		//Interface utilisateur, on lui demande les valeurs qu'il desire simuler
		System.out.println("Nous avons besoin d'informations sur le virus que vous voulez simuler :");
		
		Scanner scan = new Scanner(System.in);
		System.out.println("Premierement, comment voulez-vous nommer votre virus ?");
		String Nom_Virus_Utilisateur = scan.nextLine();
		
		System.out.println("Entrer le nombre de gens qu'une personne infecte va contaminer en moyenne :");
		int R0_Virus_Utilisateur = scan.nextInt();
		
		System.out.println("Entrer le taux de mortalite du virus " + Nom_Virus_Utilisateur + " :");
		float Mortalite_Virus_Utilisateur = scan.nextFloat();
		
		System.out.println("Entrer le temps de guerison en jour du virus " + Nom_Virus_Utilisateur + " :");
		int Guerison_Virus_Utilisateur = scan.nextInt();
		
		System.out.println("Entrer le temps d'incubation du virus " + Nom_Virus_Utilisateur + " :");
		int Incubation_Virus_Utilisateur = scan.nextInt();
		
		System.out.println("Finalement, pendant combien de jour(s) voulez-vous simuler le virus " + Nom_Virus_Utilisateur + " ?");
		int Temps_Utilisateur = scan.nextInt();
		scan.close();
		
		//System.out.println("Dans quel pays se trouve la premiere victime du virus " + Nom_Virus_Utilisateur + " ?");
		//String Pays_cas_0 = scan.nextLine();
		//scan.close();
		
		//Creation du virus de l'utilisateur
		Virus virus_Utilisateur = new Virus(Guerison_Virus_Utilisateur,R0_Virus_Utilisateur,
				Incubation_Virus_Utilisateur,Mortalite_Virus_Utilisateur);
		/*
		virus_Utilisateur.setR0(R0_Virus_Utilisateur);
		virus_Utilisateur.setTempsGuerison(Guerison_Virus_Utilisateur);
		virus_Utilisateur.setTempsIncubation(Incubation_Virus_Utilisateur);
		virus_Utilisateur.setTauxMortalite(Mortalite_Virus_Utilisateur);
		*//*
		//Creation du continent
		Continent1 Europe = new Continent1();
		Europe.creerContinent();
		Europe.ajouterVoisins();
		
		//Creation du simulateur
		Simulateur1 simulateur = new Simulateur1(virus_Utilisateur);
		
		//Infection du pays demande par l'utilisateur
		Europe.France.setNbInfectes(10);
		Europe.France.setPopTotal(5999990);
		Europe.France.setNbSains(5999990);
		
		//Creation d'une courbe
		TraceurCourbes courbe_virus = new TraceurCourbes();
		
		//Simulation etape par etape avec le temps qui augmente a chaque fois qu'une etape se termine
		int Jour_i = 0;
		while (Jour_i < Temps_Utilisateur) {
			
			//Simulation en interne des pays
			for (int pays_i=0; pays_i < Europe.getPays().size(); pays_i++) {
				
				//Simulation pour tous les pays du continent
				simulateur.simuler(Europe.getPays().get(pays_i));

			}
			courbe_virus.courbe.ajouterPoint(new Point(Jour_i, Europe.France.getNbInfectes()));
			Jour_i = Jour_i + 1;
			Thread.sleep(100);
		}
		
		System.out.println("infecte France : " + Europe.France.getNbInfectes());
		System.out.println("Sains France : " + Europe.France.getNbSains());
		System.out.println("Retablis France : " + Europe.France.getNbRetablis());
		System.out.println("Mort en France : " + Europe.France.getNbMort());
		System.out.println("Incubation France : " + Europe.France.getNbIncubation());
		System.out.println("Infecte en Belgique : " + Europe.Belgique.getNbInfectes());
	}*/
}
