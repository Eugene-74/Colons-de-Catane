unit Types;

interface

uses SDL2, SDL2_image,SDL2_mixer;

type
  // Definition du type TRessource
  TRessource = (Aucune, Physique, Informatique, Chimie, Humanites, Mathematiques, Rien);

  TStringTab = array of String;

  TCarteTutorat = record
    nom : String;
    valeur : String;
    description : String;
    nbr : Integer;
    utilisee : Integer;
  end;

  // TODO Opti ce type en tableau dynamique de 5 TCarteTutorat (Yann)
  TCartesTutorat = array [0..4] of TCarteTutorat;
    // cartes : 
    // carte1 : TCarteTutorat;
    // carte2 : TCarteTutorat;
    // carte3 : TCarteTutorat;
    // carte4 : TCarteTutorat;
    // carte5 : TCarteTutorat;
  // end;

  // Definition de TCoord
  TCoord = record
    x, y: Integer;
  end;

  TCoords = array of TCoord;

  // Definition de TRessources (tableau dynamique de TRessourceValeur)
  TRessources = array [Physique..Mathematiques] of Integer;

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
    textureIconesCartesTutorat: array[1..5] of PSDL_Texture;
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

  TSon = (sonClicHexagone,sonClicBouton,sonFinDeTour,sonValide,sonInvalide);

  TSons = array [sonClicHexagone..sonInvalide] of PMix_Chunk;

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
    sons : TSons;

  end;



const
  CARTES_TUTORAT: TCartesTutorat = (
      (nom: 'Discussion'; valeur: 'discussion'; description: 'discussion'; nbr: 10; utilisee : 0),
      (nom: 'WordReference'; valeur: 'wordreference'; description: 'discussion'; nbr: 12; utilisee : 0),
      (nom: 'Voler'; valeur: 'voler'; description: 'discussion'; nbr: 8; utilisee : 0),
      (nom: 'Choisir 2 connaissances'; valeur: 'choix_connaissances'; description: 'discussion'; nbr: 16; utilisee : 0),
      (nom: 'le dernier'; valeur: 'dernier'; description: 'discussion'; nbr: 4; utilisee : 0)
    
  );

implementation

end.