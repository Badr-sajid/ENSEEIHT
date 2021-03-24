
#include <stdbool.h>

typedef T_GEN t_element;

struct Cellule__T_GEN {
    t_element valeur;
    struct Cellule__T_GEN *suivante;
};
typedef struct Cellule__T_GEN Cellule__T_GEN;

struct File__T_GEN {
    Cellule__T_GEN *tete;
    Cellule__T_GEN *queue;
    /** Invariant :
      *	 file vide :	tete == NULL && queue == NULL
      */
};
typedef struct File__T_GEN File__T_GEN;


/**
 * Initialiser la file \a f.
 * La file est vide.
 *
 * Assure
 *	est_vide(*f);
 */
void initialiser__GEN(File__T_GEN *f);

/**
 * Detruire la file \a f.
 * Elle ne pourra plus etre utilisee (sauf a etre de nouveau initialisee)
 */
void detruire__GEN(File__T_GEN *f);

/**
 * L'element en tete de la file.
 * Necessite :
 *	! est_vide(f);
 */
t_element tete__GEN(File__T_GEN f);

/**
 * Ajouter dans la file \a f l'element \a v.
 *
 * Necessite :
 *	f != NULL;
 */
void inserer__GEN(File__T_GEN *f, t_element v);

/**
 * Extraire l'element \a v en tete de la file \a f.
 * Necessite
 *	f != NULL;
 *	! est_vide(*f);
 */
void extraire__GEN(File__T_GEN *f, t_element *v);

/**
 * Est-ce que la file \a f  est vide ?
 */
bool est_vide__GEN(File__T_GEN f);

/**
 * Obtenir la longueur de la file.
 */
int longueur__GEN(File__T_GEN f);
