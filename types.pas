unit Types;

interface

uses SDL2, SDL2_image;

type
  // Définition du type TRessource
  TRessource = (Aucune, Physique, Informatique, Chimie, Humanites, Mathematiques, Rien);

  TStringTab = array of String;

  TCarteTutorat = record
    nom : String;
    description : String;
    nbr : Integer;
  end;

  TCartesTutorat = record
    carte1 : TCarteTutorat;
    carte2 : TCarteTutorat;
    carte3 : TCarteTutorat;
    carte4 : TCarteTutorat;
    carte5 : TCarteTutorat;

  end;

  // Définition de TCoord
  TCoord = record
    x, y: Integer;
  end;

  TCoords = array of TCoord;

  // Définition de TRessourceValeur
//   TRessourceValeur = record
//     Ressource: TRessource;
//     Quantite: Integer;
//   end;

  // Définition de TRessources (tableau dynamique de TRessourceValeur)
  TRessources = array [Aucune..Rien] of Integer;

  // Définition de TJoueur
  TJoueur = record
    Ressources: TRessources;
    Points: Integer;
    Nom: String;
    Id: Integer;
    CartesTutorat: TCartesTutorat;

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
    estEleve: Boolean;
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
    CartesTutorat: TCartesTutorat;
  end;
  
  PWindow = PSDL_Window;

  PRenderer = PSDL_Renderer;

  TTexturePlateau = record
    textureRessource: array[Physique..Mathematiques] of PSDL_Texture;
    textureContourHexagone: PSDL_Texture;
    textureEleve: PSDL_Texture;
    textureSouillard: PSDL_Texture;
    textureProfesseur: PSDL_Texture;
  end;

  TBouton = record
    coord: TCoord;
    w, h: Integer;
    texte: String;
    valeur: String;
  end;

  TBoutons = array of TBouton;

  // Définition de TAffichage (pour les transferts et mises à jour via SDL)
  TAffichage = record
    fenetre: PWindow;
    renderer: PRenderer;
    xGrid: Integer;
    yGrid: Integer;
    texturePlateau : TTexturePlateau;
    boutonsAction: TBoutons;
  end;

const
  CARTES_TUTORAT: TCartesTutorat = (
    carte1: (nom: 'discution'; description: 'discution'; nbr: 10);
    carte2: (nom: 'WordReference'; description: 'discution'; nbr: 12);
    carte3: (nom: 'Voler'; description: 'discution'; nbr: 8);
    carte4: (nom: 'Choisir 2 connaissances'; description: 'discution'; nbr: 16);
    carte5: (nom: 'le dernier'; description: 'discution'; nbr: 4)
  );

implementation

end.