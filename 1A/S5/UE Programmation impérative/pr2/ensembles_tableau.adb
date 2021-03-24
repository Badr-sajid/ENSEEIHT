-- Implantation du module Ensemble.
with Ada.Text_IO;  use Ada.Text_IO;

package body Ensembles_Tableau is

    procedure Initialiser (Ensemble : out T_Ensemble) is
    begin
        Ensemble.Taille := 0;
    end Initialiser;

    function est_vide (Ensemble : in T_Ensemble) return Boolean is
    begin
        return Ensemble.Taille = 0;
    end Est_Vide;

    procedure detruire (Ensemble : in out T_Ensemble) is
    begin
        Ensemble.Taille := 0;
    end detruire;

    function taille_ensemble(Ensemble : in T_Ensemble) return Integer is
    begin
        return Ensemble.Taille ;
    end taille_ensemble;

    function existe (Ensemble : in T_Ensemble; Element : in T_Element) return Boolean is
        f : Integer := 0;
        i : Integer := 1;
    begin
        while f = 0 and i <= Ensemble.Taille loop
            if ensemble.Elements(i) = Element then
                f := 1;
            end if;
            i := i + 1;
        end loop;
        return f = 1;
    end existe;

    procedure ajouter_element(Ensemble : in out T_Ensemble; Element : in T_Element) is
    begin
        if not existe(Ensemble,Element) and taille_ensemble(Ensemble) < Capacite then
            Ensemble.Taille := Ensemble.Taille + 1;
            Ensemble.Elements(Ensemble.Taille) := Element;
        end if;
    end ajouter_element;

    procedure supprimer_element(Ensemble : in out T_Ensemble; Element : in T_Element) is
        i : Integer := 1;
    begin
        while ensemble.Elements(i) /= Element loop
            i := i + 1;
        end loop;
        Ensemble.Elements(i) := Ensemble.Elements(taille_ensemble(Ensemble));
        Ensemble.Taille := Ensemble.Taille -1;
    end supprimer_element;

    procedure Afficher(Ensemble : in T_Ensemble) is
    begin
        if taille_ensemble(Ensemble) = 0 then
            put("{}");
        else
            put('{');
            Appliquer_Sur_Tous (Ensemble.Elements (1));
            for I in 2..Ensemble.Taille loop
                Put (", ");
                Appliquer_Sur_Tous (Ensemble.Elements (I));
            end loop;
            put('}');
        end if;
    end Afficher;

end Ensembles_Tableau;
