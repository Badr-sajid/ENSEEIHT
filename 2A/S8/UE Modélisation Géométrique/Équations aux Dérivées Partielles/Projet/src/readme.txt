- Le fichier à executer pour tester tous les résultats : 
     test.m

- Ce fichier vous permet de retrouver 4 figures : 
     --> Figure 1 : La solution du problème dans le premier cas (maillage_carre(n)).
     --> Figure 2 : La solution du problème dans le deuxième cas (load).
     --> Figure 3 : L'évolution de l'erreur en fonction de la norme L2 discrète (en log).
     --> Figure 4 : L'évolution du nombres des éléments non nuls de R en fonction de la taille de A.

- Les paramètres changeables : 
     --> n : Le nombre maximal des éléments du maillage, considéré au début comme 20.
             Vous pouvez le changer dans la première ligne du code.

----------------------------------------------------------------------------------------------------------


- Le fichier à éxecuter pour retrouver la solution, la matrice A et le vecteur b:
    elliptic.m

- Utilisation:
    ce fichier représente une fonction de la forme : [A,u,b] = elliptic(choix,nb)

    --> choix : Soit 1 (le premier cas avec maillage_carre(n)), Soit 2 (le deuxième cas avec load)
    --> nb : Le nombre des éléments du maillage.

- Exemple:
    --> Si vous écrivez [A,u,b] = elliptic(1,16) dans le terminal matlab vous aurez les résultats 
    dans le premier cas avec 16 éléments du maillage.
        
    --> Si vous écrivez [A,u,b] = elliptic(2,0) dans le terminal matlab vous aurez les résultats 
    dans le deuxième cas avec load.


------------------------------------------------------------------------------------------------------------

Les fichiers assemblage_triangle.m, matriceRaideur_quadrangle.m et u_ex.m représentent des fonctions intermédiaires
pour faire l'assemblage triangle, calculer la matrice de raideur dans le cas quadrangle et calculer 
la solution exacte dans la partie 1.4.

-------------------------------------------------------------------------------------------------------------

Le rapport : rapport.pdf  dans le dossier HABIBI_SAJID/