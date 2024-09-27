unit Types;

interface

type
  // Définition du type TRessource
  TRessource = (Mathematiques, Physique, Informatique, Chimie, Humanites);

  // Définition de TCoord
  TCoord = record
    x, y: Integer;
  end;

  // Définition de TRessourceValeur
//   TRessourceValeur = record
//     Ressource: TRessource;
//     Quantite: Integer;
//   end;

  // Définition de TRessources (tableau dynamique de TRessourceValeur)
  TRessources = array [Mathematiques..Humanites] of Integer;

  // Définition de TJoueur
  TJoueur = record
    Ressources: TRessources;
    Points: Integer;
    Id: Integer;
  end;

  // Définition de TJoueurs (tableau dynamique de TJoueur)
  TJoueurs = array of TJoueur;

  // IdJoueurActuel
  IdJoueurActuel = Integer;

  // Définition de THexagone
  THexagone = record
    TypeRessource: TRessource;
    Numero: Integer;
    Position: TCoord;
  end;

  // Définition de TGrille (tableau dynamique de THexagones à 2 dimensions)
  TGrille = array of array of THexagone;

  // Définition de TConnexion
  TConnexion = record
    Position: array of TCoord;  // Tableau dynamique de 2 TCoord
    IdJoueur: Integer;
  end;

  // Définition de TConnexions (tableau dynamique de TConnexion)
  TConnexions = array of TConnexion;

  // Définition de TPersonne
  TPersonne = record
    Position: array of TCoord;  // Tableau dynamique de 3 TCoord
    IdJoueur: Integer;
  end;

  // Définition de TPersonnes (tableau dynamique de TPersonne)
  TPersonnes = array of TPersonne;

  // Définition de TSouillard
  TSouillard = record
    Position: TCoord;
  end;

  // Définition de TPlateau
  TPlateau = record
    Grille: TGrille;
    Souillard: TSouillard;
    Personnes: TPersonnes;
    Connexions: TConnexions;
  end;

  // Définition de TAffichage (pour les transferts et mises à jour via SDL)
  TAffichage = record
    // Contenu à définir selon les besoins d'affichage avec SDL
    tset : integer;
  end;


// end;

implementation

end.
