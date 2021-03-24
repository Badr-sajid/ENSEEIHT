#ifndef CARTE_H
#define CARTE_H
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <time.h>

#define NB_VALEURS 10
#define NB_CARTES (4*NB_VALEURS)

//Définition du type enseigne
enum couleur {JAUNE, ROUGE, VERT, BLEU};
typedef enum couleur couleur;


//Définition du type carte
struct carte {
    couleur couleur;
    int valeur; // Invariant : valeur >= 0 && valeur < NB_VALEURS
    bool presente; // la carte est-elle presente dans le jeu ?
};
typedef struct carte carte;



void init_carte(carte* la_carte, couleur c, int v, bool pr);



bool est_conforme(carte c);


/**
* \brief Copie les valeurs de la carte src dans la carte dest.
* \param[in] src carte à copier
* \param[out] dest carte destination de la copie
*/
void copier_carte(carte* dest, carte src);



void afficher_carte(carte cte);



bool est_egale(carte c1, carte c2);

#endif
