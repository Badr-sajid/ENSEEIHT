import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class RFicheImpl extends UnicastRemoteObject implements RFiche {
	
	private String Nom;
	private String Email;
	
	public RFicheImpl(String Nom, String Email) throws RemoteException {
		super();
		this.Nom = Nom;
		this.Email = Email;
	}

	@Override
	public String getNom() throws RemoteException {
		return this.Nom;
	}

	@Override
	public String getEmail() throws RemoteException {
		return this.Email;
	}

}
