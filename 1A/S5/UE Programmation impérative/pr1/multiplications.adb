--------------------------------------------------------------------------------
--  Auteur   : Sajid Badr
--  Objectif : Reviser la table de multiplication
--------------------------------------------------------------------------------

with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Calendar;          use Ada.Calendar;
With Alea;
--Reviser la table de multiplication
procedure Multiplications is
	Table : Integer;     			-- la table à réviser
	Resultat : Integer; 	 		-- la réponse de l'opération entrée par l'utilisateur
	Nombre_a_Reviser : Integer;     	-- la table à réviser
	Erreur : Integer;    			-- le nombre de faute commise
	Temps : Duration;       			-- le temps de la révision
	Max_Delai : Duration;  	 		-- la plus grande durée des opérations faite
	Moyenne : Duration;     			-- le temps moyen
	Debut: Time;         			-- heure de début de l'opération
	Fin: Time;           			-- heure de fin de l'opération
  	Delai : Duration;    			-- durée de l'opération
	Reponse : Character; 			-- la réponse pour continuer ou non 
	package Mon_Alea is
	    new Alea (1, 10);  			-- générateur de nombre dans l'intervalle [1, 10]
	use Mon_Alea;
	Nombre: Integer;			-- le nombre de droite de la multiplication
begin
	loop			
	    --Demander la table à réviser.
	    Put ("Table à réviser : ");
	    Get (Table);
	    while Table > 10 or Table < 1 loop
		Put ("La table à réviser doit être comprise entre 1 et 10 ");
		Get (Table);
	    end loop;
	    --Répondre à 10 opérations
	    Temps := Duration(0);				--initialisation du temps de l'operation
	    Max_Delai := Duration(0);			--initialisation du délai maxumum
	    Erreur := 0;			--initialisation du nobre d'erreur
	    for I in 1..10 loop
		Get_Random_Number (Nombre); 	-- choisir un entier aléatoire entre 1 et 10
		Put (Table);Put( "x");Put( Nombre);Put( "=");
		-- calculer le temps de chaque opération
		Debut := clock;			-- récupérer l'heure (heure de début)
		Get (Resultat);			-- saisie de la réponse de l'opération
		Fin := Clock;			-- récupérer l'heure (heure de fin)
		Skip_Line;
		Delai := Fin - Debut;		-- calculer la durée de l'opération
		Temps := Temps + Delai;		-- mettre à jour le temps de l'opération
		if Delai > Max_Delai then
		    Max_Delai := Delai;		-- mettre à jour le maximum des délais
		    Nombre_a_Reviser := Nombre;	--mettre à jour le nombre à réviser
		end if;
		-- Commenter le résultat de chaque opératon
		if Resultat = (Table*Nombre) then
		    Put ("Bravo!");		--Resultat est vrai
		    Skip_Line;
		else
		    put ("mauvaise réponse.");	--Résultat est faux
		    Skip_Line;
		    Erreur := Erreur + 1;	--incrementer le nombre de fautes
		end if;
	    end loop;                           -- fin de la revision de la table choisie
	    -- Conclure à propos de la révision de la table
	    -- -- A propos de nombre de fautes 
	    case Erreur is
		when  0 	=> Put ("Aucune erreur. Excellent !");Skip_Line;
		when  1	=> Put ("Une seule erreur. Très bien.");Skip_Line;
		when  10	=> Put ("Tout est faux ! Volontaire ? ");Skip_Line;
		when others => Put (Erreur);Put(" erreurs. Il faut encore travailler la table de "); Put(Table);Skip_Line;
		
	    end case;
	    if Erreur > 5 then
		Put ("seulement"); Put(10-Erreur); Put(" bonnes réponses. Il faut apprendre la table de");Put(Table);
	    	Skip_Line;
	    end if;
	    -- A propos du temps
	    Moyenne := Temps / 10;
	    if Max_Delai > (Moyenne + 1.0) then
		Put ("Des hésitations sur la table de "); Put ( Nombre_a_Reviser); Put (" : "); Put ( Duration'Image(Max_Delai) ); Put ("secondes contre"); Put ( Duration'Image(Moyenne) ); Put ("en moyenne. Il faut certainement la réviser.");
		Skip_Line;
	    end if;
	    Put ("Continuer la revision(o/n)? ");-- demander de continuer la révision
	    Get (Reponse);
	exit when Reponse = 'n' or Reponse = 'N';--finir tout la révision et fin du programme
	end loop;
end Multiplications;
