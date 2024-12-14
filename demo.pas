program demo;

uses affichageUnit,types,gestion,traitement,achat,musique;
var affichage: TAffichage;
  plateau: TPlateau;
  joueurs: TJoueurs;
  ressource : TRessource;
begin
  initialisationPartie(joueurs,plateau,affichage);

  // Ces ajouts sont exlusivement pour la démonstration
  // IL FAUT 3 JOUEURS MINIMUM
  for ressource := Physique to Mathematiques do
    joueurs[2].Ressources[ressource] := 80;

  partie(affichage,joueurs,plateau);
end.
