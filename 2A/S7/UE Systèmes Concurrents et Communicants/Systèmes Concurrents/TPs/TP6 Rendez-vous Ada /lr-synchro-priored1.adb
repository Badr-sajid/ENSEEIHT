with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions;

-- Lecteurs concurrents, approche automate. Pas de politique d'accès.
package body LR.Synchro.PrioRed1 is
   
   function Nom_Strategie return String is
   begin
      return "Automate, lecteurs concurrents, priorité redacteur";
   end Nom_Strategie;
   
   task LectRedTask is
      entry Demander_Lecture;
      entry Demander_Ecriture;
      entry Terminer_Lecture;
      entry Terminer_Ecriture;
   end LectRedTask;

   task body LectRedTask is

   type Etat is (EtatLibre, EtatEcriture, EtatLecture);
   EcritureEnCours : boolean := false;
   Nbl : Natural := 0;
   begin
      loop
         case EtatEnCours is
         when EtatLibre =>
            select
               when (Demander_Ecriture'count = 0) =>
               accept Demander_Lecture; Nbl := 1; EtatEnCours := EtatLecture;
            or 
               accept Demander_Ecriture; EtatEnCours := EtatEcriture;
            end select;

         when EtatLecture =>
         select
               when (Demander_Ecriture'count = 0) =>
               accept Demander_Lecture; Nbl := Nbl + 1; EtatEnCours := EtatLecture;
            or 
               accept Terminer_Lecture; Nbl := Nbl -1;
               if Nbl = 0 then EtatEnCours := EtatLibre; end if;
            end select;

         when EtatEcriture =>
         select
               accept Terminer_Ecriture; EtatEnCours := EtatLibre;
            end select;

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

end LR.Synchro.PrioRed1;
