with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Integer_Text_IO;    use Ada.Integer_Text_IO;
with Ada.Unchecked_Deallocation;

package body ABR is

    procedure Free is
            new Ada.Unchecked_Deallocation (Object => T_Noeud, Name => T_ABR);

    function Est_Cle_Utilisee (Abr : in T_Abr ; Cle : in Character) return Boolean is
    begin
        if abr = null then
            return false;
        elsif abr.all.cle = cle then
            return True;
        elsif abr.all.cle < cle then
            return Est_Cle_Utilisee(Abr.all.Sous_Arbre_Gauche, Cle);
        else
            return Est_Cle_Utilisee(Abr.all.Sous_Arbre_droit, Cle);
        end if;
    end Est_Cle_Utilisee;

    procedure Initialiser(Abr: out T_ABR) is
    begin
        Abr := null;
    end Initialiser;


    function Est_Vide (Abr : T_Abr) return Boolean is
    begin
        return Taille(Abr) = 0;
    end;


    function Taille (Abr : in T_ABR) return Integer is
    begin
        if Abr = null then
            return 0;
        else
            return 1 + Taille(Abr.all.Sous_Arbre_Gauche) + Taille(Abr.all.Sous_Arbre_Droit);
        end if;
    end Taille;


    procedure Inserer (Abr : in out T_ABR ; Cle : in Character ; Donnee : in Integer) is
    begin
        if Abr = null then
            Abr := new T_Noeud'(Cle => Cle,Donnee => Donnee,Sous_Arbre_Gauche => null,Sous_Arbre_Droit => null);
        elsif Abr.all.Cle = Cle then
            raise Cle_Presente_Exception;
        elsif Abr.all.Cle < Cle then
            Inserer(Abr.all.Sous_Arbre_Droit, Cle, Donnee);
        else
            Inserer(Abr.all.Sous_Arbre_Gauche, Cle, Donnee);
        end if;
    end Inserer;


    procedure Modifier (Abr : in out T_ABR ; Cle : in Character ; Donnee : in Integer) is
    begin
         if Abr = null then
            raise Cle_Absente_Exception;
        elsif Abr.all.Cle = Cle then
            Abr.all.Donnee := Donnee;
        elsif Abr.all.Cle < Cle then
            Modifier(Abr.all.Sous_Arbre_Droit, Cle, Donnee);
        else
            Modifier(Abr.all.Sous_Arbre_Gauche, Cle, Donnee);
        end if;
    end Modifier;


    function La_Donnee (Abr : in T_ABR ; Cle : in Character) return Integer is
    begin
        if Abr = null then
            raise Cle_Absente_Exception;
        elsif Abr.all.Cle = Cle then
            return abr.all.Donnee;
        elsif Abr.all.Cle < Cle then
            return La_Donnee(Abr.all.Sous_Arbre_Droit, Cle);
        else
            return La_Donnee(Abr.all.Sous_Arbre_Gauche, Cle);
        end if;
    end La_Donnee;


    procedure Supprimer (Abr : in out T_ABR ; Cle : in Character) is
        new_cellule : T_ABR;
        procedure ajouter_abr_gauche(Abr : in out T_ABR; new_Abr : in T_ABR) is
        begin
            if abr = null then
                abr := new T_Noeud'(Cle => new_Abr.all.Cle, Donnee => new_Abr.all.Donnee, Sous_Arbre_Gauche => new_Abr.all.Sous_Arbre_Gauche, Sous_Arbre_Droit => new_Abr.all.Sous_Arbre_Droit);
            else
                ajouter_abr_gauche(Abr.all.Sous_Arbre_Gauche,new_Abr);
            end if;
        end;
    begin
        if Abr = null then
            raise Cle_Absente_Exception;
        elsif Abr.all.Cle = Cle then
            new_cellule := new T_Noeud'(Cle => abr.all.Sous_Arbre_Droit.all.Cle, Donnee => abr.all.Sous_Arbre_Droit.all.Donnee, Sous_Arbre_Gauche =>abr.all.Sous_Arbre_Droit.all.Sous_Arbre_Gauche, Sous_Arbre_Droit => abr.all.Sous_Arbre_Droit.all.Sous_Arbre_Droit);
            ajouter_abr_gauche(new_cellule, abr.all.Sous_Arbre_Gauche);
            abr := new_cellule;
        elsif Abr.all.Cle < Cle then
            Supprimer(Abr.all.Sous_Arbre_Droit, Cle);
        else
            Supprimer(Abr.all.Sous_Arbre_Gauche, Cle);
        end if;
    end Supprimer;


    procedure Vider (Abr : in out T_ABR) is
    begin
        Null;	-- TODO : à changer
    end Vider;


    procedure Afficher (Abr : in T_Abr) is
    begin
        Null;	-- TODO : à changer
    end Afficher;


    procedure Afficher_Debug (Abr : in T_Abr) is
    begin
        Null;	-- TODO : à changer
    end Afficher_Debug;

end ABR;
