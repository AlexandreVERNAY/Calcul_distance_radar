% Commandes de remise � z�ro de Matlab
close all; % Ferme toutes les fen�tres
clear;     % Efface toutes les variables
clc;       % Efface le contenu de la console

%% 1 - Chargment des valeurs des signaux
Donnees_emission  = load('z_SignalRadarEMIS.txt'); % Chargments des valeurs du signal �mis
Donnees_reception = load('z_SignalEchoRadar2.txt');% Chargments des valeurs du signal re�u

%% 2 - Affectations des valeurs
% Cr�ation des vecteurs de donn�es
% Vecteur Temps
Temps = Donnees_emission(:,1); % Toutes les valeurs de la colonne 1

% Vecteur Signal radar emis
Signal_emis = Donnees_emission(:, 2);

% Vecteur Signal radar re�u 
Signal_recu = Donnees_reception(:,2);

% Affichage des signaux dans le domaine temporelle
% Signal �mis
figure(11);
plot(Temps, Signal_emis,'Color','#D95319')
title('Signal �mis dans le doamine temporel');
xlabel('Temps (s)');
ylabel('Amplitude (V)');

% Signal re�u
figure(12);
plot(Temps, Signal_recu,'Color','#7E2F8E')
title('Signal re�u dans le doamine temporel');
xlabel('Temps (s)');
ylabel('Amplitude (V)');

% Signal �mis et signal re�u
figure(13);
hold on
plot(Temps, Signal_emis,'Color','#D95319'); % Singal �mis en temporelle
plot(Temps, Signal_recu,'Color','#7E2F8E'); % Singal re�u en temporelle
title('Signaux dans le doamine temporel');
legend('Signal emis', 'Signal re�u');
xlabel('Temps (s)');
ylabel('Amplitude (V)');
hold off

%% 3 - D�termination des param�tres de la num�risation
% Nombre de point du vecteur Temps
NbPoint = length(Temps);

% Fr�quence d'�chantillonnage
Fe = 1/(Temps(NbPoint)); 

% Pas frequentiel
PasFreq = Fe/NbPoint;

% Vecteur Fr�quence Freq
Freq = PasFreq*((-(NbPoint-1)/2):((NbPoint-1)/2));

% Temps echantillonage
Te = Temps(2) - Temps(1); % Temps entre deux �chantillon

%% 4 - Transform�s de Fourier
% Signal �mis
% TF du signal �mis
TF_Signal_emis = fft(Signal_emis)/NbPoint;
TF_Signal_emis = fftshift(TF_Signal_emis);

% Module et Phase de la TF du signal Radar Emis
Md_TF_Signal_emis  = abs(TF_Signal_emis);
Ph_TF_Signal_emis  = 360*angle(TF_Signal_emis)/(2*pi);

% Signal re�u
% TF du signal re�u
TF_Signal_recu = fft(Signal_recu)/NbPoint;
TF_Signal_recu = fftshift(TF_Signal_recu);

% Module et Phase de la TF du signal Signal_recu2
Md_TF_Signal_recu  = abs(TF_Signal_recu);
Ph_TF_Signal_recu  = 360*angle(TF_Signal_recu)/(2*pi);

%Affichage des TF des signaux dans le domaine fr�quentiel

% Module TF signal �mis
figure(21);
plot(Freq,Md_TF_Signal_emis,'Color','#D95319')
title('Module de la TF du signal �mis dans le domaine fr�quentiel');
xlabel('Frequence (Hz)');
ylabel('Amplitude (V)');

% Phase TF signal �mis
figure(22);
plot(Freq,Ph_TF_Signal_emis,'Color','#D95319')
title('Phase de la TF du signal �mis dans le domaine fr�quentiel');
xlabel('Frequence (Hz)');
ylabel('Phase (Degr�)');

% Module TF signal re�u
figure(23);
plot(Freq,Md_TF_Signal_recu,'Color','#7E2F8E')
title('Module de la TF du signal re�u dans le domaine fr�quentiel');
xlabel('Frequence (Hz)');
ylabel('Amplitude (V)');

% Phase TF signal re�u 
figure(24);
plot(Freq,Ph_TF_Signal_recu,'Color','#7E2F8E')
title('Phase de la TF du signal re�u dans le domaine fr�quentiel');
xlabel('Frequence (Hz)');
ylabel('Phase (Degr�)');

%% 5 - Corr�lation des signaux
% Autocorrelation du signal �mis
AutoCorr_Signal_emis = xcorr(Signal_emis);

% Intercorrelation du signal signal re�u et du signal �mis
InterCorr_Signal_emis_Signal_recu = xcorr(Signal_recu,Signal_emis);

% Affichage des signaux
figure(31);
hold on
plot(AutoCorr_Signal_emis,'Color','#D95319');
plot(InterCorr_Signal_emis_Signal_recu,'Color','#7E2F8E');
legend('autocorr�lation �mission ', 'intercorrelation reception avec �mission ');
legend("Position",[0.49167,0.82817,0.53929,0.082143]);
hold off

%% 6 - Calcul de la distance de l'avion
[Decalage_temporel] = calculRetard_correlation(AutoCorr_Signal_emis,InterCorr_Signal_emis_Signal_recu,Te);

vitesse_onde = 3e8;
distance = (Decalage_temporel/2) * vitesse_onde;
fprintf("Distance avion = %4.2f m�tres", distance) %disp(distance)