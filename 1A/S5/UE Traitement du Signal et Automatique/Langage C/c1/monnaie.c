#include <stdlib.h> 
#include <stdio.h>
#include <assert.h>
#include <stdbool.h>

// Definition du type monnaie
struct t_monnaie {
  float valeur;
  char devise;
};
typedef struct t_monnaie t_monnaie;

/**
 * \brief Initialiser une monnaie
 * \param[out] monnaie la monnaie à initialiser 
 * \param[in] valeur la valeur de la monnaie
 * \param[in] devise la devise
 * \pre valeur >= 0
 */ 
void initialiser(t_monnaie* monnaie, float valeur, char devise) {
  monnaie -> valeur = valeur;
  monnaie -> devise = devise;
}


/**
 * \brief Ajouter une monnaie m2 à une monnaie m1 
 * \param[in] m1 la monnaie à ajouter
 * \param[out] m2 la monnaie à modifier
 */ 
bool ajouter(t_monnaie* m1, t_monnaie* m2) {
  if (m1->devise == m2->devise){
    m2->valeur += m1->valeur;
    return true;
  }
  return false;
}


/**
 * \brief Tester Initialiser 
 * \param[]
 */ 
void tester_initialiser() {
  t_monnaie m1;
  t_monnaie m2;
  t_monnaie m3;
  initialiser(&m1,150,'$');
  initialiser(&m2,0, 'e');
  initialiser(&m3,50,'d');
  assert(m1.valeur == 150);
  assert(m2.valeur == 0);
  assert(m3.valeur == 50);
  assert(m1.devise == '$');
  assert(m2.devise == 'e');
  assert(m3.devise == 'd');
}

/**
 * \brief Tester Ajouter 
 * \param[]
 */ 
void tester_ajouter() {
  t_monnaie m1;
  t_monnaie m2;
  t_monnaie m3;
  bool f;
  initialiser(&m1,150,'$');
  initialiser(&m2,0, '$');
  initialiser(&m3,50,'e');
  f =  ajouter(&m1,&m2);
  assert(f == true);
  assert(m2.valeur == 150);
  f =  ajouter(&m1,&m3);
  assert(f == false);
  assert(m3.valeur == 50);



}



int main(void) {
  // Déclarer un tableau de 5 monnaies
  t_monnaie tab[5];
  float valeur;
  char devise;
  //Initialiser les monnaies
  t_monnaie m;
  for (int i=0; i<5; i++){
    printf("Entrez la monnaie (valeur + devise) : ");
    scanf("%f",&valeur);
    devise = getchar();
        while (getchar() != '\n'){
            fflush(stdin);
        }
    initialiser(&m,valeur,devise);
    tab[i] = m;
  }

 
  // Afficher la somme de toutes les monnaies qui sont dans une devise entrée par l'utilisateur.
  char devise_demande;
  printf("entrer la deviser pour laquelle vous voulez calculer la somme des monnaies : ");
  scanf(" %c",&devise_demande);
  t_monnaie somme;
  somme.valeur = 0.0;
  somme.devise = devise_demande;
  for (int i=0; i<5; i++){
    ajouter(&tab[i],&somme);
  }
  printf("la somme de votre monnaie est : %f %c\n",somme.valeur,devise_demande);
  
  return EXIT_SUCCESS;
}
