% Déclaration des variable
    Fe1 = 10000; % Première fréquence d'échantillonnage 
    Fe2 = 1000; % deuxième fréquence d'échantillonnage 
    f0 = 1100; % Fréquence de Cosinus
    A = 1; % Amplitude 
    N = 90; % Nombre d'échantillons 
    N1 = 2^nextpow2(N); % Nombre d'échantillons avec le Zero Padding
    t1 = linspace(0,N-1,N)/Fe1;
    t2 = linspace(0,N-1,N)/Fe2;
    phase = 2*pi*rand; %Génération d'une phase aléatoire entre 0 et 2*pi



% 2- Effet d’échantillonnage :
% Q2.1 - Q2.2
    %Génération du signal %
    echantillon_cos_1 = A*cos(2*pi*f0*t1);
    %Tracé du signal
    plot(t1 , echantillon_cos_1);
    xlabel({'temps','(s)'});
    ylabel('echantillonage du cos');
    title('Fonction cosinus générée avec 90 échantillons avec une Fe = 10000');


% Q2.3 - Q2.4
    figure;
    %Génération du signal 
    echantillon_cos_2 = A*cos(2*pi*f0*t2);
    %Tracé du signal
    plot(t2 , echantillon_cos_2);
    xlabel({'temps','(s)'});
    ylabel('echantillonage du cos');
    title('Fonction cosinus générée avec 90 échantillons avec une Fe = 1000');


% 3- Transformée de Fourier Discrète ( TFD ) :
% Q3.2.(a) 
    figure;
    %Génération du TFD 
    abs_TFD_cos_1 = abs(fft(echantillon_cos_1));
    %Tracé du module de la TFD estimée du cosinus en échelle log 
    semilogy(linspace(0,Fe1,N),abs_TFD_cos_1);
    xlabel({'frequence','Hz'});
    ylabel('|TFD(cos)|');
    title('Module de la TFD estimée du cosinus avec une Fe = 10000 en échelle log');


% Q3.2.(b) 
    figure;
    %Génération du TFD 
    abs_TFD_cos_2 = abs(fft(echantillon_cos_2));
    %Tracé du module de la TFD estimée du cosinus en échelle log 
    semilogy(linspace(0,Fe2,N),abs_TFD_cos_2);
    xlabel({'frequence','Hz'});
    ylabel('|TFD(cos)|');
    title('Module de la TFD estimée du cosinusavec une Fe = 1000 en échelle log');


% Q3.4 
    figure;
    %Génération du TFD %
    abs_TFD_cos_1 = abs(fft(echantillon_cos_1,N1));
    %Tracé du module de la TFD estimée du cosinus en échelle log 
    semilogy(linspace(0,Fe1,N1),abs_TFD_cos_1);
    xlabel({'frequence','Hz'});
    ylabel('|TFD(cos)|');
    title('Module de la TFD estimée du cosinus en échelle log avec Zero Padding');


% Q3.5 
    figure;
    %Génération du TFD pour N' = 100 et du tracé correspondant
    N0 = 100 ; % Nombre d'échantillons avec le Zero Padding 
    abs_TFD_cos = abs(fft(echantillon_cos_1,N1));
    semilogy(linspace(0,Fe1,N1),abs_TFD_cos);hold on
    %Génération du TFD pour N_sup = 500 et du tracé correspondant
    N2 = 500;
    abs_TFD_cos2 = abs(fft(echantillon_cos_1,N2));
    semilogy(linspace(0,Fe1,N2),abs_TFD_cos2);hold on
    %Génération du TFD pour N_sup = 1000 et du tracé correspondant
    N3 = 1000;
    abs_TFD_cos3 = abs(fft(echantillon_cos_1,N3));
    semilogy(linspace(0,Fe1,N3),abs_TFD_cos3);hold on
    legend({'N'' = 100','N'' = 500','N'' = 1000'},'Location','southwest');
    xlabel({'frequence','Hz'});
    ylabel('|TFD(cos)|');
    title('Module de la TFD estimée du cosinus en échelle log avec Zero Padding');

% 4- Densité spectrale de puissance :
% Q4.1
    %Génération du signal
    x = cos(2*pi*f0*t1 + phase);


% Q4.2
    %Estimation du DSP du signal x 
    DSP_x = 1/N1 * abs(fft(x,N1)).^2;
    figure
    plot(linspace(0,1,N1),DSP_x);
    xlabel({'Fréquences normalisées','Hz'});
    ylabel('DSP');
    title('DSP du signal x');

% Q4.3
    %Estimation du DSP du signal x en implantant un périodogramme avec une fenêtre de Hamming 
    DSP_x_hamming = (1/N1)*abs(fft(x.*hamming(N)',N1)).^2;
    figure;
    plot(linspace(0,1,N1),DSP_x_hamming);hold on
    %Estimation du DSP du signal x en implantant un périodogramme avec une fenêtre de Blackman 
    DSP_x_blackman = (1/N1)*abs(fft(x.*blackman(N)',N1)).^2;
    plot(linspace(0,1,N1),DSP_x_blackman);hold on
    xlabel('Fréquences normalisées');
    ylabel('DSP');
    title('DSP du cos à l''aide des fenetres de Hamming et Blackman');
    legend({'Hamming','Blackman'});


% Q4.4
    %Estimation du DSP du signal x en utilisant la fonction pwelch 
    DSP_x_pwelch = pwelch(x,'','','','twosided');
    figure;
    plot(linspace(0,1,2*N1),DSP_x_pwelch);
    xlabel('Fréquences normalisées');
    ylabel('DSP');
    title('DSP du cos à l''aide de la fonction pwelch');


% Q4.5
% Comparaison
    figure;
    plot(linspace(0,1,N1),DSP_x);hold on
    plot(linspace(0,1,N1),DSP_x_hamming);hold on
    plot(linspace(0,1,N1),DSP_x_blackman);hold on
    plot(linspace(0,1,2*N1),DSP_x_pwelch);hold on
    xlabel('Fréquences normalisées');
    ylabel('DSP');
    title('comparaison des 4 DSP');
    legend({'correlogramme','Hamming','Blackman','pwelch'});