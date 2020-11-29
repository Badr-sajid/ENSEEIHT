import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.Map;
import java.rmi.registry.*;

public class CarnetImpl extends UnicastRemoteObject  implements Carnet {
	
	private Map<String, RFiche> map;
	static int[] tab_ports = {4000, 4001};
	
	public CarnetImpl() throws RemoteException {
		super();
		this.map = new HashMap<String, RFiche>();
	}

	@Override
	public void Ajouter(SFiche sf) throws RemoteException {
		RFiche fiche = new RFicheImpl(sf.getNom(), sf.getEmail());
		this.map.put(sf.getNom(), fiche);
	}

	@Override
	public RFiche Consulter(String n, boolean forward) throws RemoteException {
		return this.map.get(n);
	}

	public static void main(String[] args) {
		try {
			int num_serv = Integer.parseInt(args[0]);
			int num_port = tab_ports[num_serv - 1];
			Carnet carnet = new CarnetImpl();
			Registry registry = LocateRegistry.createRegistry(num_port);
			String Url = "//localhost:"+num_port+"/Carnet"+num_serv;
			Naming.rebind(Url, carnet);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
