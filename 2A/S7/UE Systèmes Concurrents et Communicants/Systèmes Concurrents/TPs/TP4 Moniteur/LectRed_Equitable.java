//Time-stamp: <08 Apr 2008 11:35 queinnec@enseeiht.fr>

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/** Lecteurs/rédacteurs
* stratégie d'ordonnancement: Equitable,
* implantation: avec un moniteur. */
public class LectRed_Equitable implements LectRed
{
	// Protection des variables partagées
    private Lock moniteur;

    // Variables condition
    private Condition Acces;
    private Condition Sas;

    // Variables d'etat
    private boolean EcritureEnCours;
    private Boolean SasPlein;
    private int nbL;
    private int nbA;


    public LectRed_Equitable() {
    	this.moniteur = new ReentrantLock();
    	this.Acces = moniteur.newCondition();
    	this.Sas = moniteur.newCondition();
    	this.EcritureEnCours = false;
    	this.SasPlein = false;
    	this.nbL = 0;
    	this.nbA = 0;
    }

    public void demanderLecture() throws InterruptedException {
    	this.moniteur.lock();

    	// Predicat d'acceptation
    	if (this.EcritureEnCours || this.nbA > 0 || this.SasPlein) {
    		this.nbA++;
    		this.Acces.await();
    		this.nbA--;
    	}
    	this.nbL++;
    	this.Acces.signal();
    	this.moniteur.unlock();
    }

	 public void terminerLecture() throws InterruptedException {
		 this.moniteur.lock();
	    	this.nbL--;
	    	if (this.nbL==0) {
	    		if (this.SasPlein) {
	    			this.Sas.signal();
	    		} else {
	    			this.Acces.signal();
	    		}
	    	}
	    	this.moniteur.unlock();
	 }

	 public void demanderEcriture() throws InterruptedException {
    	this.moniteur.lock();

    	// Predicat d'acceptation
    	if (EcritureEnCours || this.nbL > 0) {
    		this.nbA++;
    		this.Acces.await();
    		this.nbA--;
    	}
    	if (nbL > 0) {
			this.nbA++;
    		this.SasPlein = true;
    		this.Sas.await();
			this.SasPlein = false;
			this.nbA--;
    	}
    	this.EcritureEnCours = true;
    	this.moniteur.unlock();
	 }

	 public void terminerEcriture() throws InterruptedException {
    	this.moniteur.lock();

    	this.EcritureEnCours = false;
    	this.Acces.signal();
    	this.moniteur.unlock();
	 }

	 public String nomStrategie() {
	     return "Stratégie: Equitable.";
	 }
}
