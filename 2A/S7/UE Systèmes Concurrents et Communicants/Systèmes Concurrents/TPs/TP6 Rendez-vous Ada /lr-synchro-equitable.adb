with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions;

-- Lecteurs concurrents, approche automate. Pas de politique d'accès.
package body LR.Synchro.Equitable is
   
   function Nom_Strategie return String is
   begin
      return "Equitable, lecteurs concurrents, sans politique d'accès";
   end Nom_Strategie;
   
   task LectRedTask is
      entry Demander_Lecture;
      entry Demander_Ecriture;
      entry Terminer_Lecture;
      entry Terminer_Ecriture;
   end LectRedTask;

   task body LectRedTask is
	type Etat is (R,L);
    EcritureEnCours : boolean := false;
    EtatEnCours : Etat := L;
    Nbl : Natural := 0;
   begin
      loop
         case EtatEnCours is
         when L =>
            while (Nbl > 0) loop
                accept Terminer_Lecture; Nbl := Nbl -1;
            end loop;
                accept Demander_Ecriture; EtatEnCours := R;
         when R =>
            accept Terminer_Ecriture;
            while (Demander_Lecture'count > 0) loop
                accept Demander_Lecture; Nbl := Nbl + 1;
            end loop;
            EtatEnCours := L;
	      end case; 
      end loop;
   exception
      when Error: others =>
         Put_Line("**** LectRedTask: exception: " & Ada.Exceptions.Exception_Information(Error));
   end LectRedTask;

   procedure Demander_Lecture is
   begin
      LectRedTask.Demander_Lecture;
   end Demander_Lecture;

   procedure Demander_Ecriture is
   begin
      LectRedTask.Demander_Ecriture;
   end Demander_Ecriture;

   procedure Terminer_Lecture is
   begin
      LectRedTask.Terminer_Lecture;
   end Terminer_Lecture;

   procedure Terminer_Ecriture is
   begin
      LectRedTask.Terminer_Ecriture;
   end Terminer_Ecriture;

end LR.Synchro.Equitable;