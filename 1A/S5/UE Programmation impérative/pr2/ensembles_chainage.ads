-- Spécification du module ensemble chainage.

generic
    type T_Element is private;  -- Type des éléments de l'ensemble chainage

package Ensembles_Chainage is

    type T_Ensemble is limited private;

    -- Initilaiser un ensemble.  L'ensemble est vide.
    procedure Initialiser (Ensemble : out T_Ensemble) with
            Post => Est_Vide (Ensemble);

    -- Détruire l'ensemble
    procedure detruire(Ensemble : in out T_Ensemble) with
            Post => est_vide (Ensemble);

    -- Est-ce que l'ensemble est vide ?
    function Est_Vide (Ensemble : in T_Ensemble) return Boolean;

    -- Ajouter un'élément à l'ensemble.
    procedure Ajouter_element (Ensemble : in out T_Ensemble; Element : in T_Element) with
            pre => not existe(Ensemble, Element),
            post => existe(Ensemble, Element) and taille_ensemble(Ensemble) = taille_ensemble(Ensemble)'old + 1;

    -- Obtenir la taille de l'ensemble.
    function taille_ensemble(Ensemble : in T_Ensemble) return Integer;

    -- Est ce qu'un élément est dans l'ensemble ?
    function existe (Ensemble : in T_Ensemble; Element : in T_Element) return Boolean;


    -- Supprimer un élément de l'ensemble.
    procedure supprimer_element(Ensemble : in out T_Ensemble; Element : in T_Element) with
            pre => existe(Ensemble, Element),
            post => not existe(Ensemble, Element) and taille_ensemble(Ensemble) = taille_ensemble(Ensemble)'old - 1;

    generic
        with procedure Appliquer_Sur_Tous (Element : in T_Element);
    procedure Afficher(Ensemble : in T_Ensemble);


private

    type T_Cellule;

    type T_Ensemble is access T_Cellule;

    type T_Cellule is
        record
            Element: T_Element;
            Suivant: T_Ensemble;
        end record;
end Ensembles_Chainage;
