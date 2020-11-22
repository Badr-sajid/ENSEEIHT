import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Random;

public class LoadBalancer extends Thread {

	static int ports[] = {8081,8082};
	static String hosts[] = {"localhost","localhost"};
	static int nbHosts = 2;
	static Random rand = new Random();

	Socket input;

	public LoadBalancer (Socket s) {
		input = s;
	}

	public void run() {
		try {
	  		int i = rand.nextInt(nbHosts);
			Socket output = new Socket(hosts[i], ports[i]);
			InputStream clt_in_stream = input.getInputStream();
	  		OutputStream clt_out_stream = 
	  				input.getOutputStream();
	  		OutputStream srv_out_stream = output.getOutputStream();
	  		InputStream srv_in_stream = output.getInputStream();
	
			byte[] buffer = new byte[8192];
			int bytesRead = clt_in_stream.read(buffer);
			srv_out_stream.write(buffer, 0, bytesRead);
			bytesRead = srv_in_stream.read(buffer);
			clt_out_stream.write(buffer, 0, bytesRead);
	
	   } catch (Exception e) {
		   e.printStackTrace();
	   }
		}
	
	public static void main(String args[]) {
	  try {	
		ServerSocket ss = new  ServerSocket(8080);
		while (true) {
	  		Thread t = new LoadBalancer(ss.accept());
			t.start();
	}

	  } catch (Exception e)
	  { e.printStackTrace();}
	}
}
