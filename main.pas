program main;

uses affichageUnit,types,gestion;

var 
    affichage: TAffichage;
    plateau: TPlateau;
    joueurs: TJoueurs;


begin
  initialisationPartie(joueurs,plateau,affichage);
  // plateau := chargementPlateau();
  // initialisationAffichage(plateau, affichage);

  partie(joueurs,plateau,affichage);
  clicHexagone(plateau, affichage);


  // affichageGrille(plateau, affichage);
  // clicHexagone(plateau, affichage);
  writeln('Fin du programme');
end.