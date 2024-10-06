unit Types;

interface

uses SDL2, SDL2_image;

type
  // Définition du type TRessource
  TRessource = (Aucune, Physique, Informatique, Chimie, Humanites, Mathematiques);

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
  TRessources = array [Aucune..Mathematiques] of Integer;

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
    ressource: TRessource;
    Numero: Integer;
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
  
  PWindow = PSDL_Window;

  PRenderer = PSDL_Renderer;

  TTexturePlateau = record
    textureRessource: array[Physique..Mathematiques] of PSDL_Texture;
  end;

  // Définition de TAffichage (pour les transferts et mises à jour via SDL)
  TAffichage = record
    fenetre: PWindow;
    renderer: PRenderer;
    xGrid: Integer;
    yGrid: Integer;
    texturePlateau : TTexturePlateau;
  end;

// end;

implementation

end.
