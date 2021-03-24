// Time-stamp: <08 Apr 2008 11:35 queinnec@enseeiht.fr>

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/** Lecteurs/rédacteurs
 * stratégie d'ordonnancement: priorité aux lecteurs,
 * implantation: avec un moniteur. */
public class LectRed_PrioLecteur implements LectRed
{
	// Protection des variables partagées
    private Lock moniteur;

    // Variables condition
    private Condition PasEcriture;
    private Condition EcriturePossible;

    // Variables d'etat
    private boolean EcritureEnCours;
    private int nbL;
    private int nbA;

    public LectRed_PrioLecteur() {
    	this.moniteur = new ReentrantLock();
    	this.PasEcriture = moniteur.newCondition();
    	this.EcriturePossible = moniteur.newCondition();
    	this.EcritureEnCours = false;
    	this.nbL = 0;
    	this.nbA = 0;
    }

    public void demanderLecture() throws InterruptedException {
    	this.moniteur.lock();

    	// Predicat d'acceptation
    	while (this.EcritureEnCours) {
    		this.nbA++;
    		this.PasEcriture.await();
    		this.nbA--;
    	}
    	this.nbL++;
    	this.moniteur.unlock();
    }

    public void terminerLecture() throws InterruptedException {
    	this.moniteur.lock();
    	this.nbL--;

    	if (this.nbL == 0 && this.nbA == 0) {
    		this.EcriturePossible.signal();
    	}

    	this.moniteur.unlock();
    }

    public void demanderEcriture() throws InterruptedException {
    	this.moniteur.lock();

    	// Predicat d'acceptation
    	if (this.nbL > 0 || EcritureEnCours || this.nbA > 0) {
    		this.EcriturePossible.await();
    	}
    	this.EcritureEnCours = true;
    	this.moniteur.unlock();
    }

    public void terminerEcriture() throws InterruptedException {
    	this.moniteur.lock();
    	this.EcritureEnCours = false;

    	if (this.nbA == 0) {
    		this.EcriturePossible.signal();
    	} else {
    		this.PasEcriture.signalAll();
    	}

    	this.moniteur.unlock();
    }

    public String nomStrategie() {
        return "Stratégie: Priorité Lecteurs.";
    }
}
