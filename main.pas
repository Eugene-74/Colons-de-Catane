program main;

uses affichageUnit,types,gestion,traitement,achat;

var 
    affichage: TAffichage;
    plateau: TPlateau;
    joueurs: TJoueurs;
    testYann : Boolean;
    ressources1,ressources2 : TRessources;
    ressource : TRessource;
    id : Integer;
    valeurBouton : String;
    tempCoord : Tcoord;

begin
  testYann := False;
  if not testYann then
  begin
    initialisationPartie(joueurs,plateau,affichage);

    SetLength(plateau.Personnes, 1);
    SetLength(plateau.Personnes[0].Position, 3);
    plateau.Personnes[0].Position[0] := FCoord(2,3);
    plateau.Personnes[0].Position[1] := FCoord(3,3);
    plateau.Personnes[0].Position[2] := FCoord(2,4);
    plateau.Personnes[0].estEleve := True;
    plateau.Personnes[0].IdJoueur := 0;
    
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

    affichageTour(plateau,joueurs, affichage);

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

    affichageDes(1,3,FCoord(1500,475),affichage);
    miseAJourRenderer(affichage);

    clicAction(affichage,valeurBouton);
    writeln('Valeur bouton : ', valeurBouton);

    id := 1;
    echangeRessources(joueurs,0,id,ressources1,ressources2,affichage);

    affichageTour(plateau,joueurs, affichage);

    clicAction(affichage,valeurBouton);
  end;

  writeln('Fin du programme');
end.