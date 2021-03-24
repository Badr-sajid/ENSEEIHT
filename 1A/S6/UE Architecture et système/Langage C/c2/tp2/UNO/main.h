#ifndef MAIN__H
#define MAIN__H
#include "carte.h"


//Définition du type t_main, capable d'enregistrer un nombre variable de cartes.
struct main {
    carte * main; //tableau des cartes dans la main.
    int nb; //monbre de cartes
};
typedef struct main t_main;



bool init_main(t_main* la_main, int N);



void afficher_main(t_main la_main);



bool est_presente_main(t_main main, carte c);

#endif
