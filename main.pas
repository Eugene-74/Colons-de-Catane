program main;

uses affichageUnit,types,gestion,traitement,achat,musique;

var
    affichage: TAffichage;
    plateau: TPlateau;
    joueurs: TJoueurs;

begin
    initialisationPartie(joueurs,plateau,affichage);
    
    // A elever jusqu'
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
    joueurs[0].points := 0;

    joueurs[1].Ressources[Mathematiques] := 99;
    joueurs[1].Ressources[Chimie] := 99;
    joueurs[1].Ressources[Informatique] := 99;
    joueurs[1].Ressources[Humanites] := 99;
    joueurs[1].Ressources[Physique] := 99;
    joueurs[1].points := 0;


    affichageTour(plateau,joueurs,0,affichage);
    // ici
    partie(joueurs,plateau,affichage);
end.