with Ensembles_Chainage;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Test_Ensembles_Sujet_Chainage is


    -- Instancier le paquetage Ensembles_Chainage pour avoir un Ensemble
    -- d'entiers
    package ensemble_entier is
            new Ensembles_Chainage (T_Element => Integer);
    use ensemble_entier;

    -- Définir une opération Afficher qui affiche les éléments d'un ensemble
    -- d'entier en s'appuyant sur Appliquer_Sur_Tous.  L'ensemble {5, 28, 10}
    -- sera affiché :
    --           5         28         10
    procedure Affiche(N : in Integer) is
    begin
        ada.Integer_Text_IO.Put(N,Width => 0);
    end;
    procedure Afficher is new ensemble_entier.Afficher(affiche);

    Ens1 : T_Ensemble;

begin
    -- Créer un ensemble vide Ens1
    Initialiser (Ens1);

    -- Afficher l'ensemble
    Afficher (Ens1);
    New_Line;
    -- Vérifier si vide ou non, sa taille, la présence ou pas de 2, 5, 7, 10
    pragma Assert (Est_Vide(Ens1));
    pragma Assert (taille_ensemble(Ens1) = 0);
    pragma Assert (not existe(Ens1,2));
    pragma Assert (not existe(Ens1,5));
    pragma Assert (not existe(Ens1,7));
    pragma Assert (not existe(Ens1,10));

    -- Ajouter 5 dans Ens1
    ajouter_element(Ens1,5);

    -- Afficher l'ensemble
    Afficher (Ens1);
    New_Line;

    -- Vérifier si vide ou non, sa taille, la présence ou pas de 2, 5, 7, 10
    pragma Assert(not Est_Vide(Ens1));
    pragma Assert(taille_ensemble(Ens1) = 1);
    pragma Assert(not existe(Ens1,2));
    pragma Assert(existe(Ens1,5));
    pragma Assert(not existe(Ens1,7));
    pragma Assert(not existe(Ens1,10));

    -- Ajouter 28 puis 10 dans Ens1
    ajouter_element(Ens1,28);
    ajouter_element(Ens1,10);

    -- Afficher l'ensemble
    Afficher (Ens1);
    New_Line;

    -- Vérifier si vide ou non, sa taille, la présence ou pas de 2, 5, 7, 10
    pragma Assert(not Est_Vide(Ens1));
    pragma Assert(taille_ensemble(Ens1) = 3);
    pragma Assert(not existe(Ens1,2));
    pragma Assert(existe(Ens1,5));
    pragma Assert(not existe(Ens1,7));
    pragma Assert(existe(Ens1,10));

    -- Ajouter 7 dans Ens1
    ajouter_element(Ens1,7);

    -- Afficher l'ensemble
    Afficher (Ens1);
    New_Line;

    -- Vérifier si vide ou non, sa taille, la présence ou pas de 2, 5, 7, 10
    pragma Assert(not Est_Vide(Ens1));
    pragma Assert(taille_ensemble(Ens1) = 4);
    pragma Assert(not existe(Ens1,2));
    pragma Assert(existe(Ens1,5));
    pragma Assert(existe(Ens1,7));
    pragma Assert(existe(Ens1,10));

    -- Supprimer 10 en Ens1
    supprimer_element(Ens1,10);

    -- Afficher l'ensemble
    Afficher (Ens1);
    New_Line;

    -- Vérifier si vide ou non, sa taille, la présence ou pas de 2, 5, 7, 10
    pragma Assert(not Est_Vide(Ens1));
    pragma Assert(taille_ensemble(Ens1) = 3);
    pragma Assert(not existe(Ens1,2));
    pragma Assert(existe(Ens1,5));
    pragma Assert(existe(Ens1,7));
    pragma Assert(not existe(Ens1,10));

    -- Supprimer 7 en Ens1
    supprimer_element(Ens1,7);

    -- Vérifier si vide ou non, sa taille, la présence ou pas de 2, 5, 7, 10
    pragma Assert(not Est_Vide(Ens1));
    pragma Assert(taille_ensemble(Ens1) = 2);
    pragma Assert(not existe(Ens1,2));
    pragma Assert(existe(Ens1,5));
    pragma Assert(not existe(Ens1,7));
    pragma Assert(not existe(Ens1,10));

    -- Supprimer 5 en Ens1
    supprimer_element(Ens1,5);

    -- Afficher l'ensemble
    Afficher (Ens1);
    New_Line;

    -- Vérifier si vide ou non, sa taille, la présence ou pas de 2, 5, 7, 10
    pragma Assert(not Est_Vide(Ens1));
    pragma Assert(taille_ensemble(Ens1) = 1);
    pragma Assert(not existe(Ens1,2));
    pragma Assert(not existe(Ens1,5));
    pragma Assert(not existe(Ens1,7));
    pragma Assert(not existe(Ens1,10));

    -- Détruire l'ensemble
    detruire(Ens1);

end Test_Ensembles_Sujet_Chainage;
