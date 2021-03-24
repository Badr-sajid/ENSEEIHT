/**
 *  \author Xavier Crégut <nom@n7.fr>
 *  \file file.c
 *
 *  Objectif :
 *	Implantation des opérations de la file
*/

#include <stdlib.h>
#include <assert.h>
#include <stdio.h>
#include "file.h"


void initialiser(File *f)
{
    f->queue = malloc(sizeof(Cellule));
    f->queue = NULL;
    f->tete = NULL;
    assert(est_vide(*f));
}


void detruire(File *f)
{
    if (f->tete == NULL) {
    } else {
        free(f->tete);
        f->tete = NULL;
    }
}


char tete(File f)
{
    assert(! est_vide(f));

    return f.tete->valeur;
}


bool est_vide(File f)
{
    return (f.tete == NULL && f.queue == NULL);
}

/**
 * Obtenir une nouvelle cellule allouée dynamiquement
 * initialisée avec la valeur et la cellule suivante précisé en paramètre.
 */
Cellule * cellule(char valeur, Cellule *suivante)
{
    Cellule* cellule = malloc(sizeof(char)+sizeof(suivante));
    cellule->valeur = valeur;
    cellule->suivante = suivante;
    return cellule;
}


void inserer(File *f, char v)
{
    assert(f != NULL);
    if (f->tete == NULL){
        f->tete = cellule(v,NULL);
        f->queue = f->tete;
    } else {
        f->queue->suivante = cellule(v,NULL);
        f->queue = f->queue->suivante;
    }
}

void extraire(File *f, char *v)
{
    assert(f != NULL);
    assert(! est_vide(*f));

    *v = f->tete->valeur;
    Cellule *c = f->tete->suivante;
    free(f->tete);
    f->tete = NULL;
    f->tete = c;
}


int longueur(File f)
{
    if (f.tete == NULL){
        return 0;
    } else {
        File f1;
        f1.tete = f.tete->suivante;
        return 1 + longueur(f1);
    }
}

void afficher(File f) {
    printf("  affichage :  ");
    if (f.tete == NULL){
        printf("null");
    }
    while (f.tete != NULL) {
        printf("%c",f.tete->valeur);
        f.tete = f.tete->suivante;
    }
    printf("\n");
}
