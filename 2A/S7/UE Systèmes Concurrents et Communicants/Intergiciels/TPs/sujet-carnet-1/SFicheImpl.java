
public class SFicheImpl implements SFiche {
	
	private String Nom;
	private String Email;
	
	public SFicheImpl(String Nom, String Email) {
		this.Nom = Nom;
		this.Email = Email;
	}

	@Override
	public String getNom() {
		return this.Nom;
	}

	@Override
	public String getEmail() {
		return this.Email;
	}

}
