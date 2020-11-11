import java.util.concurrent.atomic.AtomicBoolean;

public class ProcessusSynchronized {

  public static void main(String[] args) {
    int n = 20;
    Thread[] t = new Thread[n];

      for (int i = 0; i<n; i++){
        t[i] = new Thread(new Proc(),Integer.toString(i));
      }
      for (int i = 0; i<n; i++){
        t[i].start();
      }
  }
}

class Proc implements Runnable {

    public void run() {
        for ( ; ; ) {
            System.out.println("Thread " + Thread.currentThread().getName() + " attend SC ");
            synchronized(this){
                System.out.println("Thread " + Thread.currentThread().getName() + " en SC ");
                System.out.println("Thread " + Thread.currentThread().getName() + " hors SC ");
            }
      }
    }

}
