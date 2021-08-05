using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

//////////////////////////////////////////////////////////////////////////
///////////////// Classe qui gère la subdivision via DCJ /////////////////
//////////////////////////////////////////////////////////////////////////
public class DeCasteljauSubdivision : MonoBehaviour
{
    // Pas d'échantillonage pour affichage
    public float pas = 1 / 100;
    // Nombre de subdivision dans l'algo de DCJ
    public int NombreDeSubdivision = 3;
    // Liste des points composant la courbe
    private List<Vector3> ListePoints = new List<Vector3>();
    // Donnees i.e. points cliqués
    public GameObject Donnees;
    // Coordonnees des points composant le polygone de controle
    private List<float> PolygoneControleX = new List<float>();
    private List<float> PolygoneControleY = new List<float>();

    //////////////////////////////////////////////////////////////////////////
    // fonction : DeCasteljauSub                                            //
    // semantique : renvoie la liste des points composant la courbe         //
    //              approximante selon un nombre de subdivision données     //
    // params : - List<float> X : abscisses des point de controle           //
    //          - List<float> Y : odronnees des point de controle           //
    //          - int nombreDeSubdivision : nombre de subdivision           //
    // sortie :                                                             //
    //          - (List<float>, List<float>) : liste des abscisses et liste //
    //            des ordonnées des points composant la courbe              //
    //////////////////////////////////////////////////////////////////////////
    (List<float>, List<float>) DeCasteljauSub(List<float> X, List<float> Y, int nombreDeSubdivision)
    {
        int n = X.Count;
        List<float> Q_x = new List<float>();
        List<float> Q_y = new List<float>();

        List<float> R_x = new List<float>();
        List<float> R_y = new List<float>();

        Q_x.Add(X[0]);
        Q_y.Add(Y[0]);

        R_x.Add(X[n - 1]);
        R_y.Add(Y[n - 1]);

        for (int i = n - 2; i >= 0; --i)
        {
            for (int j = 0; j < i; j++)
            {
                X[j] = (float)(0.5 * X[j + 1] + 0.5 * X[j]);
                Y[j] = (float)(0.5 * Y[j + 1] + 0.5 * Y[j]);
            }
            Q_x.Add(X[0]);
            Q_y.Add(Y[0]);

            R_x.Add(X[i]);
            R_y.Add(Y[i]);

        }

        R_x.Reverse();
        R_y.Reverse();

        if (nombreDeSubdivision == 1)
        {
            
            R_x.RemoveAt(0);
            R_y.RemoveAt(0);

            Q_x.AddRange(R_x);
            Q_y.AddRange(R_y);

            return (Q_x, Q_y);
        }
        else
        {
            List<float> Q1_x = new List<float>();
            List<float> Q1_y = new List<float>();

            List<float> R1_x = new List<float>();
            List<float> R1_y = new List<float>();

            (Q1_x, Q1_y) = DeCasteljauSub(Q_x, Q_y, nombreDeSubdivision - 1);
            (R1_x, R1_y) = DeCasteljauSub(R_x, R_y, nombreDeSubdivision - 1);

            Q1_x.AddRange(R1_x);
            Q1_y.AddRange(R1_y);

            return (Q1_x, Q1_y);
        }

    }

    //////////////////////////////////////////////////////////////////////////
    //////////////////////////// NE PAS TOUCHER //////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    void Start()
    {

    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return))
        {
            var ListePointsCliques = GameObject.Find("Donnees").GetComponent<Points>();
            if (ListePointsCliques.X.Count > 0)
            {
                for (int i = 0; i < ListePointsCliques.X.Count; ++i)
                {
                    PolygoneControleX.Add(ListePointsCliques.X[i]);
                    PolygoneControleY.Add(ListePointsCliques.Y[i]);
                }
                List<float> XSubdivision = new List<float>();
                List<float> YSubdivision = new List<float>();

                (XSubdivision, YSubdivision) = DeCasteljauSub(ListePointsCliques.X, ListePointsCliques.Y, NombreDeSubdivision);
                for (int i = 0; i < XSubdivision.Count; ++i)
                {
                    ListePoints.Add(new Vector3(XSubdivision[i], -4.0f, YSubdivision[i]));
                }
            }

        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        for (int i = 0; i < PolygoneControleX.Count - 1; ++i)
        {
            Gizmos.DrawLine(new Vector3(PolygoneControleX[i], -4.0f, PolygoneControleY[i]), new Vector3(PolygoneControleX[i + 1], -4.0f, PolygoneControleY[i + 1]));
        }

        Gizmos.color = Color.blue;
        for (int i = 0; i < ListePoints.Count - 1; ++i)
        {
            Gizmos.DrawLine(ListePoints[i], ListePoints[i + 1]);
        }
    }
}
