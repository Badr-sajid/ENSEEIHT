package Graphic;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.*;

import projet_long_virus.Virus;

public class InterfaceChoixVirus extends JFrame{

	private static final long serialVersionUID = -3606889020291861942L;

// Definition des variables

	private Virus virus_Utilisateur;

	private JLabel JLnomVirus = new JLabel("Nom du virus :");
	
	private JLabel JLPersonneInfecte = new JLabel("Taux de contamination (ou R0) :");
	
	private JLabel JLTauxMortalite = new JLabel("Taux de mortalite :");
	
	private JLabel JLGuerison = new JLabel("Temps de guerison moyen :");
	
	private JLabel JLIncubation = new JLabel("Temps d'incubation :");
		
	private JTextField MessageNom = new JTextField();
	
	private JTextField MessageContamination = new JTextField();
	
	private JTextField MessageMortalite = new JTextField();

	private JTextField MessageGuerison = new JTextField();
	
	private JTextField MessageIncubation = new JTextField();
	
	private JButton BouttonOk = new JButton("Ok");
	
	private JButton BouttonAnnuler = new JButton("Annuler");

	private final ActionListener actionNomOK = new actionNomOK();

	private final ActionListener actionContaminationOK = new actionContaminationOK();

	private final ActionListener actionMortaliteOK = new actionMortaliteOK();

	private final ActionListener actionGuerisonOK = new actionGuerisonOK();

	private final ActionListener actionIncubationOK = new actionIncubationOK();

	private final ActionListener actionOK = new actionOK();
	
	private final ActionListener actionAnnuler = new actionAnnuler();

	// Constructeur de la fenetre ChoixVirus
	public InterfaceChoixVirus() {
		super( "Reglage du virus" );
		
		InitialiserFenetre();
		AjouterListener();
		this.add(new JScrollPane(AjouterMessages()),BorderLayout.CENTER);
		this.add(sud(),BorderLayout.SOUTH);
	}

	private void InitialiserFenetre() {
		this.setDefaultCloseOperation( JFrame.DISPOSE_ON_CLOSE );
		this.setSize( 450, 300 );																			
		this.setLocationRelativeTo( null ); 
		this.setLayout( new BorderLayout() );
	}

	// Ajouter a chaque bootton le Listener associé
	private void AjouterListener() {

		this.MessageNom.addActionListener(this.actionNomOK);
		
		this.MessageContamination.addActionListener(this.actionContaminationOK);
		
		this.MessageMortalite.addActionListener(this.actionMortaliteOK);
		
		this.MessageGuerison.addActionListener(this.actionGuerisonOK);
		
		this.MessageIncubation.addActionListener(this.actionIncubationOK);
				
		this.BouttonOk.addActionListener(this.actionOK);
		
		this.BouttonAnnuler.addActionListener(this.actionAnnuler);
	}

	// Creation de la partie bas
	// Elle contient les bouttons Ok et Annuler
 	private JPanel sud() {
		JPanel dialogue = new JPanel(new FlowLayout());
		dialogue.setLayout(new FlowLayout(FlowLayout.CENTER, 10,10 ));
		dialogue.add(BouttonOk);
		BouttonOk.setPreferredSize(new Dimension(100,30));
		dialogue.add(BouttonAnnuler);
		BouttonAnnuler.setPreferredSize(new Dimension(100,30));
		return dialogue;
	}

 	// Ajouter tous les messages associes dans un JPanel
	private JPanel AjouterMessages() {
		JPanel d = new JPanel(new FlowLayout());
		d.setLayout(new GridLayout(5,1,0,20));
		d.add(CreerMessage(JLnomVirus, MessageNom));
		d.add(CreerMessage(JLPersonneInfecte, MessageContamination));
		d.add(CreerMessage(JLTauxMortalite, MessageMortalite));		
		d.add(CreerMessage(JLGuerison, MessageGuerison));
		d.add(CreerMessage(JLIncubation, MessageIncubation));
		return d;
	}

	// Creer un message
	private JPanel CreerMessage(JLabel label, JTextField LeMessage) {
		JPanel dialogue = new JPanel(new FlowLayout());
		dialogue.setLayout(new FlowLayout(FlowLayout.CENTER, 10,10 ));
		dialogue.add(label);
		label.setPreferredSize(new Dimension(200,30));
		dialogue.add(LeMessage);
		LeMessage.setPreferredSize(new Dimension(70,30));
		return dialogue;
	}

	// Retourne le taux de contamination
	public int getContamination() throws Exception{
		boolean ok = false;
		int Contamination = 0;
		while (ok == false) {
			try {
				Contamination = Integer.parseInt(MessageContamination.getText());
				MessageContamination.setBorder(new JTextField().getBorder());
				ok = true;
			} catch (NumberFormatException e) {
				MessageContamination.setBorder(BorderFactory.createLineBorder(Color.decode("#FF0000")));
				throw e;
			}
		}
		return Contamination;
	}

	// Retourne le taux de mortalite
	public double getMortalite() throws Exception {
		boolean ok = false;
		double Mortalite = 0;
		while (ok == false) {
			try {
				Mortalite = (double) Float.parseFloat(MessageMortalite.getText());
				MessageMortalite.setBorder(new JTextField().getBorder());
				ok = true;
			} catch (NumberFormatException e) {
				MessageMortalite.setBorder(BorderFactory.createLineBorder(Color.decode("#FF0000")));
				throw e;
			}
		}
		return Mortalite;
		
	}

	// Retourne le temps de guerison
	public int getGuerison() throws Exception {
		boolean ok = false;
		int Guerison = 0;
		while (ok == false) {
			try {
				Guerison = Integer.parseInt(MessageGuerison.getText());
				MessageGuerison.setBorder(new JTextField().getBorder());
				ok = true;
			} catch (NumberFormatException e) {
				MessageGuerison.setBorder(BorderFactory.createLineBorder(Color.decode("#FF0000")));
				throw e;
			}
		}
		return Guerison;  	
	}

	// Retourne le taux d'incubation
	public int getIncubation() throws Exception {
		boolean ok = false;
		int incubation = 0;
		while (ok == false) {
			try {
				incubation = Integer.parseInt(MessageIncubation.getText());
				MessageIncubation.setBorder(new JTextField().getBorder());
				ok = true;
			} catch (NumberFormatException e) {
				MessageIncubation.setBorder(BorderFactory.createLineBorder(Color.decode("#FF0000")));
				throw e;
			}
		}
		return incubation;
	}

	public void actionOk() {
		// Tester si tous les champs sont pleins
		if (MessageNom.getText() != " " 
				&& MessageContamination.getText().length() != 0 
				&& MessageGuerison.getText().length() != 0
				&& MessageIncubation.getText().length() != 0
				&& MessageMortalite.getText().length() != 0) {
			try {
				virus_Utilisateur = new Virus(getGuerison(),getContamination(),getIncubation(),getMortalite());
				InterfaceSimulation.InitialiserVirus(virus_Utilisateur);
				InterfacePrincipale.VirusExiste(true);
				dispose();
			} catch (Exception e) {
				JOptionPane.showMessageDialog(null, "Veuillez entrer des valeurs adequates !");
			}
		} else {
			JOptionPane.showMessageDialog(null, "Veuillez remplir tous les cases !");
		}
	}	

	// Gerer la clique sur Entrer apres avoir entrer le nom
	public class actionNomOK implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			KeyboardFocusManager manager = KeyboardFocusManager.getCurrentKeyboardFocusManager();
			manager.getFocusOwner().transferFocus();
		}
	}

	// Gerer la clique sur Entrer apres avoir entrer le taux de contamination
	public class actionContaminationOK implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			KeyboardFocusManager manager = KeyboardFocusManager.getCurrentKeyboardFocusManager();
			manager.getFocusOwner().transferFocus();
		}
	}

	// Gerer la clique sur Entrer apres avoir entrer le taux de mortalite
	public class actionMortaliteOK implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			KeyboardFocusManager manager = KeyboardFocusManager.getCurrentKeyboardFocusManager();
			manager.getFocusOwner().transferFocus();
		}
	}

	// Gerer la clique sur Entrer apres avoir entrer le temps de guerison
	public class actionGuerisonOK implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			KeyboardFocusManager manager = KeyboardFocusManager.getCurrentKeyboardFocusManager();
			manager.getFocusOwner().transferFocus();
		}
	}

	// Gerer la clique sur Entrer apres avoir entrer le taux d'incubation
	public class actionIncubationOK implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			actionOk();
		}
	}

	// Gerer la clique sur Entrer et le boutton OK
	public class actionOK implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			actionOk();		
		}
	}

	// Gerer la clique sur le boutton Annuler
	public class actionAnnuler implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			dispose();
		}
	}

}
