with Ensembles_Tableau;
with Alea;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

procedure nombre_moyen_tirage_tableau is
    min : Constant := 20;
    max : Constant := 80;

    package ensemble_entier is
            new Ensembles_Tableau (T_Element => Integer, Capacite => max-min+1);
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
        while taille_ensemble(Ens) < (max - min +1) loop
            Get_Random_Number (nombre_tire);
            if not existe(Ens,nombre_tire) then
                ajouter_element(Ens,nombre_tire);
            end if;
            compteur := compteur + 1;
        end loop;
        Initialiser(ens);
        somme_compteur := somme_compteur + compteur;
    end loop;
    moyenne := Float(somme_compteur)/Float(100);
    put("la moyenne est : ");Put(moyenne,1,0,0);

end Nombre_Moyen_Tirage_Tableau;

