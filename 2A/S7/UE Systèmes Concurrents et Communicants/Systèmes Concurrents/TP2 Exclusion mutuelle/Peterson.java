public class Peterson {

    static int tour = 0;
    static boolean [] demande = {false,false};

    public static void main(String[] args) {
        Thread t1 = new Thread(new Proc(),"1");
        Thread t2 = new Thread(new Proc(),"0");
        t1.start();
        t2.start();
    }
}

class Proc implements Runnable {
	int id, di;
    public void run() {
     id =  Integer.parseInt(Thread.currentThread().getName());
     di = (id+1) % 2;
        for ( ; ; ) {
            System.out.println("Thread " + id + " attend SC " + di);
            entrer();
            System.out.println("Thread " + Thread.currentThread().getName() + " en SC ");
            System.out.println("Thread " + Thread.currentThread().getName() + " hors SC ");
            sortir();
        }
    }

    void entrer() {
        Peterson.demande[id] = true;
        Peterson.tour = di ;
        while ((Peterson.tour == di) && (Peterson.demande[di])) {;}
    }

    void sortir() {
        Peterson.demande[id] =false;
    }
}
