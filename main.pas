program main;

uses affichageUnit,types;

var 
    affichage: TAffichage;
    plateau: TPlateau;

begin
    initialisationAffichage(plateau, affichage);
    affichageGrille(plateau, affichage);
    clicHexagone(plateau, affichage);
    writeln('Fin du programme');
end.