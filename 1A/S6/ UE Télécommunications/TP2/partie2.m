%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Télécommunications
% Études de chaines de transmission en bande de base
% Auteur : Sajid Badr , Akby Amine , Elbouchibti Ayman
%--------------------------------------------------------------------------


clear all; close all;

%% Déclaration des variables
    % Nombre de bits à générer 
    N_bits = 120000;

    % Facteur de suréchantillonage
    Ns = 4;
    
    % Fréquence porteuse 
    fp = 2000;
    
    % Fréquence d'échantillonnage
    Fe = 10000;

    % Roll off
    alpha = 0.5;

    %SPAN
    span = 4;
    
    % Facteur de suréchantillonage
    Eb_N0 = linspace(0,9,10);
    Eb_N0_dB = 10.^(Eb_N0/10);
    
     % Génération des bits
    bits = randi(2,1,N_bits)-1;
        
    % Cosinus-surelevé
    h = rcosdesign(alpha, span,Ns,'sqrt');
    hr = fliplr(h);
    retard = span*Ns/2;
 
%% --------------------------------------------------------------------------

% Question 1 :
% ---------------------------------------------------------------------------

%% Chaine 4-ASK complète sans bruit
 % Ordre de modulation
    M_ASK = 4;
    
    % Nombre de bits par symbole
    n_ASK = log2(M_ASK);
    
    % Génération de bloc des bits
    bloc_bits_ASK = reshape(bits,N_bits/n_ASK,n_ASK);
    
    % Mapping
    sym_dec_ASK = (2*bi2de(bloc_bits_ASK)-3).';
    
    % Filtrage de récéption :
    % Suréchantillonnage
    dk_ASK = kron(sym_dec_ASK,[1 zeros(1,Ns-1)]);
    
    % Constellations en sortie du mapping 
    figure(1);
    plot(real(sym_dec_ASK),imag(sym_dec_ASK),'ored','linewidth',3);
    title('Figure 1 : Constellations en sortie du mapping de la chaine 4-ASK');
    xlim([-6 6]);
    ylim([-6 6]);
    
    % Mise en forme du signal
    xe_ASK = filter(h,1,[dk_ASK zeros(1,retard)]);
    xe_ASK = xe_ASK(retard+1:end);
    
    % Filtrage
    y_ASK = filter(h,1,[xe_ASK zeros(1,retard)]);
    y_ASK = y_ASK(retard+1:end);
    
    % Echantiollage
    y_ASK_ech = y_ASK(1:Ns:end);
    
    % Demapping
    symb_decides_ASK = zeros(1,length(y_ASK_ech));
    for i=1:length(symb_decides_ASK)
        if (y_ASK_ech(i)>=2)
            symb_decides_ASK(i) = 3;
        elseif (y_ASK_ech(i) >= 0)
            symb_decides_ASK(i) = 1;
        elseif (y_ASK_ech(i) <= -2)
            symb_decides_ASK(i) = -3;
        else
            symb_decides_ASK(i) = -1;
        end
    end
    bits_decides_ASK = reshape(de2bi((symb_decides_ASK+3)/2),1,N_bits);
    nb_erreur = length(find(bits~=bits_decides_ASK));
    TEB_ASK = nb_erreur/N_bits
    
%% Chaine QPSK complète sans bruit
   
    % Ordre de modulation
    M_QPSK = 4;
    
    % Nombre de bits par symbole
    n_QPSK = 2;
    
    % Génération de bloc des bits
    bloc_bits_QPSK = reshape(bits,N_bits/n_QPSK,n_QPSK);
    
    % Symbole décimaux
    sym_dec_QPSK = bi2de(bloc_bits_QPSK).';
    
    %Mapping
    dk_QPSK = pskmod(sym_dec_QPSK,M_QPSK,pi/8,'gray');
    
    % Constellations en sortie du mapping 
    figure(2);
    plot(real(dk_QPSK),imag(dk_QPSK),'ored','linewidth',3);
    title('Figure 2 : Constellations en sortie du mapping de la chaine QPSK');
    xlim([-6 6]);
    ylim([-6 6]);
    
    % Demapping
    bits_decides_QPSK = pskdemod(dk_QPSK,M_QPSK,pi/8,'gray');

    bloc_bits_decides_QPSK = de2bi(bits_decides_QPSK.');
    bits_sortie_QPSK = bloc_bits_decides_QPSK(:);
    bits_sortie_QPSK = bits_sortie_QPSK';
    
    nb_erreur = length(find(bits~=bits_sortie_QPSK));
    TEB_QPSK = nb_erreur/N_bits

 %% Chaine 8-PSK complète sans bruit
   
    % Ordre de modulation
    M_PSK = 8;
    
    % Nombre de bits par symbole
    n_PSK = 3;
    
    % Génération de bloc des bits
    bloc_bits_PSK = reshape(bits,N_bits/n_PSK,n_PSK);
    
    % Symbole décimaux
    sym_dec_PSK = bi2de(bloc_bits_PSK).';
    
    %Mapping
    dk_PSK = pskmod(sym_dec_PSK,M_PSK,pi/8,'gray');
    
    % Constellations en sortie du mapping 
    figure(3);
    plot(real(dk_PSK),imag(dk_PSK),'ored','linewidth',3);
    title('Figure 3 : Constellations en sortie du mapping de la chaine 8-PSK');
    xlim([-6 6]);
    ylim([-6 6]);
    
    % Demapping
    bits_decides_PSK = pskdemod(dk_PSK,M_PSK,pi/8,'gray');

    bloc_bits_decides_PSK = de2bi(bits_decides_PSK.');
    bits_sortie_PSK = bloc_bits_decides_PSK(:);
    bits_sortie_PSK = bits_sortie_PSK';
    
    nb_erreur = length(find(bits~=bits_sortie_PSK));
    TEB_PSK = nb_erreur/N_bits
    
%% Chaine 16-QAM complète sans bruit
   
    % Ordre de modulation
    M_QAM = 16;
    
    % Nombre de bits par symbole
    n_QAM = 4;
    
    % Génération de bloc des bits
    bloc_bits_QAM = reshape(bits,N_bits/n_QAM,n_QAM);
    
    % Symbole décimaux
    sym_dec_QAM = bi2de(bloc_bits_QAM).';
    
    %Mapping
    dk_QAM = qammod(sym_dec_QAM,M_QAM,'gray');
    
    % Constellations en sortie du mapping 
    figure(4);
    plot(real(dk_QAM),imag(dk_QAM),'ored','linewidth',3);
    title('Figure 4 : Constellations en sortie du mapping de la chaine 16-QAM');
    xlim([-6 6]);
    ylim([-6 6]);
    
    % Demapping
    bits_decides_QAM = qamdemod(dk_QAM,M_QAM,'gray');

    bloc_bits_decides_QAM = de2bi(bits_decides_QAM.');
    bits_sortie_QAM = bloc_bits_decides_QAM(:);
    bits_sortie_QAM = bits_sortie_QAM';
    
    nb_erreur = length(find(bits~=bits_sortie_QAM));
    TEB_QAM = nb_erreur/N_bits
    
    
%% --------------------------------------------------------------------------

% Question 2 :
% ---------------------------------------------------------------------------

%% Chaine 4-ASK complète avec bruit

    TEB_bruit_ASK = [];
    for j = 1:length(Eb_N0)
        sigma_n_carre = mean(abs(xe_ASK).^2)*Ns/(2*log2(M_ASK))/Eb_N0_dB(j);
        %Bruit = sqrt(sigma_n_carre) * ( randn(1, length(real(xe_ASK))) + 1i*randn(1, length(imag(xe_ASK))) );

        br = randn(1,length(real(xe_ASK)));
        bi = randn(1,length(imag(xe_ASK)));
    
        Bruit = sqrt(sigma_n_carre)*(br + 1i * bi);
        % Ajout de bruit 
        signal_bruite_1 = xe_ASK + Bruit;

        % Filtrage de récéption
        z_ASK = filter(hr,1,[signal_bruite_1 zeros(1,retard)]);
        z_ASK = z_ASK(retard+1:end);

        % Echantiollage
        z_m_ASK = z_ASK(1:Ns:end);

        % Constellations en sortie de l'echantillonneur 
        figure(5);
        plot(real(z_m_ASK),imag(z_m_ASK),'ored','linewidth',3);
        title('Figure 5 : Constellations en sortie de l''echantillonneur de la chaine ASK');
        xlim([-6 6]);
        ylim([-6 6]);

        % Demapping
        symb_decides_ASK = zeros(1,length(z_m_ASK));
        for i = 1:length(symb_decides_ASK)
            if (z_m_ASK(i)>=2)
                symb_decides_ASK(i) = 3;
            elseif (z_m_ASK(i) >= 0)
                symb_decides_ASK(i) = 1;
            elseif (z_m_ASK(i) <= -2)
                symb_decides_ASK(i) = -3;
            else
                symb_decides_ASK(i) = -1;
            end
        end
        bits_decides_ASK = reshape(de2bi((symb_decides_ASK+3)/2),1,N_bits);
        nb_erreur = length(find(bits~=bits_decides_ASK));
        TEB_ASK = nb_erreur/N_bits;
        TEB_bruit_ASK = [TEB_bruit_ASK, TEB_ASK];
    end
    
    % Tracé du taux d’erreur binaire en fonction de Eb/N0
    figure(6);
    semilogy(Eb_N0, TEB_bruit_ASK, '-r*');
    
    % Comparaison du TEB simulé et TEB théorique
    hold on;
    TEB_th_ASK = (3/4)*qfunc(sqrt((12/15)*Eb_N0_dB));;
    semilogy(Eb_N0, TEB_th_ASK, 'g-');
    legend('TEB simulé','TEB théorique');
    
    title('Figure 6 : Taux d''erreur binaire de la chaine ASK');
    legend('TEB simulé','TEB théorique');
    xlabel('Eb/N0 (dB)');
    ylabel('TEB');
        


%% Chaine QPSK complète avec bruit

    % Filtrage de récéption :
    % Suréchantillonnage
    dirac_QPSK = kron(dk_QPSK,[1 zeros(1,Ns-1)]);
    
    % Filtrage
    dirac_rcos_QPSK =[dirac_QPSK,zeros(1,retard)];
    xe_QPSK = filter(h,1,dirac_rcos_QPSK);
    xe_QPSK = xe_QPSK(retard+1:end);


    TEB_bruit_QPSK = [];
    for i = 1:length(Eb_N0)
        sigma_n_carre = mean(abs(xe_QPSK).^2)*Ns/(2*log2(M_QPSK))/Eb_N0_dB(i);
        Bruit = sqrt(sigma_n_carre) * ( randn(1, length(real(xe_QPSK))) + 1i*randn(1, length(imag(xe_QPSK))) );

        % Ajout de bruit 
        signal_bruite_1 = xe_QPSK + Bruit;

        % Filtrage de récéption
        z_QPSK = filter(hr,1,[signal_bruite_1 zeros(1,retard)]);
        z_QPSK = z_QPSK(retard+1:end);

        % Echantiollage
        z_m_QPSK = z_QPSK(1:Ns:end);

        % Constellations en sortie de l'echantillonneur 
        figure(7);
        plot(real(z_m_QPSK),imag(z_m_QPSK),'ored','linewidth',3);
        title('Figure 7 : Constellations en sortie de l''echantillonneur de la chaine QPSK');
        xlim([-6 6]);
        ylim([-6 6]);

        % Demapping
        bits_decides_QPSK = pskdemod(z_m_QPSK,M_QPSK,pi/8,'gray');

        bloc_bits_decides_QPSK = de2bi(bits_decides_QPSK);
        bits_sortie_QPSK = bloc_bits_decides_QPSK(:);
        bits_sortie_QPSK = bits_sortie_QPSK';

        nb_erreur = length(find(bits~=bits_sortie_QPSK));
        TEB_QPSK = nb_erreur/N_bits;
        TEB_bruit_QPSK = [TEB_bruit_QPSK, TEB_QPSK];
    end
    
    % Tracé du taux d’erreur binaire en fonction de Eb/N0
    figure(8);
    semilogy(Eb_N0, TEB_bruit_QPSK, '-r*');
    
    % Comparaison du TEB simulé et TEB théorique
    hold on;
    TEB_th_QPSK = qfunc(sqrt(2*Eb_N0_dB));
    semilogy(Eb_N0, TEB_th_QPSK, 'g-');
    legend('TEB simulé','TEB théorique');
    
    title('Figure 8 : Taux d''erreur binaire de la chaine QPSK');
    legend('TEB simulé','TEB théorique');
    xlabel('Eb/N0 (dB)');
    ylabel('TEB');
        

%% Chaine 8-PSK complète avec bruit

    % Filtrage de récéption :
    % Suréchantillonnage
    dirac_PSK = kron(dk_PSK,[1 zeros(1,Ns-1)]);
    
    % Filtrage
    dirac_rcos_PSK =[dirac_PSK,zeros(1,retard)];
    xe_PSK = filter(h,1,dirac_rcos_PSK);
    xe_PSK = xe_PSK(retard+1:end);


    TEB_bruit_PSK = [];
    for i = 1:length(Eb_N0)
        sigma_n_carre = mean(abs(xe_PSK).^2)*Ns/(2*log2(M_PSK))/Eb_N0_dB(i);
        Bruit = sqrt(sigma_n_carre) * ( randn(1, length(real(xe_PSK))) + 1i*randn(1, length(imag(xe_PSK))) );

        % Ajout de bruit 
        signal_bruite_1 = xe_PSK + Bruit;

        % Filtrage de récéption
        z_PSK = filter(hr,1,[signal_bruite_1 zeros(1,retard)]);
        z_PSK = z_PSK(retard+1:end);

        % Echantiollage
        z_m_PSK = z_PSK(1:Ns:end);

        % Constellations en sortie de l'echantillonneur 
        figure(9);
        plot(real(z_m_PSK),imag(z_m_PSK),'ored','linewidth',3);
        title('Figure 9 : Constellations en sortie de l''echantillonneur de la chaine 8-PSK');
        xlim([-6 6]);
        ylim([-6 6]);

        % Demapping
        bits_decides_PSK = pskdemod(z_m_PSK,M_PSK,pi/8,'gray');

        bloc_bits_decides_PSK = de2bi(bits_decides_PSK);
        bits_sortie_PSK = bloc_bits_decides_PSK(:);
        bits_sortie_PSK = bits_sortie_PSK';

        nb_erreur = length(find(bits~=bits_sortie_PSK));
        TEB_PSK = nb_erreur/N_bits;
        TEB_bruit_PSK = [TEB_bruit_PSK, TEB_PSK];
    end
    
    % Tracé du taux d’erreur binaire en fonction de Eb/N0
    figure(10);
    semilogy(Eb_N0, TEB_bruit_PSK, '-r*');
    
    % Comparaison du TEB simulé et TEB théorique
    hold on;
    TEB_th_PSK =(2/3)*qfunc(sqrt(2*Eb_N0_dB*sin(pi/M_PSK)));
    semilogy(Eb_N0, TEB_th_PSK, 'g-');
    legend('TEB simulé','TEB théorique');
    
    title('Figure 10 : Taux d''erreur binaire de la chaine 8-PSK');
    legend('TEB simulé','TEB théorique');
    xlabel('Eb/N0 (dB)');
    ylabel('TEB');
        
%% Chaine 16-QAM complète avec bruit

    % Filtrage de récéption :
    % Suréchantillonnage
    dirac_QAM = kron(dk_QAM,[1 zeros(1,Ns-1)]);
    
    % Filtrage
    dirac_rcos_QAM=[dirac_QAM,zeros(1,retard)];
    xe_QAM = filter(h,1,dirac_rcos_QAM);
    xe_QAM = xe_QAM(retard+1:end);


    TEB_bruit_QAM = [];
    for i = 1:length(Eb_N0)
        sigma_n_carre = mean(abs(xe_QAM).^2)*Ns/(2*log2(M_QAM))/Eb_N0_dB(i);
        Bruit = sqrt(sigma_n_carre) * ( randn(1, length(real(xe_QAM))) + 1i*randn(1, length(imag(xe_QAM))) );

        % Ajout de bruit 
        signal_bruite_1 = xe_QAM + Bruit;

        % Filtrage de récéption
        z_QAM = filter(hr,1,[signal_bruite_1 zeros(1,retard)]);
        z_QAM = z_QAM(retard+1:end);

        % Echantiollage
        z_m_QAM = z_QAM(1:Ns:end);

        % Constellations en sortie de l'echantillonneur 
        figure(11);
        plot(real(z_m_QAM),imag(z_m_QAM),'ored','linewidth',3);
        title('Figure 11 : Constellations en sortie de l''echantillonneur de la chaine 16-QAM');
        xlim([-6 6]);
        ylim([-6 6]);

        % Demapping
        bits_decides_QAM = qamdemod(z_m_QAM,M_QAM,'gray');

        bloc_bits_decides_QAM = de2bi(bits_decides_QAM);
        bits_sortie_QAM = bloc_bits_decides_QAM(:);
        bits_sortie_QAM = bits_sortie_QAM';

        nb_erreur = length(find(bits~=bits_sortie_QAM));
        TEB_QAM = nb_erreur/N_bits;
        TEB_bruit_QAM = [TEB_bruit_QAM, TEB_QAM];
    end
    % Tracé du taux d’erreur binaire en fonction de Eb/N0
    figure(12);
    semilogy(Eb_N0, TEB_bruit_QAM, '-b*');
    
    % TEB théorique
    TEB_th_QAM =(3/4)*qfunc(sqrt(3*(4/15)*Eb_N0_dB));

    % Comparaison du TEB simulé et TEB théorique
    hold on;
    semilogy(Eb_N0, TEB_th_QAM, '-g*');
    legend('TEB simulé','TEB théorique');
    title('Figure 12 : Taux d''erreur binaire de la chaine 16-QAM');
    legend('TEB simulé','TEB théorique');
    xlabel('Eb/N0 (dB)');
    ylabel('TEB');
    
%% --------------------------------------------------------------------------

% Comparaison des chaines de transmission
% ---------------------------------------------------------------------------

    % 1. Comparaison du TEB simulé des differentes chaine
    figure(13);
    semilogy(Eb_N0, TEB_bruit_ASK, '+b-'); hold on;
    semilogy(Eb_N0, TEB_bruit_QPSK, 'o-black'); hold on
    semilogy(Eb_N0, TEB_bruit_PSK, '*g-'); hold on;
    semilogy(Eb_N0, TEB_bruit_QAM, 'v-r'); hold on;
    title('Figure 13 : Comparaison des TEB des quatres chaines');
    legend('TEB simulé 4-ASK','TEB simulé QSK',...
        'TEB simulé 8-PSK','TEB simulé 16-QAM');
    xlabel('Eb/N0 (dB)');
    ylabel('TEB');

    % 2. Densités spectrales de puissance des signaux
    figure(14);    
    % Chaine 16-QAM
    [DSP_QAM,freq_QAM] = Calcul_DSP(xe_QAM);
    plot(freq_QAM,fftshift(DSP_QAM),'g');
    hold on;
    
    % Chaine 4-ASK
    [DSP_ASK,freq_ASK] = Calcul_DSP(xe_ASK);
    plot(freq_ASK,fftshift(DSP_ASK),'b');
    hold on;
    
    % Chaine QPSK
    [DSP_QPSK,freq_QPSK] = Calcul_DSP(xe_QPSK);
    plot(freq_QPSK,fftshift(DSP_QPSK),'r');
    hold on;
    
    % Chaine 8-PSK
    [DSP_PSK,freq_PSK] = Calcul_DSP(xe_PSK);
    plot(freq_PSK,fftshift(DSP_PSK),'y');
    
    title('Figure 14 : Comparaison des DSP des quatres chaines');
    legend('DSP 16-QAM','DSP 4-ASK',...
        'DSP QSK','DSP 8-PSK');
    ylabel('DSP');
    
    