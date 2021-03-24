package Graphic;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.*;

import projet_long_virus.*;



public class InterfaceSimulation extends JFrame implements Runnable, ActionListener {

	private static final long serialVersionUID = -714093729841498863L;

	// Variables en relation avec la simulation
	private static Virus virusUtilisateur;

	private static int NB_ITERATIONS;	// Nombre de jours de simulation

	private static final int TEMPS_SIMU = 100;	// Temps d'attente entre chaque jours

	private Simulateur simulateur;

	private Continent continent;

	private int Jour_i = 0;			// Le jours acctuel

	private boolean running = false;

	// Variables en relation avec la courbe
	private JCheckBox afficherCourbe = new JCheckBox("Afficher courbe");

	private boolean afficher = false;

	private cercleTrace traceur = new cercleTrace();

	private TraceurCourbes courbetraceur = new TraceurCourbes();
	
	private JCheckBox afficherConfinement = new JCheckBox("Confinement");

	public static boolean confinement = false;
	
	private JCheckBox affichervaccin = new JCheckBox("Vaccin");

	public static boolean vaccin = false;

	// Ajout des statistiques
	private JLabel JLNbinefecte = new JLabel("Actuellement Infectes :");

	private JTextField infecte = new JTextField();

	private JLabel JLNretablie = new JLabel("Total Retablis :");

	private JTextField retablie = new JTextField();

	private JLabel JLNbMort = new JLabel("Total Morts :");

	private JTextField mort = new JTextField();

	private JLabel JLNbCas = new JLabel("Total Cas Confirmes :");

	private JTextField casConfirmes = new JTextField();

	// Les actions
	private final AbstractAction actionCheckboxCourbe = new actionCheckboxCourbe("check");
	
	private final AbstractAction actionCheckboxConfinement = new actionCheckboxConfinement("check");

	private final AbstractAction actionCheckboxVaccin = new actionCheckboxVaccin("check");

	// Les bouttons
	private JButton BoutonStart = new JButton("Start");

	private JButton BoutonPause = new JButton("Pause");

	private JButton BoutonReset = new JButton("Reset");

	private JButton BoutonQuitter = new JButton("Quitter");

	// Fin de la declaration des variables

	// Constructeur de la fenetre pricipale
	public InterfaceSimulation() {

		super( "SIMULATION VIRUS" );

		this.simulateur = initialiserSimulateur();
		this.continent = InitialiseurContinent.initialiserContinent();
		initialiserTraceur();

		InitialiserFenetre();

		JPanel container = (JPanel)  this.getContentPane();
		container.setLocation(50, 50);
		container.setLayout(new BorderLayout());

		this.add(traceur,BorderLayout.CENTER);
		traceur.add(CreerCarte());
		container.add(Bas(),BorderLayout.SOUTH);

	}

	private void InitialiserFenetre() {
		this.setDefaultCloseOperation( JFrame.DISPOSE_ON_CLOSE );
		this.setSize(1100, 700);
		this.setLocationRelativeTo(null);
		this.setUndecorated(true);
		this.setLayout( new BorderLayout() );
	}

	private JLabel CreerCarte() {
		JLabel Carte;
		ImageIcon img = new ImageIcon("image/carte.jpg");
		Carte = new JLabel(img);
		Carte.setOpaque(false);
		return Carte;
	}

	// Creation du Panel bas contenant Les Bouttons est les Statistics
	private JPanel Bas() {
		JPanel bas = new JPanel(new BorderLayout());
		bas.add(Boutton(), BorderLayout.CENTER);
		bas.add(Statistic(), BorderLayout.SOUTH);
		return bas;
	}

	// Creation du Panel Boutton contenant Les Bouttons
	private JPanel Boutton() {
		JPanel Boutton = new JPanel();
		Boutton.setLayout( new FlowLayout(FlowLayout.CENTER, 50,10 ) );
		Boutton.setOpaque(false);

		afficherCourbe.setPreferredSize(new Dimension(120,30));
		Boutton.add(afficherCourbe);
		afficherCourbe.addActionListener(actionCheckboxCourbe);
		if (confinement) {
			afficherConfinement.setPreferredSize(new Dimension(100,30));
			Boutton.add(afficherConfinement);
			afficherConfinement.addActionListener(actionCheckboxConfinement);
		}
		if (vaccin) {
			affichervaccin.setPreferredSize(new Dimension(100,30));
			Boutton.add(affichervaccin);
			affichervaccin.addActionListener(actionCheckboxVaccin);
		}

		BoutonStart.setPreferredSize(new Dimension(100,30));
		Boutton.add(BoutonStart);
		BoutonStart.addActionListener(this);

		BoutonPause.setPreferredSize(new Dimension(100,30));
		Boutton.add(BoutonPause);
		BoutonPause.addActionListener(this);
		
		BoutonReset.setPreferredSize(new Dimension(100,30));
		Boutton.add(BoutonReset);
		BoutonReset.addActionListener(this);

		BoutonQuitter.setPreferredSize(new Dimension(100,30));
		Boutton.add(BoutonQuitter);
		BoutonQuitter.addActionListener(this);

		return Boutton;
	}

	// Creation du Panel bas contenant Les Statistics
	private JPanel Statistic() {
			JPanel Statistic = new JPanel();
			Statistic.setLayout( new FlowLayout(FlowLayout.CENTER, 70,10 ));
			Statistic.setOpaque(true);
			Statistic.add(JLNbinefecte);
			Statistic.add(CreerMessage(JLNbinefecte, infecte));
			Statistic.add(CreerMessage(JLNretablie, retablie));
			Statistic.add(CreerMessage(JLNbMort, mort));
			Statistic.add(CreerMessage(JLNbCas, casConfirmes));

			return Statistic;
		}
		
	private JPanel CreerMessage(JLabel label, JTextField LeMessage) {
		JPanel dialogue = new JPanel(new FlowLayout());
		dialogue.setLayout(new FlowLayout(FlowLayout.CENTER, 0,10 ));
		dialogue.add(label);
		label.setPreferredSize(new Dimension(100,30));
		LeMessage.setEditable(false);
		dialogue.add(LeMessage);
		LeMessage.setPreferredSize(new Dimension(100,30));
		return dialogue;
	}
	
// Initialisation des parametre pour commencer la simulation
	private void initialiserTraceur() {
		int n = this.continent.getSize();
		Pays p;
		int x, y;
		for(int i=0; i<n; i++) {
			// recuperer les coordonnes des pays sur la map
			p = this.continent.getContinent().get(i);
			x = p.getX();
			y = p.getY();
			this.traceur.ajoutercercle(new Cercle(new Point(x,y), 0, Color.red));
		}
	}

	private Simulateur initialiserSimulateur() {
		return new Simulateur(InterfaceSimulation.virusUtilisateur);
	}

	public static void InitialiserVirus(Virus virus) {
		virusUtilisateur = new Virus(virus.getTempsGuerison(), virus.getR0(), virus.getTempsIncubation(), virus.getTauxMortalite());
	}

	public static void InitialiserTemps(int nb) {
		InterfaceSimulation.NB_ITERATIONS = nb;
	}
	
	/*
	private void initialiserContinent() {
		this.continent = new Continent("Europe");
		Pays USA = new Pays("USA", 300000000, 265, 260,this.continent);
		Pays France = new Pays("France", 65000000, 550, 225,this.continent);
		Pays Maroc = new Pays("Maroc", 30000000, 515, 290,this.continent);
		Pays Chine = new Pays("Chine", 1300000000, 820, 300,this.continent);
		this.continent.ajouterPays(France);
		this.continent.ajouterPays(USA);
		this.continent.ajouterPays(Maroc);
		this.continent.ajouterPays(Chine);
		initialiserPays();
	}

	
	// Apres un reset, on remet le nb_infecte a 1 dans tous les pays du continent
	private void initialiserPays() {
		for(Pays p: this.continent.getContinent()) {
			p.setNbInfectes(0);
			p.setNbMort(0);
			p.setNbRetablis(0);
			p.setNbSains(p.getPopTotal());
			p.setNbIncubation(0);
		}
		Pays p = this.continent.getContinent().get(1);
		p.setNbInfectes(1);
		p.setNbSains(p.getPopTotal()-1);
		
		
	}
	*/
	
	// Traitement des Bouttons
	@Override
	public void actionPerformed(ActionEvent e) {
		if (e.getSource().equals(BoutonStart)) {
			if (!running) {
				BoutonStart.setText("Start");
				BoutonPause.setText("Pause");
				courbetraceur.dispose();
				courbetraceur.setVisible(afficher);
				running = true;
				Thread t = new Thread(this);
				t.start();
			}
		}
		else if (e.getSource().equals(BoutonQuitter)) {
			running = false;
			int reponse = JOptionPane.showConfirmDialog(this,
					"Voulez-vous vraiment quitter la simulation ?",
					"Confirmation",
					JOptionPane.YES_NO_OPTION,
					JOptionPane.QUESTION_MESSAGE);
			if(reponse == JOptionPane.YES_OPTION ){
				JOptionPane.showMessageDialog(null, "Fin !");
				dispose();
				courbetraceur.dispose();
			}
		} else if (e.getSource().equals(BoutonPause)) {
			if(running) {
				running = false;
				BoutonStart.setText("Resume");
		}
		} else if (e.getSource().equals(BoutonReset)) {
			running = false;
			int reponse = JOptionPane.showConfirmDialog(this,
	                "Voulez-vous vraiment redemarrer la simulation ?",
	                "Confirmation",
	                JOptionPane.YES_NO_OPTION,
	                JOptionPane.QUESTION_MESSAGE);
			BoutonStart.setText("Resume");
			if(reponse == JOptionPane.YES_OPTION ){

				BoutonStart.setText("Start");
				infecte.setText(Integer.toString(0));
				retablie.setText(Integer.toString(0));
				mort.setText(Integer.toString(0));
				casConfirmes.setText(Integer.toString(0));

				courbetraceur.dispose();
				courbetraceur = new TraceurCourbes();
				this.Jour_i = 0;
				InitialiseurContinent.initialiserPays(this.continent);
				this.traceur.viderliste();
				initialiserTraceur();
				this.traceur.actualiser(); 

			}
		}
	}

// // Gerer les checkbox
	public class actionCheckboxCourbe extends AbstractAction {
		private static final long serialVersionUID = -8431132970058967602L;

		public actionCheckboxCourbe(String text) {
			super(text);
		}

		@Override
		public void actionPerformed(ActionEvent e) {
			JCheckBox cbLog = (JCheckBox) e.getSource();
			if (cbLog.isSelected()) {
				afficher = true;
				if(afficher) {
				}
			} else {
				afficher = false;
			}
		}
	}

	public class actionCheckboxConfinement extends AbstractAction {
		private static final long serialVersionUID = -8431132970058967602L;

		public actionCheckboxConfinement(String text) {
			super(text);
		}

		@Override
		public void actionPerformed(ActionEvent e) {
			JCheckBox cbLog = (JCheckBox) e.getSource();
			if (cbLog.isSelected()) {
				simulateur.SetConfinement(true);
			} else {
				simulateur.SetConfinement(false);
			}
		}
	}

	public class actionCheckboxVaccin extends AbstractAction {
		private static final long serialVersionUID = -8431132970058967602L;

		public actionCheckboxVaccin(String text) {
			super(text);
		}

		@Override
		public void actionPerformed(ActionEvent e) {
			JCheckBox cbLog = (JCheckBox) e.getSource();
			if (cbLog.isSelected()) {
				simulateur.SetVaccinc(true);
			} else {
				simulateur.SetVaccinc(false);
			}
		}
	}
	
	// Calculer l'etape suivante
	public void step() {
        Integer infectes = 0;
        Integer retablis = 0;
        Integer morts = 0;
		// Calculer l'etape suivante de la simulation
		for(int i = 0; i < this.continent.getSize(); i++) {
			Pays p = this.continent.getContinent().get(i); // recuperer le pays en position i
			this.simulateur.simuler(p); //simuler le pays en position i 
			this.traceur.modifierRayon(i, (int) Math.log10(p.getNbInfectes())*2);
			// Calculer le nombre total de chaque parametre
			infectes = infectes + (int) p.getNbInfectes();
			retablis = retablis + (int) p.getNbRetablis();
			morts = morts + (int) p.getNbMort();
		}

		// modifier l'affichage
		infecte.setText(Integer.toString(infectes));
		retablie.setText(Integer.toString(retablis));
		mort.setText(Integer.toString(morts));
		casConfirmes.setText(Integer.toString(infectes + retablis + morts));
	}

	public void run() {
		while (running && Jour_i < InterfaceSimulation.NB_ITERATIONS) {
			step();
			traceur.actualiser();
			courbetraceur.courbe.ajouterPoint(new Point(Jour_i, this.continent.getContinent().get(1).getNbInfectes()));
			courbetraceur.setVisible(afficher);
			if(afficher) {
				courbetraceur.courbe.acctualiser();
			}
			try {
				Thread.sleep(TEMPS_SIMU);
			} catch (Exception e){
				e.printStackTrace();
			}
			Jour_i ++;
            if (Jour_i == InterfaceSimulation.NB_ITERATIONS) {
                JOptionPane.showMessageDialog(null, "Fin de la simulation!");
            }
		}
	}

}


