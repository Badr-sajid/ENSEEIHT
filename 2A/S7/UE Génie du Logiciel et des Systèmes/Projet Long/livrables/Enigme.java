import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class Enigme {

	public static void main(String[] args) {
		
		boolean estJeuFini = false;
		
		// Création des  lieux

		String LieuEnigme = "Enigme";
		String typeLieuEnigme  = "début";
		String MessageLieuEnigme  = "";
		
		String LieuSucces = "Succes";
		String typeLieuSucces  = "fin";
		String MessageLieuSucces  = "";
		
		String LieuEchec = "Echec";
		String typeLieuEchec  = "fin";
		String MessageLieuEchec  = "";
		
		HashMap<String, String> mapTypeLieu = new HashMap<String, String>();
		HashMap<String, String> mapMessageLieu = new HashMap<String, String>();

		mapTypeLieu.put(LieuEnigme,typeLieuEnigme);
		mapTypeLieu.put(LieuSucces,typeLieuSucces);
		mapTypeLieu.put(LieuEchec,typeLieuEchec);

		mapMessageLieu.put(LieuEnigme,MessageLieuEnigme);
		mapMessageLieu.put(LieuSucces,MessageLieuSucces);
		mapMessageLieu.put(LieuEchec,MessageLieuEchec);


		// Création des objets
		ArrayList<String> listObjet = new ArrayList<String>();
		listObjet.add("tentative");


		// Création des Connaissances
		ArrayList<String> listConnaissance = new ArrayList<String>();
		listConnaissance.add("Reussite");


		// Création des personnages
		String NomSphinx = "Sphinx";
		ArrayList<String> listObjetSphinx = new ArrayList<String>();
		ArrayList<String> listConnaissanceSphinx = new ArrayList<String>();

		HashMap<String, ArrayList<String>> InfoObjetPersonne = new HashMap<String, ArrayList<String>>();
		HashMap<String, ArrayList<String>> InfoConnaissancePersonne = new HashMap<String, ArrayList<String>>();
		InfoObjetPersonne.put("Sphinx",listObjetSphinx);

		InfoConnaissancePersonne.put("Sphinx",listConnaissanceSphinx);
		
		// Création des interactions
		String QuestionSphinx = "Question";
		HashMap<String, Boolean> listChoixSphinx = new HashMap<String, Boolean>();
		listChoixSphinx.put("Choix1",true);
		
		listChoixSphinx.put("Choix2",false);
		


		HashMap<Boolean, String > listresultatSphinx = new HashMap<Boolean, String>();
		listresultatSphinx.put(true, "Succes");
		listresultatSphinx.put(false, "Echec");


		HashMap<String, String> InteractionQuestion = new HashMap<String, String>();
		HashMap<String, HashMap<String, Boolean>> InteractionChoix = new HashMap<String, HashMap<String, Boolean>>();
		HashMap<String, HashMap<Boolean, String>> InteractionResultat = new HashMap<String, HashMap<Boolean, String>>();
	
		InteractionQuestion.put("Sphinx",QuestionSphinx);

		InteractionChoix.put("Sphinx",listChoixSphinx);

		InteractionResultat.put("Sphinx",listresultatSphinx);


		// Creation de la liste des objet, connaisance et personne visible dans chaque lieu
		// Lieu Enigme
		ArrayList<String> listObjetLieuEnigme = new ArrayList<String>();
		ArrayList<String> listConnaissanceLieuEnigme = new ArrayList<String>();
		ArrayList<String> listPersonneLieuEnigme = new ArrayList<String>();
		ArrayList<String> listCheminLieuEnigme = new ArrayList<String>();


	
		listPersonneLieuEnigme.add("Sphinx");

		// Lieu Succes
		ArrayList<String> listObjetLieuSucces = new ArrayList<String>();
		ArrayList<String> listConnaissanceLieuSucces = new ArrayList<String>();
		ArrayList<String> listPersonneLieuSucces = new ArrayList<String>();
		ArrayList<String> listCheminLieuSucces = new ArrayList<String>();


	

		// Lieu Echec
		ArrayList<String> listObjetLieuEchec = new ArrayList<String>();
		ArrayList<String> listConnaissanceLieuEchec = new ArrayList<String>();
		ArrayList<String> listPersonneLieuEchec = new ArrayList<String>();
		ArrayList<String> listCheminLieuEchec = new ArrayList<String>();


	

		HashMap<String, ArrayList<String>> InfoObjetLieu = new HashMap<String, ArrayList<String>>();
		HashMap<String, ArrayList<String>> InfoConnaissanceLieu = new HashMap<String, ArrayList<String>>();
		HashMap<String, ArrayList<String>> InfoPersonneLieu = new HashMap<String, ArrayList<String>>();
		HashMap<String, ArrayList<String>> InfoCheminLieu = new HashMap<String, ArrayList<String>>();

		InfoObjetLieu.put(LieuEnigme,listObjetLieuEnigme);
		InfoObjetLieu.put(LieuSucces,listObjetLieuSucces);
		InfoObjetLieu.put(LieuEchec,listObjetLieuEchec);

		InfoConnaissanceLieu.put(LieuEnigme,listConnaissanceLieuEnigme);
		InfoConnaissanceLieu.put(LieuSucces,listConnaissanceLieuSucces);
		InfoConnaissanceLieu.put(LieuEchec,listConnaissanceLieuEchec);

		InfoPersonneLieu.put(LieuEnigme,listPersonneLieuEnigme);
		InfoPersonneLieu.put(LieuSucces,listPersonneLieuSucces);
		InfoPersonneLieu.put(LieuEchec,listPersonneLieuEchec);

		InfoCheminLieu.put(LieuEnigme,listCheminLieuEnigme);
		InfoCheminLieu.put(LieuSucces,listCheminLieuSucces);
		InfoCheminLieu.put(LieuEchec,listCheminLieuEchec);

		
		// Création du joueur
		String nomJoueur = "explorateur";

		// Definition de la taille Maximale du joueur
		int tailleMaxJoueur = 10;
		
		// Definition de la capacité de stockage disponible du joueur
		int CapaStockJoueur = tailleMaxJoueur;
		
		// Lieu courant
		String lieuCourant = "Enigme";
				
		// Initialisation du nombre de tentative
		int tentatives = 3;
		
		// Initialisation des nb de connaissance et la map qui à chaque connaissance associe le nombre d'occurence 
		// de cette connaissance chez le joueur
		int nbConnaissances = 0;
		HashMap<String, Integer> mapConnaissance = new HashMap<String, Integer>();
		
		// Initialisation des nb de connaissance et la map qui à chaque objet associe le nombre d'occurence 
		// de cette objet chez le joueur
		int nbObjet = 0;
		HashMap<String, Integer> mapObjet = new HashMap<String, Integer>();


		Scanner sc = new Scanner(System.in);
		
		
		System.out.println("**** DEBUT DU JEU ! **** \n");
		while (!estJeuFini) {
			// Affichage du menu
			System.out.println("\nVous êtes dans le lieu "+ lieuCourant +", Choisissez votre action");
			System.out.println("1- Afficher les détails sur les connaissances");
			System.out.println("2- Afficher les détails sur les objets obtenus");
			System.out.println("3- Afficher des détails sur le lieu courant");
			int nbOb = (InfoObjetLieu.get(lieuCourant)).size();
    		int nbco = (InfoConnaissanceLieu.get(lieuCourant)).size();
			int nbPersonne = (InfoPersonneLieu.get(lieuCourant)).size();
			for(int i=0; i<nbPersonne; i++) {
				System.out.println((i+4)+"- Interagir avec "+ InfoPersonneLieu.get(lieuCourant).get(i));
			}
			System.out.println((4+nbPersonne) + "- Prendre un objet");
			System.out.println((5+nbPersonne) + "- Déposer un objet");
			System.out.println((6+nbPersonne) + "- Prendre un chemin");
			System.out.println("0- Quitter");
			
			System.out.print("\nIndiquez votre choix : ");
	    	int choice = sc.nextInt();
	    	
	    	if (choice == 0) {
	    		break;
	    	}
	    	if (choice == 1) {
	    		if (nbConnaissances == 0) {
	    			System.out.println("\n"+nomJoueur +" ne possède aucune connaissance !!");
	    		} else {
	    			if (nbConnaissances == 1) {
		    			System.out.println("\n"+nomJoueur + " possède " + " 1 seule connaissance :");
		    		} else {
		    			System.out.println("\n"+nomJoueur + " possède " + nbConnaissances + " connaissances sont les suivantes :");
		    		}
		    		for (Map.Entry connais : mapConnaissance.entrySet()) {
		    	           System.out.println("* " + connais.getValue() + " " + connais.getKey());
	    	        }
		    		System.out.println();
	    		}
	    	} else if (choice == 2) {
	    		if (nbObjet == 0) {
	    			System.out.println("\n"+nomJoueur +" ne possède aucun objet !!");
	    		} else {
	    			if (nbObjet == 1) {
		    			System.out.println("\n"+nomJoueur + " possède " + " 1 seul objet :");
		    		} else {
		    			System.out.println("\n"+nomJoueur + " possède " + nbObjet + " objets sont les suivants :");
		    		}
		    		for (Map.Entry objet : mapObjet.entrySet()) {
		    	           System.out.println("* " + objet.getValue() + " " + objet.getKey());
	    	        }
		    		System.out.println();
	    		}
	    		
	    	} else if (choice == 3) {
	    		System.out.println("Le lieu courant est : " + lieuCourant + " :");
	    		System.out.println("* Il est commposé des objets suivants :");
	    		for(int i=0; i<nbOb; i++) {
					System.out.println("\t- "+ InfoObjetLieu.get(lieuCourant).get(i));
				}
	    		System.out.println("* Il est commposé des connaisances suivantes :");
	    		for(int i=0; i<nbco; i++) {
					System.out.println("\t- "+ InfoConnaissanceLieu.get(lieuCourant).get(i));
				}
	    		System.out.println("* Les personnes présentes sont :");
	    		for(int i=0; i<nbPersonne; i++) {
					System.out.println("\t- "+ InfoPersonneLieu.get(lieuCourant).get(i));
				}
	    	} else if (choice > 3 && choice <(4+nbPersonne)) {
	    		String personneDefie = InfoPersonneLieu.get(lieuCourant).get(choice-4);
	    		System.out.println("Vous allez défier " + personneDefie + " :");
	    		System.out.println("Si la réponse est vrai vous passerez au lieu " + InteractionResultat.get(personneDefie).get(true));
				System.out.println("Sinon vous perdez une tentative !!");
				boolean reponseVrai = false;
	    		while (tentatives > 0 && !reponseVrai) {
					System.out.println(InteractionQuestion.get(personneDefie));
					int i = 1;
					for (Map.Entry choix : (InteractionChoix.get(personneDefie)).entrySet()) {
		    	           System.out.println("\t" + i +"- " + choix.getKey());
		    	           i++;
	    	        }
					System.out.println("\t0- Retour en arrière");
					System.out.print("Indiquez votre choix : ");
	    			int choixReponse = sc.nextInt();
	    			if (choixReponse == 0) {
	    				break;
	    			}
	    			i = 1;
	    			for (Map.Entry choix : (InteractionChoix.get(personneDefie)).entrySet()) {
		    	           if (choixReponse == i)  {
		    	        	   if (choix.getValue().equals(true)) {
		    	        		   System.out.println("Félicitation Vous avez débloqué le chemin suivant !!");
		    	        		   InfoCheminLieu.get(lieuCourant).add(InteractionResultat.get(personneDefie).get(true));
		    	        		   reponseVrai = true;
		    	        		   break;
		    	        	   } else {
		    	        		   System.out.println("Mauvaise réponse, vous perdez une tentative !!");
		    	        		   tentatives --;
		    	        		   System.out.println("Il vous reste " + tentatives + " tentatives\n");
		    	        		   
		    	        	   }
		    	           }
		    	           i++;
	    	        }
	    			
	    			if (tentatives == 0) {
	    				System.out.println("Vous ne pouvez plus avancer vous avez donc le lieu echec");
	    				InfoCheminLieu.get(lieuCourant).add(InteractionResultat.get(personneDefie).get(false));
	    			}					
				}
	    		
	    		
	    	} else if (choice == (4+nbPersonne)) {
	    		int n = (InfoObjetLieu.get(lieuCourant)).size();
	    		while(CapaStockJoueur != 0) {
	    			n = (InfoObjetLieu.get(lieuCourant)).size();
	    			for (int i=0; i<n; i++) {
	    				System.out.println(i + "- Collecter l'objet " + InfoObjetLieu.get(lieuCourant).get(i));	    			
	    			}
	    			System.out.println(n + "- Ne rien collecter ");
	    			System.out.print("Indiquez votre choix : ");
	    			int choixObjet = sc.nextInt();
	    			if (choixObjet != n) {
	    				String objetChoisi = InfoObjetLieu.get(lieuCourant).get(choixObjet);
	    				System.out.println("L'objet "+objetChoisi+" a été collecté ");
	    				CapaStockJoueur--;
	    				nbObjet++;
	    				if (mapObjet.get(objetChoisi) != null) {
	    					int ancienneVal = mapObjet.get(objetChoisi);
	    					mapObjet.replace(objetChoisi, ancienneVal+1);
	    				} else {
	    					mapObjet.put(objetChoisi, 1);
	    				}
	    				
	    				InfoObjetLieu.get(lieuCourant).remove(choixObjet);
	    			} else {
	    				break;
	    			}
	    		}
	    	} else if (choice == (5+nbPersonne)) {
	    		int n = mapObjet.size();
	    		while(nbObjet != 0) {
	    			n = mapObjet.size();
	    			int i=0;
	    			for (Map.Entry objet : mapObjet.entrySet()) {
		    	           System.out.println(i + "- Déposer l'objet " + objet.getKey());
		    	           i++;
	    	        }
	    			System.out.println(n + "- Ne rien déposer ");
	    			System.out.print("Indiquez votre choix : ");
	    			int choixObjet = sc.nextInt();
	    			if (choixObjet != n) {
	    				String objetChoisi = "";
	    				i=0;
	    				for (Map.Entry objet : mapObjet.entrySet()) {
			    	           if (i==choixObjet) {
			    	        	   objetChoisi = (String) objet.getKey();
			    	           }
			    	           i++;
		    	        }
	    				
	    				System.out.println("L'objet "+objetChoisi+" a été déposé ");
	    				CapaStockJoueur++;
	    				nbObjet--;
	    				if (mapObjet.get(objetChoisi) > 1) {
	    					int ancienneVal = mapObjet.get(objetChoisi);
	    					mapObjet.replace(objetChoisi, ancienneVal-1);
	    				} else {
	    					mapObjet.remove(objetChoisi);
	    				}
	    				
	    				(InfoObjetLieu.get(lieuCourant)).add(objetChoisi);
	    			} else {
	    				break;
	    			}
	    		}
	    	} else if (choice == (6+nbPersonne)) {
	    		int nbC = (InfoCheminLieu.get(lieuCourant)).size();
	    		if (nbC == 0) {
	    			System.out.println("\nAucun chemin n'est possible à partir de " + lieuCourant +"!!");
	    		} else {
	    			if (nbC == 1) {
		    			System.out.println("\nLe seul chemin possible à partir de " + lieuCourant + " est  :");
		    		} else {
		    			System.out.println("\nLes chemins possibles à partir de " + lieuCourant + " sont les suivants :");
		    		}
		    		for (int i=0; i<nbC; i++ ) {
		    	           System.out.println(i + "- " + InfoCheminLieu.get(lieuCourant).get(i));
	    	        }
		    		System.out.println(nbC + "- Ne rien choisir");
		    		System.out.print("Indiquez votre choix : ");
	    			int choixChemin = sc.nextInt();
	    			if (choixChemin != nbC) {
	    				lieuCourant = InfoCheminLieu.get(lieuCourant).get(choixChemin);
	    			}
	    		}
	    		
	    	}
	    	if (lieuCourant == LieuEchec || lieuCourant == LieuSucces) {
				estJeuFini = true;
			}
		}
		
		System.out.println("\n" + mapMessageLieu.get(lieuCourant));
		System.out.println("\n\n**** FIN DU JEU ! **** \n");
		System.exit(1);

	}

}
		

