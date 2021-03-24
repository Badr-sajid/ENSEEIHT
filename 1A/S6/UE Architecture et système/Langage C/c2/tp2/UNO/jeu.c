// Inclure l'interface main.h
#include "jeu.h"


void init_jeu(jeu le_jeu){
    int k=0;
    for (int i=0 ; i<4 ; i++){
        for (int j=0 ; j<NB_VALEURS ; j++){
            init_carte(&(le_jeu[k]), i, j, true);
            k++;
        }
    }
}


void afficher_jeu(jeu le_jeu){
    for (int k=0; k<NB_CARTES; k++){
        afficher_carte(le_jeu[k]);
    }
    printf("\n");
}


void melanger_jeu(jeu le_jeu){
    for (int k=0; k<1000; k++){
        // Choisir deux cartes aléatoirement
        int i = rand()%NB_CARTES;
        int j = rand()%NB_CARTES;
        // Les échanger
        carte mem;
        copier_carte(&mem, le_jeu[i]);
        copier_carte(&(le_jeu[i]), le_jeu[j]);
        copier_carte(&(le_jeu[j]), mem);
    }
}


void distribuer_mains(jeu le_jeu, int N, t_main* m1, t_main* m2){
    assert(N <= (NB_CARTES-1)/2);

    //Initialiser les mains de N cartes
    bool errA = init_main(m1, N);
    bool errB = init_main(m2, N);
    assert(!errA && !errB);
    
    //Distribuer les cartes
    for (int i=0; i<N; i++){
        // ajout d'une carte dans la main m1
        copier_carte(&(m1->main[i]), le_jeu[2*i]);
        // ajout d'une carte dans la main m2
        copier_carte(&(m2->main[i]), le_jeu[2*i+1]);
        //mise à jour de presente à false dans le_jeu
        le_jeu[2*i].presente = false;
        le_jeu[2*i+1].presente = false;
    }
}
