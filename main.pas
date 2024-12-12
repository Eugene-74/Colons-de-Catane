program main;

uses affichageUnit,types,gestion,traitement,achat,musique;
var affichage: TAffichage;
  plateau: TPlateau;
  joueurs: TJoueurs;
begin
  randomize;  
  initialisationPartie(joueurs,plateau,affichage);
  
  demarrer_musique();
  
  partie(affichage,joueurs,plateau);
end.