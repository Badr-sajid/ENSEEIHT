
x = linspace(1,100,100);

% matrice type 1
fid = fopen('spectre1.txt', 'rt');
data_cell = textscan(fid, '%f');
fclose(fid);
data1 = data_cell{1};



% matrice type 2
fid = fopen('spectre2.txt', 'rt');
data_cell = textscan(fid, '%f');
fclose(fid);
data2 = data_cell{1};


% matrice type 3
fid = fopen('spectre3.txt', 'rt');
data_cell = textscan(fid, '%f');
fclose(fid);
data3 = data_cell{1};



% matrice type 4
fid = fopen('spectre4.txt', 'rt');
data_cell = textscan(fid, '%f');
fclose(fid);
data4 = data_cell{1};
%% Trace des spectres de 4 types de matrices
figure;
plot(x, data1);hold on
plot(x, data2);hold on
plot(x, data3);hold on
plot(x, data4);hold off
title('Spectre décroissant de la matrice du type 4');
xlabel('');
ylabel('Les valeurs propres');
legend('TYPE 1',' TYPE 2','TYPE 3','TYPE 4');
