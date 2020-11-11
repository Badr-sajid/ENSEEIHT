import java.util.concurrent.Semaphore;

public class PhiloSemVoisin implements StrategiePhilo {

	private Semaphore[] Philo;
	private Semaphore Mutex = new Semaphore(1);
	private EtatPhilosophe[] etat;
	

    public PhiloSemVoisin (int nbPhilosophes) {
    	this.Philo = new Semaphore[nbPhilosophes];
    	this.etat = new EtatPhilosophe[nbPhilosophes];
		for (int i=0; i<nbPhilosophes; i++) {
			this.Philo[i] = new Semaphore(1);
			this.etat[i] = EtatPhilosophe.Pense;
		}
    }

    /** Le philosophe no demande les fourchettes.
     *  Précondition : il n'en possède aucune.
     *  Postcondition : quand cette méthode retourne, il possède les deux fourchettes adjacentes à son assiette. */
    public void demanderFourchettes (int no) throws InterruptedException {
    	boolean mange = false;
    	while(!mange){
    		this.Mutex.acquire();
    		this.etat[no] = EtatPhilosophe.Demande;
    		
    		if (!peutManger(no))  {
    			this.Mutex.release();
    			this.Philo[no].acquire();
    		} else {
    			this.etat[no] = EtatPhilosophe.Mange;
    			this.Mutex.release();
    			mange = true;
    		}
    	}
    }

    /** Le philosophe no rend les fourchettes.
     *  Précondition : il possède les deux fourchettes adjacentes à son assiette.
     *  Postcondition : il n'en possède aucune. Les fourchettes peuvent être libres ou réattribuées à un autre philosophe. */
    public void libererFourchettes (int no) throws InterruptedException {
    	this.Mutex.acquire();
    	this.etat[no] = EtatPhilosophe.Pense;
    	
    	if (peutManger(Main.PhiloDroite(no))) {
    		this.Philo[Main.PhiloDroite(no)].release();
    	}
    	if (peutManger(Main.PhiloGauche(no))) {
    		this.Philo[Main.PhiloGauche(no)].release();
    	}
    	this.Mutex.release();
    }

    /** Nom de cette stratégie (pour la fenêtre d'affichage). */
    public String nom() {
        return "Implantation Sémaphores, version dépendant de l'état des voisins";
    }
    
    private boolean peutManger(int no) {
    	return this.etat[no] == EtatPhilosophe.Demande 
				&& this.etat[Main.PhiloDroite(no)] != EtatPhilosophe.Mange 
				&& this.etat[Main.PhiloGauche(no)] != EtatPhilosophe.Mange;
    }

}

