package Graphic;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.*;
import javax.swing.plaf.nimbus.NimbusLookAndFeel;

public class InterfacePrincipale extends JFrame{

	private static final long serialVersionUID = -714093729841498863L;
	
	// Definition des variables
	private static boolean VirusExiste = false;

	private static boolean TempsExiste = false;

	private JButton BoutonChoixVirus = new JButton("Reglage Virus (Manuel)");

	private JButton BoutonImpoterVirus = new JButton("Choix Virus Predefini");

	private JButton BoutonImpoterDate = new JButton("Reglage Duree de Simulation");

	private JButton BoutonQuitter = new JButton("Quitter");

	private JButton BoutonLancerSimul = new JButton("Lancer la Simulation");

	private JComboBox<String> ChoixSimul;

	private JLabel text = new JLabel("Veullez choisir la simulation");

	private final ActionListener actionLancerSimul = new actionLancerSimul();

	private final ActionListener actionQuitter = new actionQuitter();

	private final ActionListener actionChoixVirus = new actionChoixVirus();

	private final ActionListener actionImportVirus = new actionImportVirus();

	private final ActionListener actionChoixTemps = new actionChoixTemps();

	private Choix actionChoix = new Choix();

	// Constructeur de la fenetre pricipale
	public InterfacePrincipale() {
		super( "SIMULATION VIRUS" );
		
		InitialiserFenetre();
		JPanel nord = Nord();
		JPanel droite = Droite();
		EditerChoix();
		Positionner(nord, droite);
		AjouterTous(nord, droite);
	}

	private void InitialiserFenetre() {
		this.setDefaultCloseOperation( JFrame.DISPOSE_ON_CLOSE );
		this.setExtendedState(JFrame.MAXIMIZED_BOTH);
		this.setUndecorated(true);
		this.setLayout( new BorderLayout() );
	}

	// Creation du menu
	private JMenuBar CreerMenu() {
		JMenuBar menu =  new JMenuBar();
		JMenu menu_virus =  new JMenu("Virus");
		// JMenuItem nouvelle_partie = new JMenuItem("Nouvelle partie");
		JMenuItem lancerSim = new JMenuItem("Lancer la Simulation");
		JMenuItem ChoixVirus = new JMenuItem("Reglage Virus (Manuel)");
		JMenuItem ImpoterVirus = new JMenuItem("Choix Virus Predefini");
		JMenuItem choixtemps = new JMenuItem("Reglage Duree Simulation");
		JMenuItem quitter = new JMenuItem("Quitter");

		// menu_virus.add(nouvelle_partie);
		menu_virus.add(lancerSim);
		menu_virus.add(ChoixVirus);
		menu_virus.add(ImpoterVirus);
		menu_virus.add(choixtemps);
		menu_virus.add(quitter);

		lancerSim.addActionListener(actionLancerSimul);
		ChoixVirus.addActionListener(actionChoixVirus);
		ImpoterVirus.addActionListener(actionImportVirus);
		choixtemps.addActionListener(actionChoixTemps);
		quitter.addActionListener(this.actionQuitter);
		
		menu.add(menu_virus);
		return menu;
	}

	// Creer le fond d'ecran
	private JLabel CreerBackground() {
		JLabel background;
		ImageIcon img = new ImageIcon("image/background.jpg");		
		background = new JLabel("",img,JLabel.CENTER);		
		background.setOpaque(false);
		return background;
	}

	// Ajouter tous les composants dans la fenetre
	private void AjouterTous(JPanel nord, JPanel droite) {
		this.setJMenuBar(CreerMenu());
		this.add(droite);
		this.add(nord);
		this.add(this.text);
		this.add(this.ChoixSimul);
		this.add(CreerBackground());
	}

	// Creation du Panel Nord contenant Les Bouttons :
	// Choix Virus, Chois virus predefini et ajuster le temps
	private JPanel Nord() {
		JPanel nord = new JPanel();

		nord.setLayout( new GridLayout(1, 3, 200,0) );
		
		BoutonChoixVirus.addActionListener(this.actionChoixVirus);
		nord.add(BoutonChoixVirus);
		
		nord.add(BoutonImpoterVirus);
		BoutonImpoterVirus.addActionListener(this.actionImportVirus);
		
		BoutonImpoterDate.addActionListener(this.actionChoixTemps);
		nord.add(BoutonImpoterDate);
		nord.setOpaque(false);
		
		return nord;
	}

	// Creation du Panel Droite contenant Les Bouttons pour lancer 
	// la simulation et le boutton Quitter
	private JPanel Droite() {
		JPanel droite = new JPanel();
		droite.setLayout( new GridLayout(2, 1, 0,50) );
		droite.setOpaque(false);
		BoutonLancerSimul.addActionListener(this.actionLancerSimul);
		droite.add(BoutonLancerSimul);
		BoutonQuitter.addActionListener(this.actionQuitter);
		droite.add(BoutonQuitter);
		
		return droite;
	}

	// Positionner les Panels
	private void Positionner(JPanel nord, JPanel droite) {
		Toolkit tk = Toolkit.getDefaultToolkit();
		int xSize = ((int) tk.getScreenSize().getWidth());
		int ySize = ((int) tk.getScreenSize().getHeight());
		nord.setBounds(10, 10, xSize-20, 50);
		droite.setBounds(xSize-370, ySize-300, 300, 200);
		this.text.setBounds(65,  ySize-290, 300, 30);
		this.ChoixSimul.setBounds(20,  ySize-250, 300, 30);
	}

	// Initialiser le Choix du type de la simulation
	private void EditerChoix() {
		this.text.setForeground(Color.white);
		this.text.setFont(new Font("Arial",Font.BOLD,14));
		this.text.setOpaque(false);
		String[] typeSim= {"Simulation sans Confinement", "Simulation avec Confinement", 
				"Simulation sans Vaccin", "Simulation avec Vaccin"};
		this.ChoixSimul = new JComboBox<String>(typeSim);
		this.ChoixSimul.addActionListener(actionChoix);
	}

	// Modifier si le virus existe
	public static void VirusExiste(boolean b) {
		VirusExiste = b;
	}

	// Modifier si le temps est choisi
	public static void TempsExiste(boolean b) {
		TempsExiste = b;
	}

// Ajouter les actions de chaque boutton
	
	// Gerer la clique le boutton pour choisir les parametres du virus
	private class actionChoixVirus implements ActionListener {
		public void actionPerformed(ActionEvent e) {
				InterfaceChoixVirus Mafenetre;
				Mafenetre = new InterfaceChoixVirus();
				Mafenetre.setVisible(true);
		}
	}

	// Gerer la clique le boutton ajuster le temps de la simulation
	private class actionChoixTemps implements ActionListener {
		public void actionPerformed(ActionEvent e) {
				InterfaceChoixTemps Mafenetre;
				Mafenetre = new InterfaceChoixTemps();
				Mafenetre.setVisible(true);
		}
	}

	// Gerer la clique le boutton pour choisir un virus predefini
	private class actionImportVirus implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			try {
				UIManager.setLookAndFeel( new NimbusLookAndFeel() );
				InterfaceImportVirus Mafenetre = new InterfaceImportVirus();		
				Mafenetre.setVisible(true);
			} catch (Exception f) {
				f.printStackTrace();
			}
		}
	}
	
	// Gerer la clique le boutton pour lancer Simulation
	private class actionLancerSimul implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			if (!VirusExiste) {
				JOptionPane.showMessageDialog(null, "Veuillez completer votre choix !");
			} else {
				try {
					// Si on ne choisi pas le temps la simulation et toujours possible 
					// mais avec un temps par defaut egal a 400
					if (!TempsExiste) {
						InterfaceSimulation.InitialiserTemps(400);
					}
					InterfaceSimulation Mafenetre;
					Mafenetre = new InterfaceSimulation();
					Mafenetre.setVisible(true);
				} catch (Exception e1) {
					e1.printStackTrace();
				}		
			}
		}
	}

	// Gerer le choix du type de simulation
	public class Choix implements ActionListener{
	    public void actionPerformed(ActionEvent e) {

	    	String option = (String) ChoixSimul.getSelectedItem();
	    	switch (option) {
				case "Simulation avec Confinement": {
					InterfaceSimulation.confinement = true;
					break;
				}
				case "Simulation sans Confinement": {
					InterfaceSimulation.confinement = false;
					break;
				}
				case "Simulation avec Vaccin": {
					InterfaceSimulation.vaccin = true;
					break;
				}
				case "Simulation sans Vaccin": {
					InterfaceSimulation.vaccin = false;
					break;
				}
			}
	      }               
	  }

	// Gerer la clique sur le boutton Quitter
	private class actionQuitter implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			JOptionPane.showMessageDialog(null, "Fin !");
			System.exit(0);
		}
	}

}

