with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;

-- Auteur: 
-- Gérer un stock de matériel informatique.
--
package body Stocks_Materiel is

    procedure Creer (Stock : out T_Stock) is
    begin
        stock.nombre := 0;
                
    end Creer;
    

    function Nb_Materiels (Stock: in T_Stock) return Integer is
    begin
        return stock.nombre;
    end;


    procedure Enregistrer (
            Stock        : in out T_Stock;
            Numero_Serie : in     Integer;
            Nature       : in     T_Nature;
            Annee_Achat  : in     Integer
        ) is
    begin
        stock.stok(1).numero_serie := Numero_Serie;
        stock.stok(1).nature := Nature;
        stock.stok(1).annee := Annee_Achat;
        stock.nombre := stock.nombre + 1;
    end;


end Stocks_Materiel;
