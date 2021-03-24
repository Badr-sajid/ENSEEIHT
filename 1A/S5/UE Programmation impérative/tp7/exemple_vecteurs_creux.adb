with Ada.Text_IO;       use Ada.Text_IO;
with Vecteurs_Creux;    use Vecteurs_Creux;

-- Exemple d'utilisation des vecteurs creux.
procedure Exemple_Vecteurs_Creux is

    V : T_Vecteur_Creux;
begin
    Put_Line ("Début du scénario");
    -- Initialiser le vecteur V
    Initialiser(V);
    Afficher(V);

    -- Verifier si V est null
    pragma Assert(Est_Nul(V));

    -- Detruire le vecteur V
    Detruire(V);

    -- Verifier la composante 18 si elle vaut 0
    pragma Assert(not (Composante_Iteratif(V,18) = 0.0));
    pragma Assert(not (Composante_Recursif(V,18) = 0.0));

    -- Modifier la valeur des composantes 1,2,3

    Put_Line ("Fin du scénario");
end Exemple_Vecteurs_Creux;
