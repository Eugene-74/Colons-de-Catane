unit Types;

interface

uses SDL2, SDL2_image;

type
  // Definition du type TRessource
  TRessource = (Aucune, Physique, Informatique, Chimie, Humanites, Mathematiques, Rien);

  TStringTab = array of String;

  TCarteTutorat = record
    nom : String;
    description : String;
    nbr : Integer;
    utilisee : Integer;
  end;

  TCartesTutorat = record
    carte1 : TCarteTutorat;
    carte2 : TCarteTutorat;
    carte3 : TCarteTutorat;
    carte4 : TCarteTutorat;
    carte5 : TCarteTutorat;
  end;

  // Definition de TCoord
  TCoord = record
    x, y: Integer;
  end;

  TCoords = array of TCoord;

  // Definition de TRessources (tableau dynamique de TRessourceValeur)
  TRessources = array [Aucune..Rien] of Integer;

  // Definition de TJoueur
  TJoueur = record
    Ressources: TRessources;
    Points: Integer;
    Nom: String;
    Id: Integer;
    CartesTutorat: TCartesTutorat;
  end;

  // Definition de TJoueurs (tableau dynamique de TJoueur)
  TJoueurs = array of TJoueur;

  // IdJoueurActuel
  IdJoueurActuel = Integer;

  // Definition de THexagone
  THexagone = record
    ressource: TRessource;
    Numero: Integer;
  end;


  // Definition de TGrille (tableau dynamique de THexagones à 2 dimensions)
  TGrille = array of array of THexagone;

  // Definition de TConnexion
  TConnexion = record
    Position: array of TCoord;  // Tableau dynamique de 2 TCoord
    IdJoueur: Integer;
  end;

  // Definition de TConnexions (tableau dynamique de TConnexion)
  TConnexions = array of TConnexion;

  // Definition de TPersonne
  TPersonne = record
    Position: array of TCoord;  // Tableau dynamique de 3 TCoord
    estEleve: Boolean;
    IdJoueur: Integer;
  end;

  // Definition de TPersonnes (tableau dynamique de TPersonne)
  TPersonnes = array of TPersonne;

  // Definition de TSouillard
  TSouillard = record
    Position: TCoord;
  end;

  // Definition de TPlateau
  TPlateau = record
    Grille: TGrille;
    Souillard: TSouillard;
    Personnes: TPersonnes;
    Connexions: TConnexions;
    CartesTutorat: TCartesTutorat;
    des1 : Integer;
    des2 : Integer;
  end;
  
  PWindow = PSDL_Window;

  PRenderer = PSDL_Renderer;

  TTexturePlateau = record
    textureRessource: array[Physique..Rien] of PSDL_Texture;
    textureIconesRessources: array[Physique..Mathematiques] of PSDL_Texture;
    textureContourHexagone: PSDL_Texture;
    textureContourVide : PSDL_Texture;
    textureEleve: PSDL_Texture;
    textureSouillard: PSDL_Texture;
    textureProfesseur: PSDL_Texture;
    texturePoint: PSDL_Texture;
  end;

  TBouton = record
    coord: TCoord;
    w, h: Integer;
    texte: String;
    valeur: String;
  end;

  TBoutons = array of TBouton;

  TMusique = record
    debut : Int64;
    temps : Int64;
    active : Boolean;

  end;

  // Definition de TAffichage (pour les transferts et mises à jour via SDL)
  TAffichage = record
    fenetre: PWindow;
    renderer: PRenderer;
    xGrid: Integer;
    yGrid: Integer;
    texturePlateau : TTexturePlateau;
    boutonsAction: TBoutons;
    boutonsSysteme: TBoutons;
    musiqueActuelle : TMusique;
  end;

const
  CARTES_TUTORAT: TCartesTutorat = (
    carte1: (nom: 'discution'; description: 'discution'; nbr: 10; utilisee : 0);
    carte2: (nom: 'WordReference'; description: 'discution'; nbr: 12; utilisee : 0);
    carte3: (nom: 'Voler'; description: 'discution'; nbr: 8; utilisee : 0);
    carte4: (nom: 'Choisir 2 connaissances'; description: 'discution'; nbr: 16; utilisee : 0);
    carte5: (nom: 'le dernier'; description: 'discution'; nbr: 4; utilisee : 0)
  );

implementation

end.