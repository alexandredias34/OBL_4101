%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VOCODEUR : Programme principal r�alisant un vocodeur de phase 
% et permettant de :
%
% 1- modifier le tempo (la vitesse de "prononciation")
%   sans modifier le pitch (fr�quence fondamentale de la parole)
%
% 2- modifier le pitch 
%   sans modifier la vitesse 
%
% 3- "robotiser" une voix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% R�cup�ration d'un signal audio
%--------------------------------

% [y,Fs]=audioread('Diner.wav');   %signal d'origine
% [y,Fs]=audioread('Extrait.wav');   %signal d'origine
% [y,Fs]=audioread('Halleluia.wav');   %signal d'origine
 [y,Fs]=audioread('Civil.wav');


% Remarque : si le signal est en st�r�o, ne traiter qu'une seule voie � la
% fois
y = y(:,1);
N = length(y);
t = (0:N-1)/Fs;
nf=1024;
% Courbes (�volution au cours du temps, spectre et spectrogramme)
% %--------
% % Domaine temporel
figure(1)
subplot(311),
plot(t,y),grid, xlabel('Secondes') , ylabel ('Intensit�')
title('Domaine temporel')

% Spectrogramme
figure(1)
subplot(312),spectrogram(y,128,120,128,Fs,'yaxis');
title('Spectrogramme')


% Spectre (signal dans le domaine fr�quentiel)
Y = fft(y,Fs);
f = Fs/2*linspace(0,1,nf/2+1);
figure(1)
subplot(313),
plot(f,abs(Y(1:nf/2+1)));
xlabel('Fr�quence(Hz)'), ylabel('Intensit�')
title('Spectre')
sgtitle('Son original') 

% Ne pas oublier de cr�er les vecteurs temps, fr�quences...
% et de tracer le spectre et le spectrogramme

% ECOUTE
%soundsc(y,Fs)
%pause

%-------------------------------
% 1- MODIFICATION DE LA VITESSE
% (sans modification du pitch)
%-------------------------------
% PLUS LENT
rapp = 2/3;   %peut �tre modifi�
ylent = PVoc(y,rapp,1024); 
Nlent = length(ylent);
tlent = (0:Nlent-1)/Fs;
nf=1024;

% Ecoute
%-------
%soundsc(ylent,Fs)
%pause

% Courbes
%--------
% Domaine temporel
figure(2)
subplot(311),plot(tlent,ylent), grid, xlabel('Secondes') , ylabel ('Intensit�')
title('Domaine temporel')

% Spectrogramme
figure(2)
subplot(312),spectrogram(ylent,128,120,128,Fs,'yaxis');
title('Spectrogramme')

% Spectre (signal dans le domaine fr�quentiel)
YLENT = fft(ylent,Fs);
f = Fs/2*linspace(0,1,nf/2+1);
figure(2)
subplot(313),
plot(f,abs(YLENT(1:nf/2+1)));
xlabel('Fr�quence(Hz)'), ylabel('Intensit�')
title('Spectre')
sgtitle('Version ralentie')

%
% PLUS RAPIDE
rapp = 3/2;   %peut �tre modifi�
yrapide = PVoc(y,rapp,1024); 
Nrapide = length(yrapide);
trapide = (0:Nrapide-1)/Fs;
nf=1024;

% Ecoute 
%-------
%soundsc(yrapide,Fs)
%pause

% Courbes
%--------
% Domaine temporel
figure(3)
subplot(311),plot(trapide,yrapide), grid, xlabel('Secondes') , ylabel ('Intensit�')
title('Domaine temporel')

% Spectrogramme
figure(3)
subplot(312),spectrogram(yrapide,128,120,128,Fs,'yaxis');
title('Spectrogramme')

% Spectre (signal dans le domaine fr�quentiel)
figure(3)
YRAPIDE = fft(yrapide,Fs);
f = Fs/2*linspace(0,1,nf/2+1);
figure(3)
subplot(313),
plot(f,abs(YRAPIDE(1:nf/2+1)));
xlabel('Fr�quence(Hz)'), ylabel('Intensit�')
title('Spectre')
sgtitle('Version acc�l�r�e')

%%
%----------------------------------
% 2- MODIFICATION DU PITCH
% (sans modification de vitesse)
%----------------------------------
% Param�tres g�n�raux:
%---------------------
% Nombre de points pour la FFT/IFFT
Nfft = 256;

% Nombre de points (longueur) de la fen�tre de pond�ration 
% (par d�faut fen�tre de Hanning)
Nwind = Nfft;

% Augmentation 
%--------------
a = 1;  b = 2;  %peut �tre modifi�
yvocaug = PVoc(y, a/b,Nfft,Nwind);

% R�-�chantillonnage du signal temporel afin de garder la m�me vitesse
yaug = y; 
reaug = resample(yvocaug,a,b);
if (N > length(reaug)) 
    yaug = y(1:length(reaug));
else 
    reaug = reaug(1:N);
end 
%Somme de l'original et du signal modifi�
%Attention : on doit prendre le m�me nombre d'�chantillons
%Remarque : vous pouvez mettre un coefficient � ypitch pour qu'il
%intervienne + ou - dans la somme...
ysumaug = yaug + reaug;
% Ecoute
%-------
%soundsc(reaug,Fs) % Ecoute du signal modifi� afin de v�rifier l'augmentation du pitch
%pause
%%soundsc(ysumaug,Fs) %Afin de v�rifier la correspondance des dur�es
%%pause 

% Courbes
%--------
% Domaine temporel
 N_Aug = length(yaug);
 t_Aug= (0:N_Aug-1)/Fs;
figure(4)
subplot(311),
plot(t_Aug,reaug),grid, xlabel('Secondes') , ylabel ('Intensit�')
title('Domaine temporel')

% Spectrogramme
figure(4)
subplot(312),spectrogram(reaug,128,120,128,Fs,'yaxis');
title('Spectrogramme') 


% Spectre (signal dans le domaine fr�quentiel)
REAUG = fft(reaug,Fs);
f = Fs/2*linspace(0,1,nf/2+1);
figure(4)
subplot(313),
plot(f,abs(REAUG(1:nf/2+1)));
xlabel('Fr�quence(Hz)'), ylabel('Intensit�')
title('Spectre')
sgtitle('Pitch augment�')

%Diminution 
%------------

a = 3;  b = 2;   %peut �tre modifi�
yvocdim = PVoc(y, a/b,Nfft,Nwind); 

% R�-�chantillonnage du signal temporel afin de garder la m�me vitesse
ydim = y; 
redim = resample(yvocdim,a,b);
if (N > length(redim)) 
    ydim = y(1:length(redim));
else 
    redim = redim(1:N);
end 
%Somme de l'original et du signal modifi�
%Attention : on doit prendre le m�me nombre d'�chantillons
%Remarque : vous pouvez mettre un coefficient � ypitch pour qu'il
%intervienne + ou - dans la somme...
ysumdim = ydim + redim;
% Ecoute
%-------
%soundsc(redim,Fs)  % Ecoute du signal modifi� afin de v�rifier la diminution du pitch
%pause
%soundsc(ysumdim,Fs) %Afin de v�rifier la correspondance des dur�es
%pause

% Courbes
%--------
N_Dim = length(ydim);
t_Dim= (0:N_Dim-1)/Fs;
figure(5)
subplot(311),
plot(t_Dim,redim),grid, xlabel('Secondes') , ylabel ('Intensit�')
title('Domaine temporel')
% 
% Spectrogramme
figure(5)
subplot(312),spectrogram(redim,128,120,128,Fs,'yaxis');
title('Spectrogramme') 
% 
% 
% Spectre (signal dans le domaine fr�quentiel)
REDIM = fft(redim,Fs);
f = Fs/2*linspace(0,1,nf/2+1);
figure(5)
subplot(313),
plot(f,abs(REDIM(1:nf/2+1)));
xlabel('Fr�quence(Hz)'), ylabel('Intensit�')
title('Spectre')
sgtitle('Pitch diminu�')


% %%
% %----------------------------
% % 3- ROBOTISATION DE LA VOIX
% %-----------------------------
% % Choix de la fr�quence porteuse (2000, 1000, 500, 200)
 Fc = 2000;   %peut �tre modifi�
% 
 yrob = Rob(y,Fc,Fs);
% 
% % Ecoute
% %-------
% soundsc(yrob,Fs)
% pause
% 
% % Courbes
%% Tra�age des courbes du spectre et du spectrogramme de yrob
figure(6)
subplot(311),plot(t,yrob),grid, xlabel('Secondes') , ylabel ('Intensit�')
title('Domaine temporel')

figure(6)
subplot(312),spectrogram(yrob,128,120,128,Fs,'yaxis');
title('Spectrogramme')

YROB = fft(yrob,Fs);
f = Fs/2*linspace(0,1,nf/2+1);
figure(6)
subplot(313),
plot(f,abs(YROB(1:nf/2+1)));
xlabel('Fr�quence(Hz)'), ylabel('Intensit�')
title('Spectre')
sgtitle('Robotisation de la voix')
