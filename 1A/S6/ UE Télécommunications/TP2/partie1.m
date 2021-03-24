%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Télécommunications
% Études de chaines de transmission en bande de base
% Auteur : Sajid Badr , Akby Amine , Elbouchibti Ayman
%--------------------------------------------------------------------------


clear all; close all;

%% Déclaration des variables
    % Nombre de bits à générer 
    N_bits = 10000;
    
    % Facteur de suréchantillonage
    Ns = 8;
    
    % Constellation
    M = 4;
    
    % Fréquence porteuse 
    fp = 2000;
    
    % Fréquence d'échantillonnage
    Fe = 10000;
    
    % Roll off
    alpha = 0.35;
    
    %SPAN
    span = 4;
    
    % Facteur de suréchantillonage
    Eb_N0 = linspace(0,6,7);
    Eb_N0_dB = 10.^(Eb_N0/10);
 
    % Génération des bits
    bits = randi([0,1],1,N_bits);
    
%%
%--------------------------------------------------------------------------
% Chaine sur fréquence porteuse
%--------------------------------------------------------------------------

% Question 1 :
 
    % Mapping
    symboles =  ( 2*bits(1:2:end) - 1 ) + 1i*( 2*bits(2:2:end) - 1 );
    
    % cos surélevé
    h = rcosdesign(alpha, span,Ns,'sqrt');
    hr = fliplr(h);
    retard = span*Ns/2;
    % filtre passe bas
    h_passe_bas = ones(1,3);
    
    % Filtrage de récéption :
    % Suréchantillonnage
    dirac = kron(symboles,[1 zeros(1,Ns-1)]);
    
    % Mise en forme du signal
    xe = filter(h,1,[dirac zeros(1,retard)]);
    xe = xe(retard+1:end);
    
    % Signal généré sur les voies en phase
    I1 = real(xe);
    figure(1);
    plot(I1);
    title('Figure 1 : Signal généré sur les voies en phase');
    
    % Signal généré sur les voies en quadrature
    Q1 = imag(xe);
    figure(2);
    plot(Q1);
    title('Figure 2 : Signal généré sur les voies en quadrature');
    
    % Transposition de fréquence
    t1 = (1:length(xe))/Fe;
    x1 = real(xe.*exp(2i*pi*fp*t1));
    % Visualisation du signal transmis sur fréquence porteuse
    figure(3);
    plot(x1);
    title('Figure 3 : Signal transmis sur fréquence porteuse');
    
% Question 2 :
    % Estimation par périodogramme et visualisation la densité spectrale 
    % de puissance du signal modulé sur fréquence porteuse.
    DSP_porteuse1 = periodogram(x1);
    figure(4);
    plot(DSP_porteuse1);
    ylabel('DSP');
    title('Figure 4 :densité spectrale de puissance du signal modulé sur fréquence porteuse');
    
% Question 3 :
    % Construction de la chaine complète sans bruit
    % Retour en bande de base
    x1_cos = x1.*cos(2*pi*fp*t1);
    x1_sin = x1.*sin(2*pi*fp*t1);
    ycos1 = filter(h_passe_bas,1,x1_cos);
    ysin1 = filter(h_passe_bas,1,x1_sin);
    s1 = ycos1 - j*ysin1;
    
    % Filtrage de récéption
    y1 = filter(hr,1,[s1 zeros(1,retard)]);
    y1 = y1(retard+1:end);
    
    % Echantiollage
    y_ech1 = y1(1:Ns:end);
    
    % Décision
    symboles_decides_real1 = sign(real(y_ech1));
    symboles_decides_Im1 = sign(imag(y_ech1));
    
    % Demapping
    bits_real1 = (symboles_decides_real1 + 1)/2;
    bits_Im1 = (symboles_decides_Im1 + 1)/2;
    bits_decides1 = zeros(1,N_bits);
    bits_decides1(1:2:end) = bits_real1;
    bits_decides1(2:2:end) = bits_Im1;
    
    nb_erreur1 = length(find(bits~=bits_decides1));
    TEB_1 = nb_erreur1/N_bits;
    fprintf("TEB de la chaine sur fréquence porteuse sans bruit est : %f\n",TEB_1);
    
  
% Question 4 :
    % Construction de la chaine complète avec bruit
    TEB_bruit_1 = [];
        for j = 1:length(Eb_N0)
            % Calcul de sigma_n^2
            sigma_n_carre_1 = mean(abs(x1).^2)*Ns/(2*log2(M))/Eb_N0_dB(j);
            Bruit_1 = sqrt(sigma_n_carre_1) * randn(1, length(x1));
    
            % Ajout de bruit 
            signal_bruite_1 = x1 + Bruit_1;
            
            % Retour en bande de base
            x_cos_bruit_1 = signal_bruite_1.*cos(2*pi*fp*t1);
            x_sin_bruit_1 = signal_bruite_1.*sin(2*pi*fp*t1);
            
            ycos_bruit_1 = filter(h_passe_bas,1,x_cos_bruit_1);
            ysin_bruit_1 = filter(h_passe_bas,1,x_sin_bruit_1);
            s_bruit_1 = ycos_bruit_1 - 1i*ysin_bruit_1;
    
            % Signal à la sortie de filtre de récéption
            yb1 = filter(hr,1,[s_bruit_1 zeros(1,retard)]);
            yb1 = yb1(retard+1:end);
    
            
            % Echantiollage
            y_ech1 = yb1(1:Ns:end);

            % Décision
            symboles_decides_real1 = sign(real(y_ech1));
            symboles_decides_Im1 = sign(imag(y_ech1));

            % Demapping
            bits_real1 = (symboles_decides_real1 + 1)/2;
            bits_Im1 = (symboles_decides_Im1 + 1)/2;
            bits_decides1 = zeros(1,N_bits);
            bits_decides1(1:2:end) = bits_real1;
            bits_decides1(2:2:end) = bits_Im1;

            nb_erreur1 = length(find(bits~=bits_decides1));
            TEB_b_1 = nb_erreur1/N_bits;

            %Calcul du TEB
            TEB_bruit_1 = [TEB_bruit_1, TEB_b_1];
        end
        
    % Tracé du taux d’erreur binaire en fonction de Eb/N0
    figure(5);
    semilogy(Eb_N0, TEB_bruit_1, 'r-');
    title('Figure 5 : Taux d''erreur binaire de la chaine sur fréquence porteuse ');
    xlabel('Eb/N0 (dB)');
    ylabel('TEB');
    
% Question 5 :
    % TEB théorique
    TEB_th = qfunc(sqrt(2*Eb_N0_dB));
    % Comparaison du TEB simulé et TEB théorique
    hold on;
    semilogy(Eb_N0, TEB_th, 'g-');
    legend('TEB simulé','TEB théorique');
    

%%
%--------------------------------------------------------------------------
% chaine passe-bas équivalente
%--------------------------------------------------------------------------

% Question 1 :

    % Signal généré sur les voies en phase
    I2 = real(xe);
    figure(6);
    plot(I2);
    title('Figure 6 : Signal généré sur les voies en phase');
    
    % Signal généré sur les voies en quadrature
    Q2 = imag(xe);
    figure(7);
    plot(Q2);
    title('Figure 7 : Signal généré sur les voies en quadrature');

% Question 2 :
    % Estimation par périodogramme et visualisation la densité spectrale 
    % de puissance de l’enveloppe complexe.
    DSP_porteuse2 = periodogram(xe);
    figure(8);
    plot(fftshift(DSP_porteuse2));
    ylabel('DSP');
    title('Figure 8 :densité spectrale de puissance de l’enveloppe complexe');
    
    % Comparaison DSP de l’enveloppe complexe et DSP du signal sur fréquence porteuse
    figure(9);
    plot(DSP_porteuse1,'g');hold on
    plot(fftshift(DSP_porteuse2),'r');
    ylabel('DSP');
    title('Figure 9 : Comparaison la densité spectrale de puissance des deux chaines');
    legend('Chaine sur fréquence porteuse','Chaine passe-bas équivalente');

% Question 3 :
    % Filtrage de récéption
    y2 = filter(hr,1,[xe zeros(1,retard)]);
    y2 = y2(retard+1:end);
    
    % Echantiollage
    y_ech2 = y2(1:Ns:end);
    
    % Décision
    symboles_decides_real2 = sign(real(y_ech2));
    symboles_decides_Im2 = sign(imag(y_ech2));
    
    % Demapping
    bits_real2 = (symboles_decides_real2 + 1)/2;
    bits_Im2 = (symboles_decides_Im2 + 1)/2;
    bits_decides2 = zeros(1,N_bits);
    bits_decides2(1:2:end) = bits_real2;
    bits_decides2(2:2:end) = bits_Im2;
    
    nb_erreur2 = length(find(bits~=bits_decides2));
    TEB_2 = nb_erreur2/N_bits;
    fprintf("TEB de la chaine passe-bas équivalente sans bruit est : %f\n",TEB_2);

    
% Question 4 :
    % Construction de la chaine complète avec bruit
    TEB_bruit_2 = [];
        for j = 1:length(Eb_N0)
            % Calcul de sigma_n^2
            sigma_n_carre_2 = mean(abs(xe).^2)*Ns/(2*log2(M))/Eb_N0_dB(j);
            n = sqrt(sigma_n_carre_2) * (randn(1, length(real(xe))));
            nq = sqrt(sigma_n_carre_2) * (randn(1, length(imag(xe))));
            ne = n + 1i*nq;
            
            % Ajout de bruit 
            signal_bruite_2 = xe + ne;
    
            % Signal à la sortie de filtre de récéption
            yb2 = filter(h,1,[signal_bruite_2 zeros(1,retard)]);
            yb2 = yb2(retard+1:end);
            
            % Echantiollage
            y_ech2 = yb2(1:Ns:end);

            % Décision
            symboles_decides_real2 = sign(real(y_ech2));
            symboles_decides_Im2 = sign(imag(y_ech2));

            % Demapping
            bits_real2 = (symboles_decides_real2 + 1)/2;
            bits_Im2 = (symboles_decides_Im2 + 1)/2;
            bits_decides2 = zeros(1,N_bits);
            bits_decides2(1:2:end) = bits_real2;
            bits_decides2(2:2:end) = bits_Im2;

            nb_erreur2 = length(find(bits~=bits_decides2));
            TEB_b_2 = nb_erreur2/N_bits;
            
            %Calcul du TEB
            TEB_bruit_2 = [TEB_bruit_2, TEB_b_2];
        end
        
    % Tracé du taux d’erreur binaire en fonction de Eb/N0
    figure(10);
    semilogy(Eb_N0, TEB_bruit_2, 'r-');
    title('Figure 10 : Taux d''erreur binaire de la chaine passe-bas équivalente');
    xlabel('Eb/N0 (dB)');
    ylabel('TEB');
    
% Question 5 :
    % Constellations en sortie du mapping 
    figure(11);
    plot(real(dirac),imag(dirac),'ored','linewidth',3);
    title('Figure 11 : Constellations en sortie du mapping');
    xlim([-2 2]);
    ylim([-2 2]);
    % Constellations en sortie de l’échantillonneur
    figure(12);
    plot(real(y_ech2),imag(y_ech2),'ored','linewidth',3);
    xlim([-2 2]);
    ylim([-2 2]);
    title('Figure 12 : Constellations en sortie de l’échantillonneur');
% Question 6 :
    % Comparaison de la TEB des deux chaines
    figure(13);
    semilogy(Eb_N0, TEB_bruit_1, '-r+'); hold on
    semilogy(Eb_N0, TEB_bruit_2, '-g+');hold on
    title('Figure 13 : Comparaison la densité spectrale de puissance des deux chaines');
    legend('Chaine sur fréquence porteuse','Chaine passe-bas équivalente');
