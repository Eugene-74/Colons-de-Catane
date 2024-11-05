program main;

uses affichageUnit,types,gestion;

var 
    affichage: TAffichage;
    plateau: TPlateau;
    joueurs: TJoueurs;
    testYann : Boolean;
    coord : Tcoord;

begin
  testYann := False;
  if not testYann then
  begin
    initialisationPartie(joueurs,plateau,affichage);

    partie(joueurs,plateau,affichage);
    clicHexagone(plateau, affichage, coord);

    // plateau := chargementPlateau();
    // initialisationAffichage(affichage);



    // affichageGrille(plateau, affichage);
    // clicHexagone(plateau, affichage);
  end
  else
  begin
    writeln('Test Yann');

    plateau := chargementPlateau();
    initialisationAffichage(affichage);
    writeln('initialisation fini');

    coord.x := 500;
    coord.y := 750;
    affichageTexte('test', 35, coord, affichage);

    SetLength(plateau.Connexions, 1);
    SetLength(plateau.Connexions[0].Position, 2);
    plateau.Connexions[0].Position[0].x := 3;
    plateau.Connexions[0].Position[0].y := 1;
    plateau.Connexions[0].Position[1].x := 2;
    plateau.Connexions[0].Position[1].y := 2;
    plateau.Connexions[0].IdJoueur := 4;

    SetLength(plateau.Personnes, 1);
    SetLength(plateau.Personnes[0].Position, 3);
    plateau.Personnes[0].Position[0].x := 2;
    plateau.Personnes[0].Position[0].y := 3;
    plateau.Personnes[0].Position[1].x := 3;
    plateau.Personnes[0].Position[1].y := 3;
    plateau.Personnes[0].Position[2].x := 2;
    plateau.Personnes[0].Position[2].y := 4;
    plateau.Personnes[0].IdJoueur := 3;

    plateau.Souillard.Position.x := 4;
    plateau.Souillard.Position.y := 3;

    affichageTour(plateau, affichage);
    clicHexagone(plateau, affichage, coord);
    writeln('Coord x : ', coord.x, ' Coord y : ', coord.y);
  end;

  writeln('Fin du programme');
end.