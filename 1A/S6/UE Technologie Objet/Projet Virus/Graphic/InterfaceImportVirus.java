package Graphic;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.*;

import projet_long_virus.Virus;

public class InterfaceImportVirus extends JFrame {

	private static final long serialVersionUID = 1L;

	// Definition des variables
	private Virus virus_Utilisateur;

	private JTextArea text = new JTextArea("");

	private Virus virus_faible = new Virus(3, 1, 2, 0);

	private Virus virus_normal = new Virus(5, 2, 4, 0.2);

	private Virus virus_dangeureux = new Virus(10, 7, 9, 0.7);

	private JComboBox<String> ImportVirus;

	private JLabel textImportVirus = new JLabel("Veuillez choisir le virus");

	private JTextArea textVirusfaible;

	private JTextArea textVirusNormal;

	private JTextArea textVirusDangereux;

	private boolean choixEstFait = false;

	private Choix actionChoix = new Choix();

	private JButton BouttonOk = new JButton("Ok");

	private ActionListener actionOK = new actionOK();

	private JButton BouttonAnnuler = new JButton("Annuler");

	private ActionListener actionAnnuler = new actionAnnuler();


	// Constructeur de la fenetre ImportVirus
	public InterfaceImportVirus() {
		super( "Choisir un virus predefini" );
		
		InitialiserFenetre();
		AjouterListener();
		InitialiserTextVirus();
		EditerChoix();
		this.add(nord(),BorderLayout.NORTH);
		this.text.setEditable(false);
		this.add(text,BorderLayout.CENTER);
		this.add(sud(),BorderLayout.SOUTH);
	}

	private void InitialiserFenetre() {
		this.setDefaultCloseOperation( JFrame.DISPOSE_ON_CLOSE );
		this.setSize(400, 300);																			
		this.setLocationRelativeTo(null); 
		this.setLayout(new BorderLayout());
	}

	// Creation d'un JPanel du haut
	// Contenat le choix de l'un des virus predefini
	private JPanel nord() {
		JPanel d = new JPanel(new FlowLayout());
		d.add(textImportVirus);
		d.add(ImportVirus);
		return d;
	}
	
	private String construireText(Virus v) {
		return "\nSes caracteristiques : "
				+ "\nR0              (ou taux de contamination) = " + v.getR0()
				+ "\nTemps de guerison moyen (en jours) = " + v.getTempsGuerison()
				+ "\nTemps d'incubation              (en jours) = " + v.getTempsIncubation()
				+ "\nTaux de mortalite                                      = " + v.getTauxMortalite();
	}

	// Ajouter une description a chaque virus
	private void InitialiserTextVirus() {
		textVirusfaible = new JTextArea("Ce virus n'est pas dangeureux.\n" 
				+ "Il ne tue pas et la contamination est faible\n"
				+ construireText(virus_faible));
		textVirusNormal = new JTextArea("Ce virus n'est pas tres dangeureux.\n"
				+ "Le taux de mortalite est faible mais il se propage un peu facilement\n"
				+ construireText(virus_normal));
		textVirusDangereux = new JTextArea("Ce virus est dangeureux.\n"
				+ "Le taux de mortalite est eleve il se propage facilement\n"
				+ construireText(virus_dangeureux) );
	}

	// Initialiser le choix
	private void EditerChoix() {
		this.textImportVirus.setFont(new Font("Arial",Font.BOLD,14));
		this.textImportVirus.setOpaque(false);
		String[] typeVirus= { "Selectionner ...","Virus Faible", "Virus Normal", "Virus Dangereux"};
		this.ImportVirus = new JComboBox<String>(typeVirus);
		this.ImportVirus.addActionListener(actionChoix);
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

	private void AjouterListener() {
		this.BouttonOk.addActionListener(this.actionOK);
		this.BouttonAnnuler.addActionListener(this.actionAnnuler);
	}
	
	// Modifier le text a afficher en text choisi
	private void TextChois(JTextArea textchoisi) {
		text.setText(textchoisi.getText());	
	}

	// Modifier le virus choisi
	public void VirusChoisi(Virus viruschois) {
		virus_Utilisateur = viruschois;
	}

	// Choisir le virus est texte a afficher en selectionnant
	// le virus parmis les virus proposes
	public class Choix implements ActionListener{
	    public void actionPerformed(ActionEvent e) {

	    	// Recuperer le choix
	    	String option = (String) ImportVirus.getSelectedItem();

	    	// Editer le choix
	    	switch (option) {
				case "Virus Faible": {
					TextChois(textVirusfaible);
					VirusChoisi(virus_faible);
					choixEstFait = true;
					break;
				}
				case "Virus Normal": {
					TextChois(textVirusNormal);
					VirusChoisi(virus_normal);
					choixEstFait = true;
					break;
				}
				case "Virus Dangereux": {
					TextChois(textVirusDangereux);
					VirusChoisi(virus_dangeureux);
					choixEstFait = true;
					break;
				}
			}
	      }               
	  }


	// Gerer la clique sur Entrer et le boutton OK
	public class actionOK implements ActionListener {
		public void actionPerformed(ActionEvent e) {	
			if (choixEstFait) {
				InterfaceSimulation.InitialiserVirus(virus_Utilisateur);
				InterfacePrincipale.VirusExiste(true);
			}
			dispose();
		}
	}

	// Gerer la clique sur le boutton Annuler
	public class actionAnnuler implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			dispose();
		}
	}

}
