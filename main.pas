program main;

uses affichageUnit,types,gestion,traitement,achat,musique;
var affichage: TAffichage;
  plateau: TPlateau;
  joueurs: TJoueurs;
begin
  initialisationPartie(joueurs,plateau,affichage);

  // joueurs[2].Ressources[Mathematiques] := 99;
  // joueurs[2].Ressources[Chimie] := 99;
  // joueurs[2].Ressources[Informatique] := 99;
  // joueurs[2].Ressources[Humanites] := 99;
  // joueurs[2].Ressources[Physique] := 99;
  
  partie(affichage,joueurs,plateau);
end.