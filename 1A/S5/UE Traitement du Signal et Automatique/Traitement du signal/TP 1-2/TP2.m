% Déclaration des variables :
Fe = 1000;
f0 = 200;
Nb =20;
Ns = 20;
Te = 1/Fe;
Ts = Ns*Te;
N = Nb*Ns;
N1 = 21;
N2 = 61;


% 3- Implentation du madulateur :
% Q3.1 ( a,b,c,d )
    % Génération d'une information binaire
    bits = randi([0,1],1,Nb);
    % Création du signal à partir de l'information binaire
    m = kron(2*bits-1, ones(1,Ns));
    %traçage de la figure
    plot(linspace(0,Nb*Ts,length(m)) , m);
    xlabel({'temps','(s)'});
    ylabel('message');
    title('Figure 1');
    % La transformé de Fourier du message
    TFD_M = fftshift(fft(m));
    figure;
    plot([0 : 1/(N*Te) : (1/Te)-(1/Te)/N],abs(TFD_M));
    xlabel({'Fréquence','(Hz)'});
    ylabel('message');
    title('Figure 2');


% Q3.2
    %génération du cosinus
    x = cos(2*pi*f0*[0:Te:(N-1)*Te]);
    sm = m.*x;
    SM = fft(sm);
    figure;
    plot([0:1/(N*Te) : (1/Te)-(1/Te)/N],fftshift(abs(SM)));
    xlabel({'Fréquence','(Hz)'});
    ylabel('Signal Modulé');
    title('Figure 3');
   
    
% 4- Implentation du retour à basse fréquence :
% Q4.1 - Q4.2
    % Multiplication par le cosinus
    y = sm.*x;
    % La TFD du signal
    Y = fftshift(fft(y));
    figure;
    plot([0:Fe/N:Fe-Fe/N],abs(Y));
    xlabel({'Fréquence','(Hz)'});
    ylabel('Signal Modulé multiplié par le cosinus');
    title('Figure 4');
    
    
    
% Q4.3 ( a )
    % La réponse impulsionnelle idéale
    r = 2*(2*f0)*sinc(2*[-N*Te:Te:N*Te]*((2*f0)));
    figure;
    plot([-N*Te:Te:N*Te],r);
    xlabel({'temps','( s )'});
    ylabel('Réponse impulsionnelle idéale');
    title('Figure 5');
    
% Q4.3 ( b )
    % La TF de la réponse impulsionnelle idéale
    R = fftshift(fft(r));
    figure;
    plot(linspace(0,Fe,length(R)),abs(R));
    xlabel({'Fréquence','(Hz)'});
    ylabel('TF de la réponse impulsionnelle idéale');
    title('Figure 6');
    
    

% Q4.3 ( c )
    % Comparaison des ré ponses impulsionnelles
    r1 = 2*(2*f0)*sinc(2*[-N1*Te:Te:N1*Te]*(2*f0));
    r2 = 2*(2*f0)*sinc(2*[-N2*Te:Te:N2*Te]*(2*f0));
    figure;
    plot([-N2*Te:Te:N2*Te],r2); hold on 
    plot([-N1*Te:Te:N1*Te],r1); hold on
    xlabel({'temps','( s )'});
    ylabel('Réponse impulsionnelle idéale');
    title('Figure 7');
    legend({'ordre : 21' , 'ordre : 61'});
    
    % Comparaison des réponses en fréquence
    R1 = fftshift(fft(r1));
    R2 = fftshift(fft(r2));
    figure;
    plot([-N1*Te:Te:N1*Te],abs(R1)); hold on
    plot([-N2*Te:Te:N2*Te],abs(R2)); hold on
    xlabel({'Fréquence','(Hz)'});
    ylabel('TF de la réponse impulsionnelle idéale');
    title('Figure 8');
    legend({'ordre : 21' , 'ordre : 61'});
    
% Q4.3 ( d )
    % Comparaison des réponses impulsionnelles pour les fenêtres de troncarture
    % Ordre 21
    r1 = 2*(2*f0)*sinc(2*[-N1*Te:Te:N1*Te]*(2*f0));
    r1r =r1.*rectwin(length(r1))';
    r1b = r1.*blackman(length(r1))';
    R1r = fftshift(fft(r1r));
    R1b = fftshift(fft(r1b));
    figure;
    plot([-N1*Te:Te:N1*Te],r1r); hold on
    plot([-N1*Te:Te:N1*Te],r1b); hold on
    xlabel({'temps','( s )'});
    ylabel('Réponse impulsionnelle idéale à l''ordre 21');
    title('Figure 9');
    legend({'fenêtre rectangulaire','fenêtre blackman'});

    figure;
    plot(linspace(0,Fe,length(R1r)),abs(R1r)); hold on
    plot(linspace(0,Fe,length(R1b)),abs(R1b)); hold on
    xlabel({'Fréquence','(Hz)'});
    ylabel('TF de la réponse impulsionnelle idéale à l''ordre 21');
    title('Figure 10');
    
% Q4.3 ( e )
    % Comparaison des réponses impulsionnelles pour les fenêtres de troncarture
    % Ordre choisi : 21
    % Fenêtre choisie : Rectangulaire
    
    Y_normalise = (1/max(abs(Y)))*abs(Y);
    R1r = (1/max(abs(R1r)))*abs(R1r);
    figure;
    plot([0:Fe/N:Fe-Fe/N],Y_normalise); hold on
    plot(linspace(0,Fe,length(R1r)),abs(R1r)); hold off
    legend("1","2");
    xlabel({'Fréquence','(Hz)'});
    ylabel('TF');
    title('Figure 11');
    
% Q4.3 ( f ) ( g )
    % Réalisation du filtrage
    f = conv(y,r1b,'same');
    f1 = 2*(1/max(f))*f;
    % Tracé
    figure;
    plot(linspace(0,Nb*Ts,length(m)),m); hold on
    plot(linspace(0,Nb*Ts,length(f1)),f1); hold on
    xlabel({'temps','(s)'});
    ylabel('message');
    title('Figure 12');
    legend({'message','signal filtré'});