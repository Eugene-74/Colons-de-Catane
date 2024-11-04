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
    // plateau := chargementPlateau();
    // initialisationAffichage(plateau, affichage);

    // partie(joueurs,plateau,affichage);
    clicHexagone(plateau, affichage, coord);


    // affichageGrille(plateau, affichage);
    // clicHexagone(plateau, affichage);
  end
  else
  begin
    writeln('Test Yann');

    plateau := chargementPlateau();
    initialisationAffichage(plateau, affichage);
    writeln('initialisation fini');


    affichageGrille(plateau, affichage);

    //coord.x := 200;
    //coord.y := 500;
    //affichageTexte('test', 35, coord, affichage);

    SetLength(plateau.Connexions, 1);
    SetLength(plateau.Connexions[0].Position, 2);
    plateau.Connexions[0].Position[0].x := 3;
    plateau.Connexions[0].Position[0].y := 3;
    plateau.Connexions[0].Position[1].x := 3;
    plateau.Connexions[0].Position[1].y := 4;

    affichageConnexion(plateau.Connexions[0], affichage);

    SetLength(plateau.Personnes, 1);
    SetLength(plateau.Personnes[0].Position, 3);
    plateau.Personnes[0].Position[0].x := 2;
    plateau.Personnes[0].Position[0].y := 3;
    plateau.Personnes[0].Position[1].x := 3;
    plateau.Personnes[0].Position[1].y := 3;
    plateau.Personnes[0].Position[2].x := 2;
    plateau.Personnes[0].Position[2].y := 4;

    affichagePersonne(plateau.Personnes[0], affichage);

    plateau.Souillard.Position.x := 4;
    plateau.Souillard.Position.y := 3;

    affichageSouillard(plateau, affichage);

    miseAJourRenderer(affichage);
    clicHexagone(plateau, affichage, coord);
    writeln('Coord x : ', coord.x, ' Coord y : ', coord.y);
  end;

  writeln('Fin du programme');
end.