import java.util.concurrent.Semaphore;

public class PhiloSemClassesOrdonnees implements StrategiePhilo {

	private Semaphore fourchette[];
	private int nbPhilosophes;

	public PhiloSemClassesOrdonnees (int nbPhilosophes) {
		this.nbPhilosophes = nbPhilosophes;
		fourchette = new Semaphore[nbPhilosophes];
		for (int i=0; i<nbPhilosophes; i++) {
			fourchette[i] = new Semaphore(1);
		}
    }
	
	@Override
	public void demanderFourchettes(int no) throws InterruptedException {
		if (no == this.nbPhilosophes-1) {
			fourchette[Main.FourchetteGauche(no)].acquire();
			fourchette[Main.FourchetteDroite(no)].acquire();
		}
		else {	
			fourchette[Main.FourchetteDroite(no)].acquire();
			fourchette[Main.FourchetteGauche(no)].acquire();
		}
	}

	@Override
	public void libererFourchettes(int no) throws InterruptedException {
		fourchette[Main.FourchetteDroite(no)].release();
		fourchette[Main.FourchetteGauche(no)].release();
	}

	@Override
	public String nom() {
		return "Implantation Sémaphores, version classes ordonnées";
	}

}
