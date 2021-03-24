-- Spécification du module ensemble.
generic
    Capacite : Integer;   -- Nombre maximal d'éléments qu'un ensemble peut contenir.
    type T_Element is private;  -- Type des éléments de l'ensemble.

package Ensembles_Tableau is

    type T_Ensemble is limited private;

    -- Initilaiser un enseble.  L'ensemble est vide.
    procedure Initialiser (Ensemble : out T_Ensemble) with
            Post => est_vide (Ensemble);



    procedure detruire(Ensemble : in out T_Ensemble) with
            Post => est_vide (Ensemble);

    -- Est-ce que l'ensemble est vide ?
    function est_vide (Ensemble : in T_Ensemble) return Boolean;

    -- Obtenir la taille de l'ensemble.
    function taille_ensemble(Ensemble : in T_Ensemble) return Integer;

    -- Est ce qu'un élément est dans l'ensemble ?
    function existe (Ensemble : in T_Ensemble; Element : in T_Element) return Boolean;

    -- Ajouter un élément à l'ensemble.
    procedure ajouter_element(Ensemble : in out T_Ensemble; Element : in T_Element) with
            pre => taille_ensemble(Ensemble) < Capacite and not existe(Ensemble, Element),
            post => existe(Ensemble, Element) and taille_ensemble(Ensemble) = taille_ensemble(Ensemble)'old + 1;

    -- Supprimer un élément de l'ensemble.
    procedure supprimer_element(Ensemble : in out T_Ensemble; Element : in T_Element) with
            pre => existe(Ensemble, Element),
            post => not existe(Ensemble, Element) and taille_ensemble(Ensemble) = taille_ensemble(Ensemble)'old - 1;

    generic
        with procedure Appliquer_Sur_Tous (Element : in T_Element);
    procedure Afficher(Ensemble : in T_Ensemble);

private
    type T_Tab_Elements is array (1..Capacite) of T_Element;

    type T_Ensemble is
        record
            Elements : T_Tab_Elements;  -- les éléments de l'ensemble
            Taille: Integer;        -- Nombre d'éléments dans l'ensemble
        end record;

end Ensembles_Tableau;
