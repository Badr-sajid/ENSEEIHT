with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions;

-- Lecteurs concurrents, approche automate. Pas de politique d'accès.
package body LR.Synchro.Fifo is
   
   function Nom_Strategie return String is
   begin
      return "Fifo, lecteurs concurrents, sans politique d'accès";
   end Nom_Strategie;
   type Etat is (R,L);
   task LectRedTask is
      entry Demander(e : Etat);
      entry Terminer_Lecture;
      entry Terminer_Ecriture;
   end LectRedTask;

   task body LectRedTask is
   EcritureEnCours : boolean := false;
   Nbl : Natural := 0;
   begin
      loop
        select
            when ((not EcritureEnCours) and (Nbl = 0)) => 
                accept Demander(e : Etat) do
                    if (e = L) then Nbl := Nbl + 1;
                    elsif (e = R) then EcritureEnCours := true;
                    end if;
                end Demander;
        or  
            when ((EcritureEnCours)) => 
                accept Terminer_Ecriture; EcritureEnCours := false;
        or 
            when (Nbl >= 1) => 
                accept Terminer_Lecture; Nbl := Nbl - 1;
        end select;

      end loop;
   exception
      when Error: others =>
         Put_Line("**** LectRedTask: exception: " & Ada.Exceptions.Exception_Information(Error));
   end LectRedTask;

   procedure Demander_Lecture is
   begin
      LectRedTask.Demander(L);
   end Demander_Lecture;

   procedure Demander_Ecriture is
   begin
      LectRedTask.Demander(R);
   end Demander_Ecriture;

   procedure Terminer_Lecture is
   begin
      LectRedTask.Terminer_Lecture;
   end Terminer_Lecture;

   procedure Terminer_Ecriture is
   begin
      LectRedTask.Terminer_Ecriture;
   end Terminer_Ecriture;

end LR.Synchro.Fifo;