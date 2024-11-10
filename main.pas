program main;

uses affichageUnit,types,gestion;

var 
    affichage: TAffichage;
    plateau: TPlateau;
    joueurs: TJoueurs;
    testYann : Boolean;
    coord : Tcoord;
    ressources1,ressources2 : TRessources;
    id1,id2 : Integer;

begin
  testYann := True;
  if not testYann then
  begin
    initialisationPartie(joueurs,plateau,affichage);

    partie(joueurs,plateau,affichage);
    // clicHexagone(plateau, affichage, coord);

  end
  else
  begin
    writeln('Test Yann');

  // 1 plateau normal 2 plateau sans bord
    plateau := chargementPlateau(1);
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

    affichageTour(plateau,joueurs, affichage);

    id1 := 0;
    id2 := 0;
    setLength(joueurs, 2);
    joueurs[0].Nom := 'n1';
    joueurs[0].Id := 0;
    joueurs[1].Nom := 'n2';

    echangeRessources(joueurs,id1,id2,ressources1,ressources2,affichage);
    //affichageDes(1,2,affichage);
    miseAJourRenderer(affichage);

    clicHexagone(plateau, affichage, coord);
    writeln('Coord x : ', coord.x, ' Coord y : ', coord.y);
  end;

  writeln('Fin du programme');
end.