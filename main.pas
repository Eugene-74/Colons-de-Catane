program main;

uses affichageUnit,types,gestion;

var 
    affichage: TAffichage;
    plateau: TPlateau;

begin
    plateau := chargementPlateau();
    initialisationAffichage(plateau, affichage);
    affichageGrille(plateau, affichage);
    clicHexagone(plateau, affichage);
    writeln('Fin du programme');
end.