package Graphic;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.*;

public class InterfaceChoixTemps extends JFrame {

	private static final long serialVersionUID = 6444375910808332245L;

	private JLabel JLTemps = new JLabel("Duree de la simulation : (en jours)");

	private JTextField MessageTemps = new JTextField();

	// Creation du Boutton OK
	private  JButton BouttonOk = new JButton("Ok");

	// Creation du Boutton Annuler
	private  JButton BouttonAnnuler = new JButton("Annuler");

	private final ActionListener actionTempsOK = new actionTempsOK();
	
	private final ActionListener actionAnnuler = new actionAnnuler();

	public InterfaceChoixTemps() {
		super("Duree de la simulation");

		InitialiserFenetre();
		AjouterListener();
		this.add(CreerMessage(JLTemps, MessageTemps),BorderLayout.CENTER);
		this.add(sud(),BorderLayout.SOUTH);
	}

	// Initialisation de la fenetre
	private void InitialiserFenetre() {
		this.setDefaultCloseOperation( JFrame.DISPOSE_ON_CLOSE );
		this.setSize(320, 180 );																			
		this.setLocationRelativeTo( null ); 
		this.setLayout( new BorderLayout() );
	}
	
	// Creation du message
	private JPanel CreerMessage(JLabel label, JTextField LeMessage) {
		JPanel dialogue = new JPanel(new FlowLayout());
		dialogue.setLayout(new FlowLayout(FlowLayout.CENTER, 10,10 ));
		dialogue.add(label);
		label.setPreferredSize(new Dimension(250,30));
		dialogue.add(LeMessage);
		LeMessage.setPreferredSize(new Dimension(70,30));
		return dialogue;
	}

	// Creation de la partie bas
	// Elle contient les bouttons Ok et annuler
	private JPanel sud() {
		JPanel dialogue = new JPanel(new FlowLayout());
		dialogue.setLayout(new FlowLayout(FlowLayout.CENTER, 10,10 ));
		dialogue.add(BouttonOk);
		BouttonOk.setPreferredSize(new Dimension(100,30));
		dialogue.add(BouttonAnnuler);
		BouttonAnnuler.setPreferredSize(new Dimension(100,30));
		return dialogue;
	}

	// Ajouter a chaque boutton le Listener associé
	private void AjouterListener() {
		this.MessageTemps.addActionListener(this.actionTempsOK);

		this.BouttonOk.addActionListener(this.actionTempsOK);

		this.BouttonAnnuler.addActionListener(this.actionAnnuler);
	}

	public class actionTempsOK implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			if (MessageTemps.getText().length() != 0) {
				InterfaceSimulation.InitialiserTemps(Integer.parseInt(MessageTemps.getText()));
				InterfacePrincipale.TempsExiste(true);
				dispose();
			}
			else {
				JOptionPane.showMessageDialog(null, "Veuillez remplir la case !");
			}
		}
	}
	
	public class actionAnnuler implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			dispose();
		}
	}
}

