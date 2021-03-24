import java.util.concurrent.Semaphore;

public class PhiloSemBloc implements StrategiePhilo {
	
	private Semaphore fourchette[];
	private Semaphore Mutex = new Semaphore(1);

	public PhiloSemBloc (int nbPhilosophes) {
		fourchette = new Semaphore[nbPhilosophes];
		for (int i=0; i<nbPhilosophes; i++) {
			fourchette[i] = new Semaphore(1);
		}
    }
	
	@Override
	public void demanderFourchettes(int no) throws InterruptedException {
		Mutex.acquire();
		fourchette[Main.FourchetteDroite(no)].acquire();
		fourchette[Main.FourchetteGauche(no)].acquire();
		Mutex.release();
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
