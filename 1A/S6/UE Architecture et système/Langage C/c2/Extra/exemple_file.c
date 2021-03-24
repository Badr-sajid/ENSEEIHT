#include "file_char.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

/**
 * \brief Afficher la file
 * \details Le nom de la file est afficher suivi d'un signe '=' avant
 * le contenu de la file.
 * Comme nous n'avons pas accès à des opérations de parcours de la liste,
 * on extraie ses éléments pour les affichers et on les ajoute de nouveau.
 */
void afficher_une_file__char(const char nom_file[], File__char *f) {
    printf("%s = ", nom_file);

    // afficher la file.
    // Principe : extraire chaque élément pour l'afficher (et linsérer).
    int taille = longueur__char(*f);
    for (int i = 0; i < taille; i++) {
	char element;
	extraire__char(f, &element);
	printf("-->[ '%c' ]", element);
	inserer__char(f, element);
    }
    printf("--E");
    putchar('\n');
}

int main()
{
    File__char f1;
    char valeur;

    initialiser__char(&f1);
    assert(longueur__char(f1)==0);
    afficher_une_file__char("f1", &f1);

    inserer__char(&f1, 'X');
    printf("\ninsertion de : %c\n", 'X');
    afficher_une_file__char("f1", &f1);

    inserer__char(&f1, 'Y');
    printf("\ninsertion de : '%c'\n", 'Y');
    afficher_une_file__char("f1", &f1);

    extraire__char(&f1, &valeur);
    printf("\nextraction de : '%c'\n", valeur);
    afficher_une_file__char("f1", &f1);

    extraire__char(&f1, &valeur);
    printf("\nextraction de : '%c'\n", valeur);
    afficher_une_file__char("f1", &f1);

    detruire__char(&f1);

    return EXIT_SUCCESS;
}
