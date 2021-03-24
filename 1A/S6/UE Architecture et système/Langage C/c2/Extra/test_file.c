/*
 *  Auteur :  Xavier CREGUT
 *  Date :    07/09/98, 11:21:58
 *
 *  Objectif :
 *	Test des files
 *
 *  Changements :
 *
 *  	$Log$
 */

#include "file_char.h"
#include <stdlib.h>
#include <assert.h>

int main ()
{
    File__char f;
    char val;
    initialiser__char (&f);
    assert(0 == longueur__char(f));


    inserer__char (&f, 'O');
    assert(1 == longueur__char(f));
    assert('O' == tete__char(f));

    inserer__char (&f, 'K');
    assert(2 == longueur__char(f));
    assert('O' == tete__char(f));

    inserer__char (&f, '?');
    assert(3 == longueur__char(f));
    assert('O' == tete__char(f));

    extraire__char (&f, &val);
    assert('O' == val);
    assert(2 == longueur__char(f));
    assert('K' == tete__char(f));

    extraire__char (&f, &val);
    assert('K' == val);
    assert(1 == longueur__char(f));
    assert('?' == tete__char(f));

    extraire__char (&f, &val);
    assert('?' == val);
    assert(0 == longueur__char(f));

    // Tester l'ajout dans une file vidée
    inserer__char (&f, 'Y');
    assert(1 == longueur__char(f));
    assert('Y' == tete__char(f));

    detruire__char(&f);

    return EXIT_SUCCESS;
}
