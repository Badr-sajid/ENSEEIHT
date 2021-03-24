-- Implantation du module ensemble chainage.

with Ada.Unchecked_Deallocation;
with Ada.Text_IO;  use Ada.Text_IO;
	--// Ce module est nécessaire parce qu'on a ajouté le SP Afficher.

package body Ensembles_Chainage is

    procedure Free is
            new Ada.Unchecked_Deallocation (T_Cellule, T_Ensemble);

    procedure Initialiser (Ensemble : out T_Ensemble) is
    begin
        Ensemble := null;
    end;

    procedure detruire(Ensemble : in out T_Ensemble) is
    begin
        if Ensemble /= Null then
            Detruire (Ensemble.all.Suivant);
            Free (Ensemble);
        else
            Null;
        end if;
    end;

    function Est_Vide (Ensemble : in T_Ensemble) return Boolean is
    begin
        return taille_ensemble(Ensemble) = 0;
    end;

    procedure Ajouter_element (Ensemble : in out T_Ensemble; Element : in T_Element) is
        Nouvelle_Cellule: T_Ensemble;
    begin
        if not existe(Ensemble,Element) then
            -- Créer une nouvelle cellule
            Nouvelle_Cellule := new T_Cellule;
            Nouvelle_Cellule.all.Element := Element;
            Nouvelle_Cellule.all.Suivant := Ensemble;

            -- Changer ensemble
            Ensemble := Nouvelle_Cellule;
        end if;
    end;

    function taille_ensemble(Ensemble : in T_Ensemble) return Integer is
    begin
        if Ensemble = null then
            return 0;
        else
            return 1 + taille_ensemble(Ensemble.all.Suivant);
        end if;
    end;

    function existe (Ensemble : in T_Ensemble; Element : in T_Element) return Boolean is
    begin
        if Ensemble = null then
            return false;
        elsif Ensemble.all.Element = Element then
            return True;
        else
            return existe(Ensemble.all.Suivant, Element);
        end if;
    end;

    procedure supprimer_element(Ensemble : in out T_Ensemble; Element : in T_Element) is
    begin
        if Ensemble.all.Element = Element then
            if Ensemble.all.Suivant = null then	-- Si l'element supprimer est le dernier element il faut just le supprimer
                Free(Ensemble);
            else					-- Sinon il faut le supprimer l'element et decaler la chaine
                Ensemble.all.Element := Ensemble.all.Suivant.all.Element;
                Ensemble.all.Suivant := Ensemble.all.Suivant.all.Suivant;
            end if;

        else
            supprimer_element(Ensemble.all.Suivant,Element);
        end if;
    end;

    procedure Afficher(Ensemble : in T_Ensemble) is
        procedure Afficher_Elements (Ensemble : in T_Ensemble) is
        begin
            if Ensemble = Null then
                Null;
            elsif Ensemble.all.Suivant = Null then
                Put (" ");
                Appliquer_Sur_Tous(Ensemble.all.Element);
            else
                Afficher_Elements(Ensemble.all.Suivant);
                Put (", ");
                Appliquer_Sur_Tous(Ensemble.all.Element);
            end if;
        end Afficher_Elements;

    begin
        Put ('{');
        Afficher_Elements (Ensemble);
        Put (" }");
    end Afficher;

end Ensembles_Chainage;
