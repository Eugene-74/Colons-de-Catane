program main;

uses affichageUnit,types,gestion,traitement,achat,musique;

var
    affichage: TAffichage;
    plateau: TPlateau;
    joueurs: TJoueurs;
    testYann : Boolean;
    ressources1,ressources2 : TRessources;
    ressource : TRessource;
    id : Integer;
    valeurBouton : String;

begin
    testYann := False;
    if not testYann then
    begin
        demarrerMusique(affichage);
        // TODO enlever
        arreterMusique(affichage);

        initialisationPartie(joueurs,plateau,affichage);

        SetLength(plateau.Connexions, 1);
        SetLength(plateau.Connexions[0].Position, 2);
        plateau.Connexions[0].Position[0].x := 2;
        plateau.Connexions[0].Position[0].y := 3;
        plateau.Connexions[0].Position[1].x := 3;
        plateau.Connexions[0].Position[1].y := 3;
        plateau.Connexions[0].IdJoueur := 0;

        setLength(plateau.Connexions, 2);
        SetLength(plateau.Connexions[1].Position, 2);
        plateau.Connexions[1].Position[0].x := 3;
        plateau.Connexions[1].Position[0].y := 2;
        plateau.Connexions[1].Position[1].x := 3;
        plateau.Connexions[1].Position[1].y := 3;
        plateau.Connexions[1].IdJoueur := 1;

        SetLength(plateau.Personnes, 1);
        SetLength(plateau.Personnes[0].Position, 3);
        plateau.Personnes[0].Position[0] := FCoord(2,3);
        plateau.Personnes[0].Position[1] := FCoord(3,3);
        plateau.Personnes[0].Position[2] := FCoord(2,4);
        plateau.Personnes[0].estEleve := True;
        plateau.Personnes[0].IdJoueur := 0;

        joueurs[0].Ressources[Mathematiques] := 99;
        joueurs[0].Ressources[Chimie] := 99;
        joueurs[0].Ressources[Informatique] := 99;
        joueurs[0].Ressources[Humanites] := 99;
        joueurs[0].Ressources[Physique] := 99;


        joueurs[1].Ressources[Mathematiques] := 99;
        joueurs[1].Ressources[Chimie] := 99;
        joueurs[1].Ressources[Informatique] := 99;
        joueurs[1].Ressources[Humanites] := 99;
        joueurs[1].Ressources[Physique] := 99;

        partie(joueurs,plateau,affichage);

    end
    else
    begin
        writeln('Test Yann');

    // 1 plateau normal 2 plateau sans bord
    plateau := chargementPlateau(1);
    initialisationAffichage(affichage);

    SetLength(plateau.Connexions, 1);
    SetLength(plateau.Connexions[0].Position, 2);
    plateau.Connexions[0].Position[0] := FCoord(3,1);
    plateau.Connexions[0].Position[1] := FCoord(2,2);
    plateau.Connexions[0].IdJoueur := 4;

    SetLength(plateau.Personnes, 1);
    SetLength(plateau.Personnes[0].Position, 3);
    plateau.Personnes[0].Position[0] := FCoord(2,3);
    plateau.Personnes[0].Position[1] := FCoord(3,3);
    plateau.Personnes[0].Position[2] := FCoord(2,4);
    plateau.Personnes[0].IdJoueur := 3;

    plateau.Souillard.Position := FCoord(4,3);

    plateau.des1 := 1;
    plateau.des2 := 3;

    affichageTour(plateau,joueurs, affichage);

    affichageInformation('salut', 25, FCouleur(0,0,0,255), affichage);

    suppressionInformation(affichage);
    
    setLength(joueurs, 3);
    joueurs[0].Nom := 'Patrick';
    joueurs[0].Id := 0;
    joueurs[1].Nom := 'Michel';
    joueurs[1].Id := 1;
    joueurs[2].Nom := 'Bob';
    joueurs[2].Id := 2;
    for ressource := Physique to Mathematiques do
    begin
        joueurs[0].ressources[ressource] := 5;
        joueurs[1].ressources[ressource] := 3;
    end;
    miseAJourRenderer(affichage);

    clicAction(affichage,valeurBouton);

    id := 1;
    echangeRessources(joueurs,0,id,ressources1,ressources2,affichage);

    affichageTour(plateau,joueurs, affichage);

    clicAction(affichage,valeurBouton);
end;

writeln('Fin du programme');
end.