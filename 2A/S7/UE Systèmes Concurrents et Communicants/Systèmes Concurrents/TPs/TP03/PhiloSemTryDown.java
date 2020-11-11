import java.util.concurrent.Semaphore;

public class PhiloSemTryDown implements StrategiePhilo {

	private Semaphore fourchette[];

	public PhiloSemTryDown(int nbPhilosophes) {
		fourchette = new Semaphore[nbPhilosophes];
		for (int i=0; i<nbPhilosophes; i++) {
			fourchette[i] = new Semaphore(1);
		}
    }
	
	@Override
	public void demanderFourchettes(int no) throws InterruptedException {
		Boolean DeuxFourchette = false;
		
		while (!DeuxFourchette) {
			fourchette[Main.FourchetteDroite(no)].acquire();
			if (!fourchette[Main.FourchetteGauche(no)].tryAcquire()) {
				fourchette[Main.FourchetteDroite(no)].release();
			}
			DeuxFourchette = true;
		}
		
	}

	@Override
	public void libererFourchettes(int no) throws InterruptedException {
		fourchette[Main.FourchetteDroite(no)].release();
		fourchette[Main.FourchetteGauche(no)].release();
	}

	@Override
	public String nom() {
		return "Implantation Sémaphores, version TryDown()";
	}

}