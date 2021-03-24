package projet_long_virus;

import java.util.ArrayList;

public class Pays{
	
	private String nom;
	private double NbSains;
	private double NbInfectes = 0;
	private double NbRetablis = 0;
	private double NbIncubation = 0;
	private double PopTotal;
	private double NbMort = 0;
	private ArrayList<Pays> Voisins;
	private int x;
	private int y;
	// Nayel AJOUT
	private int identifiant;
	private int CompteurIdentifiant=0;
	private Continent continent;

	
	
	
	// Constructeur
	public Pays(String nom, int PopTotal, int x, int y,/*Nayel Ajout*/Continent continent) {
		this.setNom(nom);
		this.PopTotal = PopTotal;
		this.NbSains = PopTotal;
		this.x = x;
		this.y = y;
		
		//Nayel AJOUT
		this.identifiant=CompteurIdentifiant;
		CompteurIdentifiant=CompteurIdentifiant+1;
		this.continent = continent;
		
		
	}
	
	//Nayel AJOUT
	public int getId() {
		return this.identifiant;
	}
	//Nayel AJOUT
	public Continent getContinent() {
		return this.continent;
	}
	

	
	// Getter et Setter
	public double getNbSains() {
		return NbSains;
	}
	public void setNbSains(double nbSains) {
		NbSains = nbSains;
	}
	
	public double getNbInfectes() {
		return NbInfectes;
	}
	public void setNbInfectes(double nbInfectes) {
		NbInfectes = nbInfectes;
	}
	
	public double getNbRetablis() {
		return NbRetablis;
	}
	public void setNbRetablis(double nbRetablis) {
		NbRetablis = nbRetablis;
	}
	
	public double getNbIncubation() {
		return NbIncubation;
	}
	public void setNbIncubation(double nbIncubation) {
		NbIncubation = nbIncubation;
	}
	
	public double getPopTotal() {
		return PopTotal;
	}
	public void setPopTotal(double popTotal) {
		PopTotal = popTotal;
	}
	
	public double getNbMort() {
		return NbMort;
	}
	public void setNbMort(double nbMort) {
		NbMort = nbMort;
	}
	
	
	public ArrayList<Pays> getVoisins() {
		return Voisins;
	}

	public void ajouterVoisin(Pays p) {
		Voisins.add(p);
	}
	
	public Pays getVoisin_i(int Voisin_i) {
		return Voisins.get(Voisin_i);
	}
	
	
	public String getNom() {
		return nom;
	}

	public void setNom(String nom) {
		this.nom = nom;
	}
	
	public int getX() {
		return this.x;
	}
	
	public int getY() {
		return this.y;
	}
}
