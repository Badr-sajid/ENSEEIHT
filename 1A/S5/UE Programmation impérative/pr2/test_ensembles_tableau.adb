with Ensembles_Tableau;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Test_Ensembles_Tableau is

    -- Instancier le paquetage Ensembles_Tableau pour avoir un Ensemble
    -- d'entiers de capacité 5

    package ensemble_entier is
            new Ensembles_Tableau (T_Element => Integer, Capacite => 5);
    use ensemble_entier;

    Ens : T_Ensemble;

    procedure Affiche(N : in Integer) is
    begin
        ada.Integer_Text_IO.Put(N,Width => 0);
    end;
    procedure Afficher is new ensemble_entier.Afficher(affiche);

begin

    -- Créer un ensemble vide Ens1
    Initialiser (Ens);

    -- Afficher l'ensemble
    Afficher(Ens);
    New_Line;

    -- Vérifier si vide ou non, sa taille, la présence ou pas de 1,2,3,4,5
    pragma Assert (Est_Vide(Ens));
    pragma Assert (taille_ensemble(Ens) = 0);
    pragma Assert (not existe(Ens,1));
    pragma Assert (not existe(Ens,2));
    pragma Assert (not existe(Ens,3));
    pragma Assert (not existe(Ens,4));
    pragma Assert (not existe(Ens,5));

    -- Ajouter 1 à Ens
    ajouter_element(Ens,1);

    -- Afficher l'ensemble
    Afficher(Ens);
    New_Line;

    -- Vérifier si vide ou non, sa taille, la présence ou pas de 1,2,3,4,5
    pragma Assert (not Est_Vide(Ens));
    pragma Assert (taille_ensemble(Ens) = 1);
    pragma Assert (existe(Ens,1));
    pragma Assert (not existe(Ens,2));
    pragma Assert (not existe(Ens,3));
    pragma Assert (not existe(Ens,4));
    pragma Assert (not existe(Ens,5));

    -- Ajouter 1 à Ens
    --ajouter_element(Ens,1);	-- 1 existe déjà dans Ens donc erreur de precondition.

    -- Afficher l'ensemble
    Afficher(Ens);
    New_Line;

    -- Vérifier si vide ou non, sa taille, la présence ou pas de 1,2,3,4,5
    pragma Assert (not Est_Vide(Ens));
    pragma Assert (taille_ensemble(Ens) = 1);
    pragma Assert (existe(Ens,1));
    pragma Assert (not existe(Ens,2));
    pragma Assert (not existe(Ens,3));
    pragma Assert (not existe(Ens,4));
    pragma Assert (not existe(Ens,5));

    -- Ajouter 2 puis 3 puis 4 à Ens
    ajouter_element(Ens,2);
    ajouter_element(Ens,3);
    ajouter_element(Ens,4);

    -- Afficher l'ensemble
    Afficher(Ens);
    New_Line;

    -- Vérifier si vide ou non, sa taille, la présence ou pas de 1,2,3,4,5
    pragma Assert (not Est_Vide(Ens));
    pragma Assert (taille_ensemble(Ens) = 4);
    pragma Assert (existe(Ens,1));
    pragma Assert (existe(Ens,2));
    pragma Assert (existe(Ens,3));
    pragma Assert (existe(Ens,4));
    pragma Assert (not existe(Ens,5));

    --supprimer 4 et 10 de Ens
    supprimer_element(Ens,4);
    --supprimer_element(Ens,10);	-- 10 n'existe pas dans Ens donc erreur de precodition

    -- Afficher l'ensemble
    Afficher(Ens);
    New_Line;

    -- Vérifier si vide ou non, sa taille, la présence ou pas de 1,2,3,4,5
    pragma Assert (not Est_Vide(Ens));
    pragma Assert (taille_ensemble(Ens) = 3);
    pragma Assert (existe(Ens,1));
    pragma Assert (existe(Ens,2));
    pragma Assert (existe(Ens,3));
    pragma Assert (not existe(Ens,4));
    pragma Assert (not existe(Ens,5));

    -- Ajouter 4, 5 et 6 à Ens
    ajouter_element(Ens,4);
    ajouter_element(Ens,5);
    --ajouter_element(Ens,6);	-- La taille de l'ensemble est 5 donc on ne peut pas ajouter le 6.

    -- Afficher l'ensemble
    Afficher(Ens);
    New_Line;

    -- Vérifier si vide ou non, sa taille, la présence ou pas de 1,2,3,4,5,6
    pragma Assert (not Est_Vide(Ens));
    pragma Assert (taille_ensemble(Ens) = 5);
    pragma Assert (existe(Ens,1));
    pragma Assert (existe(Ens,2));
    pragma Assert (existe(Ens,3));
    pragma Assert (existe(Ens,4));
    pragma Assert (existe(Ens,5));
    pragma Assert (not existe(Ens,6));

    --detruire l'ensemble
    detruire(Ens);

    -- Afficher l'ensemble
    Afficher(Ens);
    New_Line;

    -- Vérifier si vide ou non, sa taille, la présence ou pas de 1,2,3,4,5
    pragma Assert (Est_Vide(Ens));
    pragma Assert (taille_ensemble(Ens) = 0);
    pragma Assert (not existe(Ens,1));
    pragma Assert (not existe(Ens,2));
    pragma Assert (not existe(Ens,3));
    pragma Assert (not existe(Ens,4));
    pragma Assert (not existe(Ens,5));
end Test_Ensembles_Tableau;
