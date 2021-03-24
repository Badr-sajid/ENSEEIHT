%Une fonction qui permet de calculer le TEB sans bruit pour les 5 chaines 

function TEB = Calcul_TEB (x,t0,Ns,bit)

    % Sous-echantiollage
    y_ech = x(t0:Ns:end);
    
    % Décision
    symboles_decides = sign(y_ech);
    
    % Demapping
    bits_decides = (symboles_decides + 1)/2;
    
    nb_erreur = length(find(bit~=bits_decides));
    TEB = nb_erreur/length(bit);
end



            
    