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
    
    % Sous-echantiollage
    t0 = Ns;
    
    % Facteur de suréchantillonage
    Eb_N0_dB = linspace(0,6,7);
    
%%
%--------------------------------------------------------------------------
% Première chaine à étudier : "chaine de référence"
%--------------------------------------------------------------------------

% Données de la première chaine
    % Réponse inmpulsionnelle du filtre d'émission
    h_1 = ones(1,Ns);
    hr_1 = fliplr(h_1);
    
% Question 1 :
    % Génération des bits
    bits = randi([0,1],1,N_bits);
    
    % Mapping
    symboles = 2*bits - 1;

    % Suréchantillonage
    dirac_1 = kron(symboles,[1 zeros(1,Ns-1)]);
    
    % Filtrage
    x = filter(h_1,1,dirac_1);
    
    % Visualisation
    figure(1);
    plot(x);
    axis([1,100,-2,2]);
    title('Figure 1 : Signal transmis');

    % Calcul de la densité spectrale de puissance du signal transmis
    figure(2);
    NFFT = 2^(nextpow2(length(x))+2);
    DSP_1 = 1/length(x)*(abs(fft(x,NFFT)).^2);
    freq = linspace(-1/4,1/4,NFFT);
    plot(freq,fftshift(DSP_1));
    ylabel('DSP');
    xlabel('Fréquence normalisée par rapport à Rs');
    title('Figure 2 : la densité spectrale de puissance du signal transmis de la chaine 1');
    
% Question 2 :
    % (a) Filtrage de récéption :
    figure(3);
    y_1 = filter(hr_1,1,x);
    plot(y_1);
    axis([1,50,-10,10]);
    title('Figure 3 : Signal en sortie de filtre de récéption de la chaine 1');
    ylabel('signal en sortie de filtre de récéption');
    
    % (b) Diagramme de l’oeil :
    figure(4);
    eyeDiagram(y_1,Ns);
    title('Figure 4 : Diagramme de l''oeil de la chaine 1');
    xlabel('temps en (s)');
    ylabel('Diagramme de l''oeil');
    
    % (c) Le taux d’erreur binaire :
    TEB_1 = Calcul_TEB(y_1,t0,Ns,bits)
    
% Question 3 : 
    % Implantation de la chaine avec bruit
    TEB_bruit_1 = [];
        for i = 1:length(Eb_N0_dB)
            sigma_n_carre = mean(x.^2)*Ns/2/10^(Eb_N0_dB(i)/10);
            Bruit = sqrt(sigma_n_carre) * randn(1, length(x));
    
            % Ajout de bruit 
            signal_bruite = x + Bruit;
    
            % passer le signal bruité dans le filtre de récéption
            yb_1 = filter(hr_1,1,signal_bruite);
    
            %Calcul du TEB
            TEB_b = Calcul_TEB (yb_1,t0,Ns,bits);
            TEB_bruit_1 = [TEB_bruit_1, TEB_b];
        end
    
    % Tracé du taux d’erreur binaire en fonction de Eb/N0
    figure(5);
    semilogy(Eb_N0_dB, TEB_bruit_1, 'r-');
    title('Figure 5 : Taux d''erreur binaire de la chaine 1');
    xlabel('Eb/N0 (dB)');
    ylabel('TEB');
    
% Question 4 :
        % TEB théorique
        TEB_th_1 = qfunc(sqrt(2*10.^(Eb_N0_dB/10)));
        
        % Comparaison du TEB simulé et TEB théorique
        hold on;
        semilogy(Eb_N0_dB, TEB_th_1, 'g-');
        legend('TEB simulé','TEB théorique');

%%
%--------------------------------------------------------------------------
% Deuxième chaine à  étudier : impact du choix du filtre de réception
%--------------------------------------------------------------------------

% Données de la deuxième chaine
    % Réponse inmpulsionnelle du filtre d'émission
    hr_2 = zeros(1,Ns);
    hr_2(1:4) = ones(1,4);

% Question 1 : Implantation de la chaine sans bruit
    % (a) Filtrage de récéption :
    figure(6);
    y_2 = filter(hr_2,1,x);
    plot(y_2);
    axis([1,50,-10,10]);
    title('Figure 6 : Signal en sortie de filtre de récéption de la chaine 2');
    ylabel('signal en sortie de filtre de récéption');
    
    % (b) Diagramme de l’oeil :
    figure(7);
    eyeDiagram(y_2,Ns);
    title('Figure 7 : Diagramme de l''oeil de la chaine 2');
    xlabel('temps en (s)');
    ylabel('Diagramme de l''oeil');
    
    % (c) Le taux d’erreur binaire :
    TEB_2 = Calcul_TEB(y_2,t0,Ns,bits)
    
% Question 2 : 
% Implantation de la chaine avec bruit
    TEB_bruit_2 = [];
        for i = 1:length(Eb_N0_dB)
            sigma_n_carre = mean(x.^2)*Ns/2/10^(Eb_N0_dB(i)/10);
            Bruit = sqrt(sigma_n_carre) * randn(1, length(x));
    
            % Ajout de bruit 
            signal_bruite = x + Bruit;
    
            % passer le signal bruité dans le filtre de récéption
            yb_2 = filter(hr_2,1,signal_bruite);
    
            %Calcul du TEB
            TEB_b = Calcul_TEB (yb_2,t0,Ns,bits);
            TEB_bruit_2 = [TEB_bruit_2, TEB_b];
        end
    
    % Tracé du taux d’erreur binaire en fonction de Eb/N0
    figure(8);
    semilogy(Eb_N0_dB, TEB_bruit_2, 'r-');
    title('Figure 8 : Taux d''erreur binaire de la chaine 2');
    xlabel('Eb/N0 (dB)');
    ylabel('TEB');
    
% Question 3 :
    % TEB théorique
    TEB_th_2 = qfunc(sqrt(10.^(Eb_N0_dB/10)));

    % Comparaison du TEB simulé et TEB théorique
    hold on;
    semilogy(Eb_N0_dB, TEB_th_2, 'g-');
    legend('TEB simulé','TEB théorique');

% Question 4 :
    % Comparaison du TEB simulé pour la chaine de transmission 
    % et TEB théorique de la chaine de référence
    figure(9);
    semilogy(Eb_N0_dB, TEB_bruit_2, 'r-');hold on;
    semilogy(Eb_N0_dB, TEB_th_1, 'b-');
    title('Figure 9 : Taux d''erreur binaire de la chaine 1 et 2');
    xlabel('Eb/N0 (dB)');
    ylabel('TEB');
    legend('TEB chaine 2','TEB chaine 1');
    
% Question 5 :
    % Calcul DSP de la chaine 1 et 2
    figure(10);
    NFFT = 2^(nextpow2(length(x))+2);
    DSP_2 = 1/length(x)*(abs(fft(x,NFFT)).^2);
    freq = linspace(-1/4,1/4,NFFT);
    plot(freq,fftshift(DSP_1),'b-');hold on;
    plot(freq,fftshift(DSP_2),'g-');
    ylabel('DSP');
    xlabel('Fréquence normalisée par rapport à Rs');
    legend('DSP chaine 1','DSP chaine 2');
    title('Figure 10 : la densité spectrale de puissance du signal transmis de la chaine 1 et 2');
    
%%
%--------------------------------------------------------------------------
% Troisième chaine à étudier : impact du choix du filtre de mise 
% en forme et d’un canal de propagation à bande limitée
%--------------------------------------------------------------------------

% Données de la troisième chaine
    % Fréquence d'échantillonnage
    Fe = 12000;

    % Rythm symbole
    Rs = 3000;
    
    % Roll off
    alpha = 0.5;
    
    %SPAN
    span = 4;
    
    % cos surélevé
    h_3 = rcosdesign(alpha, span,Ns);
    hr_3 = fliplr(h_3);
    retard = span*Ns/2;
    
% Question 2 :
    % (b) Filtrage de récéption :
    % Suréchantillonnage
    dirac_3 = kron(symboles,[1 zeros(1,Ns-1)]);
    
    % Filtrage
    x_3 = filter(h_3,1,[dirac_3 zeros(1,retard)]);
    x_3 = x_3(retard+1:end);
    
    % Visualisation
    figure(11);
    plot(x_3);
    axis([0,length(x)- 1,-1,1]);
    title('Figure 11 : Signal transmis');
    
    % Signal à la sortie de filtre de récéption
    y_3 = filter(hr_3,1,[x_3 zeros(1,retard)]);
    y_3 = y_3(retard+1:end);
    figure(12);
    plot(y_3)
    axis([0,100,-2,2]);
    title('Figure 12 : Signal en sortie de filtre de récéption');
    ylabel('signal en sortie de filtre de récéption');
    
    % (c) Diagramme de l’oeil :
    figure(13);
    eyeDiagram(y_3,Ns);
    title('Figure 13 : Diagramme de l''oeil de la chaine 3');
    xlabel('temps en (s)');
    ylabel('Diagramme de l''oeil');
    
    % (d) Le taux d’erreur binaire :
    TEB_3 = Calcul_TEB(y_3,1,Ns,bits)
    
% Question 3 :
% Implantation de la chaine avec bruit
    TEB_bruit_3 = [];
        for i = 1:length(Eb_N0_dB)
            sigma_n_carre = mean(x_3.^2)*Ns/2/10^(Eb_N0_dB(i)/10);
            Bruit = sqrt(sigma_n_carre) * randn(1, length(x_3));
    
            % Ajout de bruit 
            signal_bruite = x_3 + Bruit;
    
            % passer le signal bruité dans le filtre de récéption
            yb_3 = filter(hr_3,1,[signal_bruite zeros(1,retard)]);
            yb_3 = yb_3(retard+1:end);
    
            %Calcul du TEB
            TEB_b = Calcul_TEB (yb_3,1,Ns,bits);
            TEB_bruit_3 = [TEB_bruit_3, TEB_b];
        end
        
% Tracé du taux d’erreur binaire en fonction de Eb/N0
    figure(14);
    semilogy(Eb_N0_dB, TEB_bruit_3, 'r-');
    title('Figure 14 : Taux d''erreur binaire de la chaine 3');
    xlabel('Eb/N0 (dB)');
    ylabel('TEB');
    
% Question 4 :
    % TEB théorique
    TEB_th_3 = qfunc(sqrt(2*10.^(Eb_N0_dB/10)));
    % Comparaison du TEB simulé et TEB théorique
    hold on;
    semilogy(Eb_N0_dB, TEB_th_3, 'g-');
    legend('TEB simulé','TEB théorique');
    
% Question 5 :
    % Comparaison du TEB simulé pour la chaine de transmission 
    % et TEB théorique de la chaine de référence
    figure(15);
    semilogy(Eb_N0_dB, TEB_bruit_3, 'r-');hold on;
    semilogy(Eb_N0_dB, TEB_th_1, 'b-');
    title('Figure 15 : Taux d''erreur binaire de la chaine 1 et 3');
    xlabel('Eb/N0 (dB)');
    ylabel('TEB');
    legend('TEB chaine 3','TEB chaine 1');
    
% Question 6 :
    % Calcul DSP de la chaine 1 et 3
    figure(16);
    NFFT = 2^(nextpow2(length(x))+2);
    DSP_3 = 1/length(x_3)*(abs(fft(x_3,NFFT)).^2);
    freq = linspace(-1/4,1/4,NFFT);
    plot(freq,fftshift(DSP_1),'g-');hold on;
    plot(freq,fftshift(DSP_3),'r-');
    ylabel('DSP');
    xlabel('Fréquence normalisée par rapport à Rs');
    legend('DSP chaine 1','DSP chaine 3');
    title('Figure 16 : la densité spectrale de puissance du signal transmis de la chaine 1 et 3');
    
% Question 7 :
    % Données :
    Fc1 = 1500;  
    N = 40;
    k = [-N : N] ;
    Te = 1/Fe;
    f_1 = Fc1/Fe;
   
    Fc2 = 3000;  
    f_2 = Fc2/Fe;
    % (a) 1er cas

    s = 2*f_1*sinc(2*f_1*k);     
    signal = conv(x_3,s,'same');
    signal_filtre = filter(h_3,1,signal);
    Temps = [0:Te:(length(signal)-1)*Te];
    figure(17);
    plot(Temps,signal_filtre);
    title('Figure 17 : Le signal avec Fc = 1500');
    xlabel('temps en s');
    ylabel('z');
    
    figure(18);
    eyeDiagram(signal_filtre,Ns);
    title('Figure 18 : Diagramme de l''oeil avec Fc = 1500');
    xlabel('temps en (s)');
    ylabel('Diagramme de l''oeil'); 
   
 % (b) 2ème cas
    s = 2*f_2*sinc(2*f_2*k);     
    signal = conv(x_3,s,'same');
    signal_filtre = filter(h_3,1,signal);
    Temps = [0:Te:(length(signal)-1)*Te];
    figure(19);
    plot(Temps,signal_filtre);
    title('Figure 19 : Le signal avec Fc = 3000');
    xlabel('temps en s');
    ylabel('z');
    
    figure(20);
    eyeDiagram(signal_filtre,Ns);
    title('Figure 20 : Diagramme de l''oeil avec Fc = 3000');
    xlabel('temps en (s)');
    ylabel('Diagramme de l''oeil');

%%
%--------------------------------------------------------------------------
% Quatrième chaine à  étudier : impact du choix du mapping
%--------------------------------------------------------------------------

% Données de la quatrième chaine :
    % Réponse inmpulsionnelle du filtre d'émission
    h_4 = ones(1,Ns);
    hr_4 = h_4;
    
    
% Question 1 : Implantation de la chaine sans bruit :
    
    % Mapping
    symboles_4 = (2*bi2de(reshape(bits, 2, length(bits)/2).') - 3).';

    % Suréchantillonage
    dirac_4 = kron(symboles_4,[1 zeros(1,Ns-1)]);
    
    % Filtrage
    x_4 = filter(h_4,1,dirac_4);
    
    % Visualisation
    figure(21);
    plot(x_4);
    axis([1,100,-4,4]);
    title('Figure 21 : Signal transmis de la chaine 4');
    
    % (a) Le signal en sortie du filtre d'émission
    % Signal à la sortie de filtre de récéption
    y_4 = filter(hr_4,1,x_4);
    figure(22);
    plot(y_4)
    axis([1,100,-30,30]);
    title('Figure 22 : Signal en sortie de filtre de récéption');
    ylabel('signal en sortie de filtre de récéption');
    
    % Calcul de la densité spectrale de puissance du signal transmis
    figure(23);
    NFFT = 2^(nextpow2(length(x_4))+2);
    DSP_4 = 1/length(x_4)*(abs(fft(x_4,NFFT)).^2);
    freq_4 = linspace(-1/4,1/4,NFFT);
    plot(freq_4,fftshift(DSP_4));
    ylabel('DSP');
    xlabel('Fréquence normalisée par rapport à Rs');
    title('Figure 23 : la densité spectrale de puissance du signal transmis de la chaine 4');
    
    % (b) Comparaison des densités spéctrales de puissance
    figure(24);
    plot(freq,fftshift(DSP_1));hold on;
    plot(freq_4,fftshift(DSP_4));
    ylabel('DSP');
    xlabel('Fréquence normalisée par rapport à Rs');
    legend('DSP chaine 1','DSP chaine 4');
    title('Figure 24 : la densité spectrale de puissance du signal transmis de la chaine 1 et 4'); 
    
    % (c) Diagramme de l’oeil :
    figure(25);
    eyeDiagram(y_4,Ns/2);
    title('Figure 25 : Diagramme de l''oeil de la chaine 4');
    xlabel('temps en (s)');
    ylabel('Diagramme de l''oeil');
    
    % (d) Le taux d’erreur binaire :
    
    % Sous-echantiollage
    y_ech = y_4(Ns:Ns:end);

    symboles_decides = zeros(1,length(y_ech));
    for i=1:length(y_ech)
        if (y_ech(i)>2*Ns)
            symboles_decides(i) = 3;
        elseif (y_ech(i) >= 0)
            symboles_decides(i) = 1;
        elseif (y_ech(i) < -2*Ns)
            symboles_decides(i) = -3;
        else
            symboles_decides(i) = -1;
        end
    end
    
    
    % Demapping
    bits_decides = reshape(de2bi((symboles_decides+3)/2).',1,N_bits);
    
    nb_erreur = length(find(bits~=bits_decides));
    TEB_4 = nb_erreur/length(bits)
    
% Question 2 :
% Implantation de la chaine avec bruit
    TES_bruit_4 = [];
    TEB_bruit_4 = [];
        for i = 1:length(Eb_N0_dB)
            sigma_n_carre = mean(x_4.^2)*Ns/(4*10^(Eb_N0_dB(i)/10));
            Bruit = sqrt(sigma_n_carre) * randn(1, length(x_4));
    
            % Ajout de bruit 
            signal_bruite = x_4 + Bruit;
    
            % passer le signal bruité dans le filtre de récéption
            yb_4 = filter(hr_4,1,signal_bruite);
            
            % Sous-echantiollage
            y_ech = yb_4(Ns:Ns:end);

            symboles_decides = zeros(1,length(y_ech));
            for j=1:length(y_ech)
                if (y_ech(j)>2*Ns)
                    symboles_decides(j) = 3;
                elseif (y_ech(j) >= 0)
                    symboles_decides(j) = 1;
                elseif (y_ech(j) < -2*Ns)
                    symboles_decides(j) = -3;
                else
                    symboles_decides(j) = -1;
                end
            end
            
            % Calcul TES
            nb_erreur = length(find(symboles_4~=symboles_decides));
            TES_b = nb_erreur/length(symboles_4);
            TES_bruit_4 = [TES_bruit_4, TES_b];
            
            % Calcul TEB
            % Demapping
            TEB_b =TES_b/2;
            TEB_bruit_4 = [TEB_bruit_4, TEB_b];
        end
        
% Tracé du taux d’erreur symbolique en fonction de Eb/N0
    figure(26);
    semilogy(Eb_N0_dB, TES_bruit_4, 'r-');
    title('Figure 26 : Taux d''erreur symbolique de la chaine 4');
    xlabel('Eb/N0 (dB)');
    ylabel('TES');
    
% Question 3 :
    
    % TES théorique
    TES_th_4 = (3/2)*qfunc(sqrt((4/5)*10.^(Eb_N0_dB/10)));
    
    % Comparaison du TES simulé et TES théorique
    hold on;
    semilogy(Eb_N0_dB, TES_th_4, 'g-');
    legend('TES simulé','TES théorique');
    
% Question 4 :
    % Tracé du taux d’erreur symbolique en fonction de Eb/N0
    figure(27);
    semilogy(Eb_N0_dB, TEB_bruit_4, 'r-');
    title('Figure 27 : Taux d''erreur binaire de la chaine 4');
    xlabel('Eb/N0 (dB)');
    ylabel('TEB');
    
% Question 5 : 
    
    % TEB théorique
    TEB_th_4 =TES_th_4/2;
    
    % Comparaison du TEB simulé et TEB théorique
    hold on;
    semilogy(Eb_N0_dB, TEB_th_4, 'g-');
    legend('TEB simulé','TEB théorique');
    
