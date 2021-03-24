import java.util.concurrent.Semaphore;

public class PhiloSemBaseInterblocage implements StrategiePhilo {
	
	private Semaphore fourchette[];

	public PhiloSemBaseInterblocage (int nbPhilosophes) {
		fourchette = new Semaphore[nbPhilosophes];
		for (int i=0; i<nbPhilosophes; i++) {
			fourchette[i] = new Semaphore(1);
		}
    }
	
	@Override
	public void demanderFourchettes(int no) throws InterruptedException {
		fourchette[Main.FourchetteDroite(no)].acquire();
		Thread.sleep(1000);
		fourchette[Main.FourchetteGauche(no)].acquire();
	}

	@Override
	public void libererFourchettes(int no) throws InterruptedException {
		fourchette[Main.FourchetteDroite(no)].release();
		fourchette[Main.FourchetteGauche(no)].release();
	}

	@Override
	public String nom() {
		return "Implantation Sémaphores, version de bas";
	}

}
