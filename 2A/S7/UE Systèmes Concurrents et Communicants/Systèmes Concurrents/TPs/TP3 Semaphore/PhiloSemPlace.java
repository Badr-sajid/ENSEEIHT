import java.util.concurrent.Semaphore;

public class PhiloSemPlace implements StrategiePhilo {
	
	private Semaphore fourchette[];
	private Semaphore Table;

	public PhiloSemPlace (int nbPhilosophes) {
		fourchette = new Semaphore[nbPhilosophes];
		for (int i=0; i<nbPhilosophes; i++) {
			fourchette[i] = new Semaphore(1);
		}
		this.Table = new Semaphore(nbPhilosophes-1);
    }
	
	@Override
	public void demanderFourchettes(int no) throws InterruptedException {
		Table.acquire();
		fourchette[Main.FourchetteDroite(no)].acquire();
		fourchette[Main.FourchetteGauche(no)].acquire();
		Table.release();
	}

	@Override
	public void libererFourchettes(int no) throws InterruptedException {
		fourchette[Main.FourchetteDroite(no)].release();
		fourchette[Main.FourchetteGauche(no)].release();
	}

	@Override
	public String nom() {
		return "Implantation Sémaphores, version Bloc";
	}

}

