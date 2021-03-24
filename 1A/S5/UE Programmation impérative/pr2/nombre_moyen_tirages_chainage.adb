with Ensembles_Chainage;
with Alea;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Nombre_Moyen_Tirage_Chainage is
    min : Constant := 20;
    max : Constant := 30;

    package ensemble_entier is
            new Ensembles_Chainage (T_Element => Integer);
    use ensemble_entier;

    package Mon_Alea is new Alea(min,max);
    use Mon_Alea;

    Ens : T_Ensemble;
    moyenne : Float;
    compteur : Integer;
    somme_compteur : Integer := 0;
    nombre_tire : Integer;
begin
    Initialiser(Ens);
    for i in 1..100 loop
        compteur := 0;
        while taille_ensemble(Ens) /= (max - min +1) loop
            Get_Random_Number (nombre_tire);
            if not existe(Ens,nombre_tire) then
                ajouter_element(Ens,nombre_tire);
            end if;
            compteur := compteur + 1;
        end loop;
        Initialiser(Ens);
        somme_compteur := somme_compteur + compteur;
    end loop;
    moyenne := Float(somme_compteur)/Float(100);
    put("la moyenne est : ");Put(moyenne,1,3,0);
    detruire(Ens);
end Nombre_Moyen_Tirage_Chainage;
