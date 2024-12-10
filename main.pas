program main;

uses affichageUnit,types,gestion,traitement,achat,musique;
var affichage: TAffichage;
  plateau: TPlateau;
  joueurs: TJoueurs;
begin
  randomize;  
  initialisationPartie(joueurs,plateau,affichage);
  
  joueurs[0].Ressources[Mathematiques] := 99;
  joueurs[0].Ressources[Chimie] := 99;
  joueurs[0].Ressources[Informatique] := 99;
  joueurs[0].Ressources[Humanites] := 99;
  joueurs[0].Ressources[Physique] := 99;
  partie(affichage,joueurs,plateau);
end.