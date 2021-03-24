import java.awt.Color;
/** Cerle modélise un cerle géometrique dans un plan dans un repère cartesien.
 * On peut effectuer plusieur opération sur un cercle comme le translater,
 * changer sa couleur.
 * On peut déterminer si un point est à l'interieur ou à l'exterieur du cerle.
 * Un cerle peut être créer de trois différentes méthodes.
 * On peut déterminer l'air, la surface et la couleur du cerle.
 *
 * @author  Sajid Badr
*/
public class Cercle implements Mesurable2D {
    /** Le centre du cercle.
    */
    private Point centre;
    /** Le rayon du cerle.
    */
    private double rayon;
    /** La couleur du cercle.
    */
    private Color couleur;
    /** Constante pi.
    */
    public static final double PI = Math.PI;
    /** Construire un cercle à partir de son centre et de son rayon.
	 * @param vc centre
	 * @param vr rayon
	 */
    public Cercle(Point vc, double vr) {
    	assert vr > 0;
    	assert vc != null;
        Point p = new Point(vc.getX(), vc.getY());
        this.centre = p;
        this.rayon = vr;
        this.couleur = Color.blue;
    }

    /** Construire un cerle à partir de deux points.
	 * @param p1 premier point.
	 * @param p2 deuxième point.
	 */
	public Cercle(Point p1, Point p2) {
		assert p1 != null;
    	assert p2 != null;
    	assert p1.distance(p2) != 0;
        double v1 = (p1.getX() + p2.getX()) / 2;
        double v2 = (p1.getY() + p2.getY()) / 2;
        Point pcentre = new Point(v1, v2);
        this.centre = pcentre;
        this.rayon = p1.distance(p2) / 2;
        this.couleur = Color.blue;
}

    /** Construire un cerle à partir de deux points.
	 * @param p1 premier point.
	 * @param p2 deuxième point.
     * @param c couleur du cercle.
	 */
    public Cercle(Point p1, Point p2, Color c) {
    	this(p1, p2);
    	assert c != null;
        this.couleur = c;
	}

    /** Construire un cercle à partir de deux points.
	 * @param p1 le centre.
	 * @param p2 la circonférence.
     * @return le centre.
	 */
	public static Cercle creerCercle(Point p1, Point p2) {
		assert p1 != null;
    	assert p2 != null;
    	assert p1.distance(p2) != 0;
        return new Cercle(p1, p1.distance(p2));
	}

    /** Obternir le centre du cercle.
     * @return centre du cercle.
     */
    public Point getCentre() {
        Point pcentre = new Point(this.centre.getX(), this.centre.getY());
    	return pcentre;
    }

    /** Obtenir le rayon du cercle.
     * @return rayon du cercle.
     */
    public double getRayon() {
        return this.rayon;
    }

    /** Obternir la couleur du cercle.
     * @return couleur du cercle.
     */
    public Color getCouleur() {
        return this.couleur;
    }

    /** Obternir le diamètre du cercle.
     * @return diamètre du cercle.
     */
    public double getDiametre() {
        return 2 * this.rayon;
    }

    /** Obternir le périmètre du cercle.
     * @return périmètre du cercle.
     */
    public double perimetre() {
	    return 2 * PI * this.rayon;
    }

    /** Obternir l'air du cercle.
     * @return air du cercle.
     */
    public double aire() {
         return PI * this.rayon * this.rayon;
    }

    /** Afficher le cercle sous la forme de Cr@(a,b).
     * @return la representation String du cercle.
     */
    public String toString() {
		return "C" + this.rayon + "@" + this.centre;
	}

    /** Afficher le cercle. */
	public void afficher() {
		System.out.print(this);
	}


    /** Déterminer si un point est à l'interieur ou à l'exterieur du cercle.
     * @param p le point.
     * @return l'existence du point dans le cercle.
     */
    public boolean contient(Point p) {
    	assert p != null;
        return this.centre.distance(p) <= this.rayon;
    }

    /** Translater le cercle.
	* @param dx déplacement suivant l'axe des X.
	* @param dy déplacement suivant l'axe des Y.
	*/
	public void translater(double dx, double dy) {
       this.centre.translater(dx, dy);
	}

    /** Changer le centre du cercle.
	  * @param vc nouveau centre.
	  */
	public void setCentre(Point vc) {
		assert vc != null;
		this.centre = new Point(vc.getX(), vc.getY());
    }


    /** Changer le rayon du cercle.
	  * @param vr nouveau rayon.
	  */
	public void setRayon(double vr) {
		assert vr > 0;
		this.rayon = vr;
    }

    /** Changer la couleur du cercle.
	  * @param vc nouvelle couleur.
	  */
	public void setCouleur(Color vc) {
		assert vc != null;
		this.couleur = vc;
    }

    /** Changer le diamètre du cercle.
	  * @param vd nouveau diamètre.s
	  */
	public void setDiametre(double vd) {
		assert vd > 0;
        this.rayon = vd / 2;
    }

}
