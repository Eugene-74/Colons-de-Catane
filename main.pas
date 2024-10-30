program main;

uses affichageUnit,types,gestion;

var 
    affichage: TAffichage;
    plateau: TPlateau;
    joueurs: TJoueurs;
    testYann : Boolean;
    coord : Tcoord;

begin
  testYann := True;
  if not testYann then
  begin
    initialisationPartie(joueurs,plateau,affichage);
    // plateau := chargementPlateau();
    // initialisationAffichage(plateau, affichage);

    partie(joueurs,plateau,affichage);
    clicHexagone(plateau, affichage, coord);


    // affichageGrille(plateau, affichage);
    // clicHexagone(plateau, affichage);
  end
  else
  begin
    writeln('Test Yann');

    plateau := chargementPlateau();
    initialisationAffichage(plateau, affichage);

    affichageGrille(plateau, affichage);
    clicHexagone(plateau, affichage, coord);
    writeln('Coord x : ', coord.x, ' Coord y : ', coord.y);
  end;
  
  writeln('Fin du programme');
end.