with Text_IO;
use Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;


procedure drone is
    choix: Character;
    altitude : Integer;
    etat_drone : Integer
begin
    altitude := 0;
    etat_drone := 0
    loop 
    	put("Que faire ? ");
    	Get(choix);
	case drone is
	    when "d" 		=> etat_drone := 1;
	    when "m"		=> if etat_drone = 1 and altitude/=5 then
					altitude := altitude + 1;
				   end if;
	    when "s"		=> if etat_drone = 1 and altitude/=0 then
					altutude := altitude - 1:
				   elsif altitude = 0 then
				       put("le drone est déjà en 0");
				   end if;
	end case

