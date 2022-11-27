%Fonction rob qui permet de faire la robotisation du signal en fonction de la fréquence Fc
%nous allons moduler un sinusoïde à une fréquence Fc 
function yrob = Rob(y,Fc,Fs)
    %y est le signal à moduler
    N = length(y);
    %N est la longueur du signal
    t = (N-1)/Fs;
%     %t est le vecteur temps
%   création d'une matrice yrob vide de taille Nx1
    yrob = zeros(N,1);
    intervalle=5; % Valeur à faire varier pour avoir plus ou moins de fidélité à la voix.
    % Plus intervalle est élevé, plus la voix sera robotique.
    synth = 0;
    %création d'une boucle de 1 à N qui affectera à chaque indice de yrob sa valeur "robotisée" 
    for m = 1:N
        if mod(m,intervalle)==0
           synth = y(m)*exp(-2*1i*pi*Fc*t);
        end   
        yrob(m) = synth;    
    end
    %récupération de la partie réelle du signal
     yrob = real(yrob);
end