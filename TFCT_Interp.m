function y = TFCT_Interp(X,t,Nov)
    % y = TFCT_Interp(X, t, hop)
    % Interpolation du vecteur issu de la TFCT
    %
    % X : matrice issue de la TFCT
    % t : vecteur des temps (valeurs réelles) sur lesquels on interpole
    % Pour chaque valeur de t (et chaque colonne), on interpole le module du spectre
    % et on détermine la différence de phase entre 2 colonnes successives de X
    %
    % y : la sortie est une matrice où chaque colonne correspond à l'interpolation de la colonne correspondante de X
    % en préservant le saut de phase d'une colonne à l'autre
    %
    % Remarque : programme largement inspiré d'un programme fait à l'université de Columbia
    [nl,nc] = size(X); % récupération des dimensions de X
    N = 2*(nl-1); % calcul de N (= Nfft en principe)
    % Initialisations
    %
    % Spectre interpolé
    y = zeros(nl, length(t));
    % Phase initiale
    phi = zeros(nl,1);
    phi = angle(X(:,1));
    % Déphasage entre chaque échantillon de la TF
    dphi0 = zeros(nl,1); %initialisation
    dphi0(2:nl) = (2*pi*Nov)./(N./(1:(N/2)));
    % Premier indice de la colonne interpolée à calculer
    % (première colonne de Y). Cet indice sera incrémenté
    % dans la boucle
    Ncy = 1;
    % On ajoute à X une colonne de zéros pour éviter le problème de
    % X( : , Ncx2) en fin de boucle (Ncx2 peut être égal à nc+1)
    X = [X,zeros(nl,1)];

    % Boucle pour l'interpolation, Pour chaque valeur de t on calcule la nouvelle colonne de Y à partir de 2 colonnes successives de X
    for Ncx1 = 1:nc-1
        % Calcul de la phase initiale de la colonne suivante
        phi = phi + dphi0;
        % Calcul de la phase finale de la colonne suivante
        phi2 = angle(X(:,Ncx1+1));
        % Calcul du déphasage entre les 2 colonnes
        dphi = phi2 - phi;
        % Calcul de la phase finale de la colonne suivante
        phi = phi2;
        % Calcul du déphasage entre les 2 colonnes
        Ncx2 = Ncx1;
        % Calcul de la colonne suivante de Y à partir des 2 colonnes successives de X et du déphasage entre les 2 colonnes
        while t(Ncy) < Ncx2 -1
            % Calcul de la phase finale de la colonne à calculer
            phi2 = phi + dphi*(t(Ncy)-Ncx1);
            % Calcul de la colonne à calculer
            y(:,Ncy) = abs(X(:,Ncx1)).*exp(1i*phi2);
            % Incrémentation de l'indice de la colonne à calculer
            Ncy = Ncy + 1;
            % Si on a atteint la fin du vecteur t, on sort de la boucle
            if Ncy > length(t)
                break
            end
        end
    end
end