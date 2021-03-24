with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;

-- Objectif : Afficher un tableau trié suivant le principe du tri par sélection.

procedure Tri_Selection is

    CAPACITE: constant Integer := 10;   -- la capacité du tableau

    type Tableau_Entier is array (1..CAPACITE) of Integer;

    type Tableau is
        record
            Elements : Tableau_Entier;
            Taille   : Integer;         --{ Taille in [0..CAPACITE] }
        end record;


    -- Objectif : Afficher le tableau Tab.
    -- Paramètres :
    --     Tab : le tableau à afficher
    -- Nécessite : ---
    -- Assure : Le tableau est affiché.
    procedure Afficher (Tab : in Tableau) is
    begin
        Put ("[");
        if Tab.Taille > 0 then
            -- Afficher le premier élément
            Put (Tab.Elements (1), 1);

            -- Afficher les autres éléments
            for Indice in 2..Tab.Taille loop
                Put (", ");
                Put (Tab.Elements (Indice), 1);
            end loop;
        end if;
        Put ("]");
    end Afficher;


    Tab1 : Tableau;
    -- Objectif : Trier le tableau Tab.
    -- Paramètres :
    --     Tab : le tableau à trier
    -- Nécessite : ---
    -- Assure : Le tableau est trier.
    procedure Trier(tab : in out Tableau) is
        min : Integer  ;
        indice_min : Integer;
        pour_permuter : Integer;
    begin
        for i in 1..(tab.Taille-1) loop
            min := tab.Elements(i);
            indice_min := i;
            for j in i..tab.Taille loop
                if tab.Elements(j) < min then
                    min := tab.Elements(j);
                    indice_min := j;
                end if;
            end loop;
            pour_permuter := tab.Elements(i);
            tab.Elements(i) := min;
            tab.Elements (indice_min) := pour_permuter;
        end loop;
    end Trier;

begin
    -- Initialiser le tableau
    Tab1 := ( (1, 3, 4, 2, others => 0), 4);
    -- Afficher le tableau
    Afficher (Tab1);
    New_Line;
    -- Trier le tableau
    Trier(tab1);

    -- Afficher le tableau
    Afficher (Tab1);
    New_Line;

end Tri_Selection;
