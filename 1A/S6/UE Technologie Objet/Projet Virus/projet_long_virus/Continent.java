package projet_long_virus;

import java.util.ArrayList;

public class Continent {
	
	private ArrayList<Pays> Continent = new ArrayList<Pays>();
	//Nayel AJOUT
	private int NBR_PAYS_MAX=200;
	private double [][] ProbaInfectionContient;
	private int NbrPays;
	private int [][] NbrVoyageurEntrePaysParJour;
	
	private String nom;

	
	public Continent(String n) {
		this.nom = n;
		//Nayel AJOUT : Nbr de nays et matrice initialisee a 0
		this.NbrPays=0;
		this.ProbaInfectionContient=new double[NBR_PAYS_MAX][NBR_PAYS_MAX];
		for (int i=0;i<NBR_PAYS_MAX;i++) {
			for (int j=0; j<NBR_PAYS_MAX;j++) {
				this.ProbaInfectionContient[i][j]=0;
			}
		}
		this.NbrVoyageurEntrePaysParJour= new int[NBR_PAYS_MAX][NBR_PAYS_MAX];
	}

	// ajouter un pays au continent
	public void ajouterPays(Pays p) {
		this.Continent.add(p);
		//Nayel Ajout
		this.NbrPays=this.NbrPays+1;
		int colonne=this.NbrPays;
		// On ajoute une proba sur la nouvelle colonne
		for(int ligne=0; ligne<this.NbrPays;ligne++) {
			this.ProbaInfectionContient[ligne][colonne-1]=Math.random();
		}
		// On ajoute le nombre de voyageurs par jour avec ce nouveau pays
		// Ce tableau se lit: 
		// NbrVoyageurEntrePaysParJour[pays1][pays2]= nbr voyageurs pays1 vers pays2
		// On prendra arbitrairement NbrVoyageurEntrePaysParJour[pays1][pays2]= 0.5% du pays1
		for(int ligne=0; ligne<this.NbrPays;ligne++) {
			this.NbrVoyageurEntrePaysParJour[ligne][colonne-1]=(int) Math.abs(this.Continent.get(ligne).getPopTotal()*0.005);
		}
		int ligne=this.NbrPays;
		for(int Colonne=0;Colonne<this.NbrPays;Colonne++) {
			this.NbrVoyageurEntrePaysParJour[ligne-1][Colonne]=(int) Math.abs(this.Continent.get(Colonne).getPopTotal()*0.005);
		}
		
	}
	
	//Nayel AJOUT
	public double[][] getProbaInfectionContinent() {
		return this.ProbaInfectionContient;
	}
	//Nayel AJOUT
	public int[][] getNbrVoyageurEntrePaysParJour() {
		return this.NbrVoyageurEntrePaysParJour;
	}	
	//Nayel AJOUT 
	public int getNbrPays() {
		return this.NbrPays;
	}
	
	// enlever un pays d'un continent
	public void supprimerPays(Pays p) {
		this.Continent.remove(p);
	}
	
	public int getSize() {
		return Continent.size();
	}
	
	
	 // acceder a la liste des Pays du Continent
	 public ArrayList<Pays> getContinent() {
		 return this.Continent;
	 }
	 
	 public String getNom() {
		 return this.nom;
	 }
	 
	 public void setNom(String n) {
		 this.nom = n;
	 }

}
