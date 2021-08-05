﻿using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using UnityEngine.UI;

//////////////////////////////////////////////////////////////////////////
///////////////// Classe qui gère les polys de Bernstein /////////////////
//////////////////////////////////////////////////////////////////////////
public class Bernstein : MonoBehaviour
{

    // Nombre de polynmes de Bernstein a dessiner
    public int nombrePolynomesBernstein = 1;
    // Slider : permet de choisir le nombre de poly depuis la simulation
    public Slider slider;
    // pas d'échantillonage pour affichage
    private float pas = 0.01f;
    // Liste des couleurs pour affichage
    private Color[] listeCouleurs = new Color[] { Color.blue, Color.cyan, Color.green, Color.magenta, Color.red, Color.yellow };
    // Listes des différents points composants les polynomes de Bernstein
    // ListePoints[0] : liste des points composant le poly de Bernstein 0 sur n-1
    private List<List<Vector2>> ListePoints = new List<List<Vector2>>();

    //////////////////////////////////////////////////////////////////////////
    // fonction : buildPolysBernstein                                       //
    // semantique : remplit le vecteur ListePoints avec les listes des points//
    //              composant les polys de Bernstein                        //
    // params : aucun                                                       //
    // sortie : aucune                                                      //
    //////////////////////////////////////////////////////////////////////////
    void buildPolysBernstein() {
        List<float> t = buildEchantillonnage();
        List<Vector2> lpoints = new List<Vector2>() ;
        int n = nombrePolynomesBernstein - 1;
        for (int i = 0; i <= nombrePolynomesBernstein -1; i++) {
            for (int j=0;j<t.Count;j++) {
                float valeur = KparmiN(i,n)*(float)Math.Pow(t[j],i)*(float)Math.Pow((1-t[j]),n-i);
                Vector2 point = new Vector2(t[j],valeur); 
                lpoints.Add(point);
            }
        }
        ListePoints.Add(lpoints);
    }

    ////////////////////////////////////////////////////////////////////////////
    // Fonction KparmiN                                                       //
    // Semantique : etant donnés k et n, calcule k parmi n                     //
    // Entrees : - int k                                                      //
    //           - int n                                                      //
    // Sortie : k parmi n                                                     //
    ////////////////////////////////////////////////////////////////////////////
    
    long KparmiN(int k, int n)
    {

        decimal result = 1;
        for (int i = 1; i <= k; i++)
        {
            result *= n - (k - i);
            result /= i;
        }
        return (long)result;
    }
    
    //////////////////////////////////////////////////////////////////////////
    // fonction : buildEchantillonnage                                      //
    // semantique : construit un échantillonnage regulier                   //
    // params : aucun                                                       //
    // sortie :                                                             //
    //          - List<float> tToEval : échantillonnage regulier            //
    //////////////////////////////////////////////////////////////////////////
    List<float> buildEchantillonnage()
    {
        List<float> tToEval = new List<float>();
        for (float j=0;j<=1;j=j+pas) {
            tToEval.Add(j);
        }
        tToEval.Add(1);
        return tToEval;
    }

    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////// NE PAS TOUCHER //////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
     void Start()
    {
        buildPolysBernstein();
    }

    void Update()
    {
        if (slider.value != nombrePolynomesBernstein) {
            nombrePolynomesBernstein = (int)slider.value;
            ListePoints.Clear();
            buildPolysBernstein();
        }
    }

    void OnDrawGizmosSelected()
    {
        float profondeur = -2.0f;
        for (int i = 0; i < ListePoints.Count; ++i)
        {
            Gizmos.color = listeCouleurs[i % listeCouleurs.Length];
            List<Vector2> listePointsPolynome = ListePoints[i];
            for (int j = 0; j < listePointsPolynome.Count - 1; ++j)
            {
                Vector3 p1 = new Vector3(listePointsPolynome[j].x, profondeur, listePointsPolynome[j].y);
                Vector3 p2 = new Vector3(listePointsPolynome[j + 1].x, profondeur, listePointsPolynome[j + 1].y);
                Gizmos.DrawLine(p1, p2);
            }
        }
        Gizmos.color = Color.black;
        Gizmos.DrawLine(new Vector3(1.0f,profondeur,0.0f), new Vector3(0.0f,profondeur,0.0f));
        Gizmos.DrawLine(new Vector3(0.0f,profondeur,0.0f), new Vector3(0.0f,profondeur,1.0f));
    }
}
