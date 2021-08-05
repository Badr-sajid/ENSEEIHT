using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System;
using UnityEngine.UI;

public class Trajectoire : MonoBehaviour
{

    List<Vector3> position = new List<Vector3>();
    List<Quaternion> rotation = new List<Quaternion>();
    List<Vector3> P2DRAW = new List<Vector3>();
    List<float> T = new List<float>();
    List<float> X = new List<float>();
    List<float> Y = new List<float>();
    List<float> Z = new List<float>();
    // Echantillonage des pas temporels
    List<float> tToEval = new List<float>();
    int indice = 0;


    float pas = 1/100;

    // Start is called before the first frame update
    void Start()
    {
        GameObject[] Point = GameObject.FindGameObjectsWithTag("Point");
        (T,tToEval) = buildParametrisationTchebycheff(position.Count(), pas);

        for (int i = 0; i < position.Count(); i++)
        {
            X.Add(Point[i].transform.position[0]);
            Y.Add(Point[i].transform.position[1]);
            Z.Add(Point[i].transform.position[2]);
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (indice < position.Count()-1 && t<=1)
        {
            Vector3 p = applyLagrangeParametrisation(X,Y,Z,T,tToEval[indice]);
            transform.position = p;
            transform.rotation = Quaternion.Slerp(Point[indice].transform.rotation, Point[indice+1].transform.rotation, t)
        }
    }

    private float lagrange(float x, List<float> X, List<float> Y)
    {
        float L_i = 1.0f;
        float result = 0.0f;
        for (int i = 0; i < X.Count; ++i) {
            L_i = 1;
            for (int j =0; j < X.Count; ++j) {
                if (i != j) {
                    L_i = L_i * (x-X[j])/(X[i]-X[j]);
                }
            }
            result = result + L_i*Y[i];
        }
        return result;
    }

    Vector3 applyLagrangeParametrisation(List<float> X, List<float> Y, List<float> Z, List<float> T, float t)
    {   
        float xpoint = lagrange(t, T, X);
        float ypoint = lagrange(t, T, Y);
        float zpoint = lagrange(t, T, Z);
        Vector3 pos = new Vector3(xpoint, ypoint, zpoint);
        return pos;
    }

    (List<float>, List<float>) buildParametrisationTchebycheff(int nbElem, float pas)
    {
        // Vecteur des pas temporels
        List<float> T = new List<float>();
        // Echantillonage des pas temporels
        List<float> tToEval = new List<float>();

        // Construction des pas temporels
        for (int i = 0; i < nbElem; ++i) {
            T.Add((float)Math.Cos(((2*i+1)*Math.PI)/(2*(nbElem-1) + 2)));
        }

        // Construction des échantillons
        tToEval.Add(T.Min());
        int cmpt = 1;
        while (tToEval.Last() <= T.Max()) {
            tToEval.Add(T.Min() + cmpt*pas);
            cmpt++;
        }

        return (T, tToEval);
    }




    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.blue;
        for(int i = 0; i < P2DRAW.Count - 1; ++i)
        {
            Gizmos.DrawLine(P2DRAW[i], P2DRAW[i+1]);

        }
    }
}
