package Graphic;

import java.awt.Color;
import java.awt.Graphics;
import java.util.ArrayList;


import javax.swing.JPanel;

public class cercleTrace extends JPanel {

	private static final long serialVersionUID = -2851411364295604193L;
	private ArrayList<Cercle> listeCercle = new ArrayList<Cercle>();

	public void actualiser() {
		this.update(this.getGraphics());
		this.repaint();
	}

	public void ajoutercercle(Cercle c) {
			this.listeCercle.add(c);
	}

	public void viderliste() {
		this.listeCercle.clear();
	}

	public void modifierRayon(int i, int r) {
		this.listeCercle.get(i).setrayon(r);
	}
	
	public int getRayon(int i) {
		return this.listeCercle.get(i).getrayon();
	}

	@Override
	public void paint(Graphics g) {
		super.paint(g);
		if (this.listeCercle.size() == 0) {
			g.setColor(Color.WHITE);
			g.fillRect(50,50,50,50);
		} else {
			for(int i=0; i<this.listeCercle.size(); i++){
				Cercle c = this.listeCercle.get(i);
				g.setColor(Color.orange);
				if (c.getrayon() > 0) {
					g.fillArc((int) c.getCentre().getX()-c.getrayon()/2, 
							(int) c.getCentre().getY()-c.getrayon()/2, c.getrayon(), c.getrayon(), 0, 360);
				}
			}
		}
	}

	public void afficherListe() {
		for(int i=0; i<this.listeCercle.size(); i++){
			Cercle c = this.listeCercle.get(i);
			System.out.println("centre : (" + c.getCentre().getX() + ", " + c.getCentre().getY() + 
					"), rayon : " + c.getrayon());
		}
	}

}
