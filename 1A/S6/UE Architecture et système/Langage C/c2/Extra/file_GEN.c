/**
 *  \author Xavier Cregut <nom@n7.fr>
 *  \file file_GEN.c
 *
 *  Objectif :
 *	Implantation des operations de la file
*/

#include <stdlib.h>
#include <assert.h>
#include <stdio.h>
#include "file_GEN.h"


void initialiser__GEN(File__T_GEN *f)
{
    f->queue = malloc(sizeof(Cellule__T_GEN));
    f->queue = NULL;
    f->tete = NULL;
    assert(est_vide__GEN(*f));
}


void detruire__GEN(File__T_GEN *f)
{
    if (f->tete == NULL) {
    } else {
        free(f->tete);
        f->tete = NULL;
    }
}


t_element tete__GEN(File__T_GEN f)
{
    assert(! est_vide__GEN(f));

    return f.tete->valeur;
}


bool est_vide__GEN(File__T_GEN f)
{
    return (f.tete == NULL && f.queue == NULL);
}

/**
 * Obtenir une nouvelle cellule allouee dynamiquement
 * initialisee avec la valeur et la cellule suivante precise en parametre.
 */
Cellule__T_GEN * cellule__GEN(t_element valeur, Cellule__T_GEN *suivante)
{
    Cellule__T_GEN* cellule = malloc(sizeof(t_element)+sizeof(suivante));
    cellule->valeur = valeur;
    cellule->suivante = suivante;
    return cellule;
}


void inserer__GEN(File__T_GEN *f, t_element v)
{
    assert(f != NULL);
    if (f->tete == NULL){
        f->tete = cellule__GEN(v,NULL);
        f->queue = f->tete;
    } else {
        f->queue->suivante = cellule__GEN(v,NULL);
        f->queue = f->queue->suivante;
    }
}

void extraire__GEN(File__T_GEN *f, t_element *v)
{
    assert(f != NULL);
    assert(! est_vide__GEN(*f));

    *v = f->tete->valeur;
    Cellule__T_GEN *c = f->tete->suivante;
    free(f->tete);
    f->tete = NULL;
    f->tete = c;
}


int longueur__GEN(File__T_GEN f)
{
    if (f.tete == NULL){
        return 0;
    } else {
        File__T_GEN f1;
        f1.tete = f.tete->suivante;
        return 1 + longueur__GEN(f1);
    }
}


