program demo;

uses affichageUnit,types,gestion,traitement,achat,musique;
var affichage: TAffichage;
  plateau: TPlateau;
  joueurs: TJoueurs;

  ressource : TRessource;
begin
  initialisationPartie(joueurs,plateau,affichage);

  // Ces ajout son exlusivement pour la démonstration
  // IL FAUT OBLIGATOIREMENT 3 JOUEURS MINIMUM
  for ressource := Physique to Mathematiques do
    joueurs[2].Ressources[ressource] := 80;

  partie(affichage,joueurs,plateau);
end.