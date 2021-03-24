close all;
% Declaration des variables
    load donnees1.mat
    load donnees2.mat
    fp1 = 0 ; % fréqunence porteuse du premier signal
    fp2 = 46000 ; % fréquence porteuse du deuxième signal 
    Ns = 10 ;
    Fe = 128000 ;
    Te = 1/Fe ;
    Ts = Ns*Te ;
    T = 40*0.001 ;  % Durée d'un slot
    Nb = length(bits_utilisateur1) ;
    temps1 = linspace(0,5*Nb*Ns*Te,Nb*Ns*5) ;

% 3- Construction du signal MF-TDMA à décoder    
% 3.2.1- Modulation bande base
    % Génération du m1(t) et m2(t)
    m1 = kron(2*bits_utilisateur1-1,ones(1,Ns)); % Message à transmettre par l'utilisateur 1
    m2 = kron(2*bits_utilisateur2-1,ones(1,Ns)); % Message à transmettre par l'utilisateur 2

    % Traçage des deux messages m1
    temps = linspace(0,Nb*Ns*Te,Nb*Ns); 
    figure ;
    plot(temps,m1) ;
    title('signal m1(t)');
    xlabel({'temps','(s)'});
    ylabel('m1');

    % Traçage des deux messages m2
    figure ;
    plot(temps,m2) ;
    title('signal m2(t)');
    xlabel({'temps','(s)'});
    ylabel('m2');

% Estimation et Tracé de la DSP de m1 et m2 :
    % Les densités spectrales de puissance des signaux m1(t)
    S1 = (1 / Ns) * abs(fft(m1)) .^ 2;
    S2 = (1 / Ns) * abs(fft(m2)) .^ 2;

    % Traçage des densités spectrales de puissance des signaux m2(t)
    figure;
    plot((0 : Te : (length(fft(m1)) - 1) * Te), fftshift(S1));
    title('Densité spectrale de puissance du signal m1(t)');
    xlabel({'frequence','Hz'});
    ylabel('DSP du signal m1(t)');
    % Traçage des densités spectrales de puissance des signaux m2(t)
    figure;
    plot((0 : Te : (length(fft(m2)) - 1) * Te), fftshift(S2));
    title('Densité spectrale de puissance du signal m2(t)');
    xlabel({'frequence','Hz'});
    ylabel('DSP du signal m2(t)');

    
% 3.2.2- Construction du signal MF-TDMA
    % Génération d'un signal comportant 5 slots 
    slot1 = zeros(1,5*5120) ;
    slot2 = zeros(1,5*5120) ;
    slot1(:,5121 : 2*5120) = m1 ;
    slot2(:,4*5120+1 : end) = m2 ;
    
    % Génération d'un signal résultant
    slot_signal = [zeros(1, 5120), m1, zeros(1, 2*5120), m2];

    % Tracé des slots contenant le signal m1 et m2
    figure ;
    plot((0 : Te : (length(slot_signal) - 1) * Te), slot_signal); hold on
    title("Signal comportant les 5 slots et les message m1 et m2 ");
    xlabel({'temps','(s)'});
    ylabel("m1 , m2");

% Génération et tracé du signal x bruité
    % Génération des signaux x1 et x2
    x1 = slot1.*cos(2*pi*fp1*temps1) ;
    x2 = slot2.*cos(2*pi*fp2*temps1) ;
    
    % génération du signal non bruité (s)
    s = x1 + x2 ;
    figure ;
    plot(temps1,s) ;
    title("Signal non bruité ");
    xlabel({'temps','(s)'});
    ylabel("s");

    puissance_s = (1/(Nb*Ns*5))*sum(abs(s).^2) ; % Puissance du signal s 
    Pbruit = puissance_s/(10^(10)) ; % Puissance du bruit gaussien à partir de l'expression théorique 

    % Génération du bruit Gaussien
    Bruit = sqrt(Pbruit)*randn(1,Nb*Ns*5) ;
    % génération du signal non bruité (x)
    x = s + Bruit ;
    figure ;
    plot(temps1,x) ;
    title("Signal x bruité ");
    xlabel({'temps','(s)'});
    ylabel("x");

    % Densité spectrale de puissance de x
    DSP_x = (1/((Nb*Ns*5)))*((abs(fft(x))).^2) ; % densité spectrale en utilisant un périodogramme
    figure ;
    plot(linspace(-Fe/2,Fe/2,length(DSP_x)),fftshift(DSP_x)) ;
    title("Densité spectrale de x ");
    xlabel({'frequence','Hz'});
    ylabel("DSP(x)");
    
% Mise en place du récepteur MF-TDMA    
% 4.1- Démultipléxage des porteuse

    % Synthèse du filtre passe-Bas
    % Réponses impultionelle du filtre passe-Bas
    fc = (fp1+fp2)/2 ; % fréquence de coupure 
    N = 42 ; % Ordre du filtre
    k = (-N : N )*Te ; 
    h_b = (2*(fc/Fe))*sinc(2*k*fc); % Réponse impulsionnelle 
    figure ;
    plot(linspace(-N*Te ,N*Te ,length(h_b)),h_b) ;
    title("Réponse impulsionnelle du filtre passe-Bas");
    xlabel({'temps','(s)'});
    ylabel('Réponse impulsionnelle');

    % Réponses en fréquence du filtre passe-Bas
    Next = 8*2^nextpow2(length(h_b)); % Zero Padding
    FH = abs(fft(h_b.*hamming(length(h_b))',Next)) ; % Fenêtre de hamming
    figure ;
    plot(linspace(-Fe/2,Fe/2,length(FH)),fftshift(FH));
    title("Tracé de la réponse en fréquence du filtre Passe-Bas");
    xlabel({'frequence','Hz'});
    ylabel('Réponse en fréquence ');

    % Densité spectrale de puissance du signal et la réponse en fréquence du filtre
    figure ;
    plot(linspace(-Fe/2,Fe/2,length(FH)),fftshift(FH)); hold on
    plot(linspace(-Fe/2,Fe/2,length(DSP_x)),fftshift((1/max(abs(DSP_x)))*abs(DSP_x))) ;
    title("Densité spectrale de puissance Sx et la réponse en fréquence du filtre passe-bas");
    xlabel({'frequence','Hz'});
    ylabel('Réponse en fréquence ,DSP(x)');
    legend("Réponse en fréquence","Sx");
    hold off

    % Synthèse du filtre passe-Haut
    % Réponse impulsionnelle du filtre passe-Haut
    dirac = zeros(1,2*N+1) ;  % la fonction dirac
    dirac(1,N+1) =1 ;
    % Réponse impulsionnelle du filtre passe-Haut
    h_h = dirac - h_b ; 
    
    % Réponse fréquentielle du filtre passe-Haut
    FH1 = 1 - FH ; % Fenêtre de hamming

    % La réponse impulsionnelle et la réponse fréquentielle du filtre passe-Haut
    % Réponse impulsionnelle 
    figure ;
    plot(linspace(-N*Te ,N*Te ,length(h_h)),h_h) ;
    title("Tracé de la réponse impulsionnelle du filtre passe haut");
    xlabel({'temps','(s)'});
    ylabel('Réponse impulsionnelle');
 
   % réponse fréquentielle 
   figure ;
   plot(linspace(-Fe/2,Fe/2,length(FH1)),fftshift(FH1));
   title("Tracé de la réponse en fréquence du filtre passe-Haut");
   xlabel({'frequence','Hz'});
   ylabel('Réponse en fréquence');
   
    % Densité spectrale de puissance du signal et la réponse en fréquence du filtre
    figure ;
    plot(linspace(-Fe/2,Fe/2,length(FH1)),fftshift(FH1)); hold on
    plot(linspace(-Fe/2,Fe/2,length(DSP_x)),fftshift((1/max(abs(DSP_x)))*abs(DSP_x))) ;
    title("Densité spectrale de puissance de x et de la réponse en fréquence du filtre passe-Haut");
    xlabel({'frequence','Hz'});
    ylabel('Réponse en fréquence ,DSP(x)');
    legend("Réponse en fréquence ","DSP(x)");
    hold off

    % Filtrage
    % Obtention des signaux x1
    x1_filtre = conv(x,h_b,'same') ;
    figure ;
    plot(temps1,x1_filtre) ;
    title("x1 filtré");
    xlabel({'temps','(s)'});
    ylabel('x1 filtré');
    
    % Obtention des signaux x2 
    x2_filtre = conv(x,h_h,'same') ;
    figure ; 
    plot(temps1,x2_filtre) ;
    title("x2 filtré");
    xlabel({'frequence','Hz'});
    ylabel('x2 filtré');
 

% 4.2 Retour en bande de Base 
    x1_retour = x1_filtre.*cos(2*pi*fp1*temps1) ;
    x2_retour = x2_filtre.*cos(2*pi*fp2*temps1) ;
   
   
% 4.3 Détection du Slot utile 
     slot1_1 = x1_retour(1,1:Nb*Ns) ;
     slot1_2 = x1_retour(1,Nb*Ns+1:2*Nb*Ns) ;
     slot1_3 = x1_retour(1,2*Nb*Ns+1:3*Nb*Ns) ;
     slot1_4 = x1_retour(1,3*Nb*Ns+1:4*Nb*Ns) ;
     slot1_5 = x1_retour(1,4*Nb*Ns+1:5*Nb*Ns) ;


     slot2_1 = x2_retour(1,1:Nb*Ns) ;
     slot2_2 = x2_retour(1,Nb*Ns+1:2*Nb*Ns) ;
     slot2_3 = x2_retour(1,2*Nb*Ns+1:3*Nb*Ns) ;
     slot2_4 = x2_retour(1,3*Nb*Ns+1:4*Nb*Ns) ;
     slot2_5 = x2_retour(1,4*Nb*Ns+1:5*Nb*Ns) ;

     energie1 = zeros(1,5);
     energie2 = zeros(1,5);
     energie1(1) = sum(abs(slot1_1).^2) ;
     energie1(2) = sum(abs(slot1_2).^2) ;
     energie1(3) = sum(abs(slot1_3).^2) ;
     energie1(4) = sum(abs(slot1_4).^2) ;
     energie1(5) = sum(abs(slot1_5).^2) ;
     energie2(1) = sum(abs(slot2_1).^2) ;
     energie2(2) = sum(abs(slot2_2).^2) ;
     energie2(3) = sum(abs(slot2_3).^2) ;
     energie2(4) = sum(abs(slot2_4).^2) ;
     energie2(5) = sum(abs(slot2_5).^2) ;
 
    [max1 , indice1] = max(energie1);
    [max2 , indice2] = max(energie2);

% Démodulation Bande de base
   
% Restitution de la première information binaire 
  SignalFiltre1 = conv(slot1_2,ones(1,Ns),'same');
  SignalEchantillonne1 = SignalFiltre1(1:Ns:end);
  BitsRecuperes1 = (sign(SignalEchantillonne1)+1)/2 ;
  
% Restitution de la deuxième information binaire 
  SignalFiltre2 = conv(slot2_5,ones(1,Ns),'same');
  SignalEchantillonne2 = SignalFiltre2(1:Ns:end);
  BitsRecuperes2 = (sign(SignalEchantillonne2)+1)/2 ;
  
  text1 = bin2str(BitsRecuperes1) 
  text2 = bin2str(BitsRecuperes2) 
