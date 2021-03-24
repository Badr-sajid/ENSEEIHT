package Graphic;

import javax.swing.JFrame;

@SuppressWarnings("serial")
public class TraceurCourbes extends JFrame{

	public Courbe courbe;

	public TraceurCourbes(){
		super("Courbe");
		this.setSize(500, 500);

		this.courbe=new Courbe();

		this.getContentPane().add(this.courbe);

		this.setVisible(false);

		this.setDefaultCloseOperation( JFrame.DO_NOTHING_ON_CLOSE );
	}

}