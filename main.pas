program main;

uses affichageUnit,types;

var 
    affichage: TAffichage;
    plateau: TPlateau;

begin
    initialisationAffichagePlateau(plateau, affichage);
    affichageGrille(plateau, affichage);
end.