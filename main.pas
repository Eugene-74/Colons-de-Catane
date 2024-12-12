program main;

uses affichageUnit,types,gestion,traitement,achat,musique;
var affichage: TAffichage;
  plateau: TPlateau;
  joueurs: TJoueurs;
begin
  initialisationPartie(joueurs,plateau,affichage);

    resteEmplacementConnexion(affichage,plateau,joueurs[0]);
    resteEmplacementConnexion(affichage,plateau,joueurs[0]);
    resteEmplacementConnexion(affichage,plateau,joueurs[0]);
    resteEmplacementConnexion(affichage,plateau,joueurs[0]);
    resteEmplacementConnexion(affichage,plateau,joueurs[0]);
    resteEmplacementConnexion(affichage,plateau,joueurs[0]);
    resteEmplacementConnexion(affichage,plateau,joueurs[0]);
    resteEmplacementConnexion(affichage,plateau,joueurs[0]);
    resteEmplacementConnexion(affichage,plateau,joueurs[0]);
    resteEmplacementConnexion(affichage,plateau,joueurs[0]);
    resteEmplacementConnexion(affichage,plateau,joueurs[0]);
    resteEmplacementConnexion(affichage,plateau,joueurs[0]);

  partie(affichage,joueurs,plateau);
end.