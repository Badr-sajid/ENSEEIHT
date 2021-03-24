#ifndef JEU__H
#define JEU__H

#include "main.h"

//Définition du type jeu complet pour enregistrer NB_CARTES cartes.
typedef carte jeu[NB_CARTES];



void init_jeu(jeu le_jeu);



void afficher_jeu(jeu le_jeu);



void melanger_jeu(jeu le_jeu);



void distribuer_mains(jeu le_jeu, int N, t_main* m1, t_main* m2);


carte * piocher(jeu le_jeu, t_main* main);

void test_piocher();


#endif
