clear;
close all;
load exercice_1;
h = figure('Position',[0,0,0.67*L,0.67*H]);
figure('Name','RMSE en fonction du nombre de composantes principales','Position',[0.67*L,0,0.33*L,0.3*L]);

% Calcul de la RMSE entre images originales et images reconstruites :
RMSE_max = 0;

% Composantes principales des donnees d'apprentissage
C = X_c*W;

for q = 0:n-1
    Cq = C(:,1:q);		% q premieres composantes principales
    Wq = W(:,1:q);		% q premieres eigenfaces
    X_reconstruit = Wq*Cq' + repmat(X_m',1,n);
    figure(1);
    set(h,'Name',['Utilisation des ' num2str(q) ' premieres composantes principales']);
    colormap gray;
    hold off;
    for k = 1:n % Affichage de 16 premier individu sinon on peut l'augmenter jusqu'à n
        %subplot(nb_individus,nb_postures,l);
        subplot(4,3,k);     % Pour affichier 24 figure sinon on décommente la ligne d'avant
        img = reshape(X_reconstruit(:,k),nb_lignes,nb_colonnes);
        imagesc(img);
        hold on;
        axis image;
        axis off;
    end
    
    figure(2);
    hold on;
    RMSE = sqrt(mean(mean((X-X_reconstruit').^2)));
    RMSE_max = max(RMSE,RMSE_max);
    plot(q,RMSE,'r+','MarkerSize',8,'LineWidth',2);
    axis([0 n-1 0 1.1*RMSE_max]);
    set(gca,'FontSize',20);
    hx = xlabel('$q$','FontSize',30);
    set(hx,'Interpreter','Latex');
    ylabel('RMSE','FontSize',30);
    
    pause(0.01);
end
