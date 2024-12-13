unit Types;

interface

uses SDL2, SDL2_image,SDL2_mixer;

type
  TRessource = (Aucune, Physique, Informatique, Chimie, Humanites, Mathematiques, Rien);

  TStringTab = array of String;
  TIntegerTab = array of Integer;

  TCarteTutorat = record
    nom : String;
    description : String;
    nbr : Integer;
    utilisee : Integer;
  end;
  TCartesTutorat = array [0..4] of TCarteTutorat;

  TCoord = record
    x, y: Integer;
  end;
  TCoords = array of TCoord;

  TRessources = array [Physique..Mathematiques] of Integer;

  TJoueur = record
    Ressources: TRessources;
    Points: Integer;
    Nom: String;
    Id: Integer;
    CartesTutorat: TCartesTutorat;
    PlusGrandeConnexion : Boolean;
    PlusGrandeNombreDeWordReference : Boolean;
  end;

  TJoueurs = array of TJoueur;

  THexagone = record
    ressource: TRessource;
    Numero: Integer;
  end;

  TGrille = array of array of THexagone;

  TConnexion = record
    Position: array of TCoord;
    IdJoueur: Integer;
  end;

  TConnexions = array of TConnexion;

  TPersonne = record
    Position: array of TCoord;
    estEleve: Boolean;
    IdJoueur: Integer;
  end;
  TPersonnes = array of TPersonne;

  TSouillard = record
    Position: TCoord;
  end;

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
    // textureIconesRessources: array[Physique..Mathematiques] of PSDL_Texture;
    textureIconesCartesTutorat: array[1..5] of PSDL_Texture;
    textureContourHexagone: PSDL_Texture;
    textureContourVide : PSDL_Texture;
    textureEleve: PSDL_Texture;
    textureSouillard: PSDL_Texture;
    textureProfesseur: PSDL_Texture;
    texturePoint: PSDL_Texture;
    texturePreview: PSDL_Texture;
    textureDes : array[1..6] of PSDL_Texture;
    texturesSignes: array[0..1] of PSDL_Texture;
    texturesMusique: array[0..1] of PSDL_Texture;
    textureValider: PSDL_Texture;
    texturesFleches: array[0..1] of PSDL_Texture;
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
    musique : PMix_Music;
  end;
  TSon = (sonClicHexagone,sonFinDeTour,sonValide,sonFinDePartie,sonInvalide);
  TSons = array [sonClicHexagone..sonInvalide] of PMix_Chunk;

  TAffichage = record
    fenetre: PWindow;
    renderer: PRenderer;
    xGrid: Integer;
    yGrid: Integer;
    texturePlateau : TTexturePlateau;
    boutonsAction: TBoutons;
    boutonsMusique: TBoutons;
    musiqueActuelle : TMusique;
    sons : TSons;
  end;


const
  CARTES_TUTORAT: TCartesTutorat = (
      (nom: 'Discussion'; description: 'Une superbe discussion qui vous permettra de faire 2 nouvelles connexions.'; nbr: 10; utilisee : 0),
      (nom: 'WordReference'; description: 'Une recherche sur WordReference qui vous permetra de vous débarasser du souillard pendant un moment.'; nbr: 24; utilisee : 0),
      (nom: 'Vol de cahier'; description: 'Subtiliser en douce le cours d''un camarade pour lui voler ses connaissances dans une matière.'; nbr: 8; utilisee : 0),
      (nom: 'Annale'; description: 'Profiter d''une Annale pour développer vos connaissances dans dans une matière (2 connaissances).'; nbr: 16; utilisee : 0),
      (nom: 'Majorant'; description: 'En tant que majorant de votre classe vous avez le prestige de gagner un point de victoire.'; nbr: 4; utilisee : 0));
  
  COUT_ELEVE: TRessources = (
    (1), // Physique
    (0), // Informatique
    (1), // Chimie
    (1), // Humanites
    (1));// Mathematiques
  COUT_PROFESSEUR: TRessources = (
    (0),
    (3),
    (0),
    (0),
    (2));
  COUT_CONNEXION: TRessources = (
    (0),
    (0),
    (1),
    (1),
    (0));
  COUT_CARTE_TUTORAT: TRessources = (
    (1),
    (1),
    (0),
    (1),
    (0));

  POSITION_DES : TCoord = (x: 50; y: 400);

  WINDOW_W = 1800;
  WINDOW_H = 1000;
  tailleHexagone = 150;
  tailleEleve = tailleHexagone div 3;
  tailleSouillard = tailleHexagone div 2;

  COULEUR_TEXT_ROUGE : TSDL_Color = (r: 255; g: 0; b: 0; a: 255);
  COULEUR_TEXT_VERT : TSDL_Color = (r: 0; g: 200; b: 0; a: 255);

  COULEUR_ROUGE : TSDL_Color = (r: 200; g: 0; b: 0; a: 255);
  COULEUR_VERT : TSDL_Color = (r: 0; g: 200; b: 0; a: 255);
  COULEUR_JAUNE : TSDL_Color = (r: 200; g: 200; b: 0; a: 255);
  COULEUR_BLEU : TSDL_Color = (r: 0; g: 200; b: 200; a: 255);

  COULEUR_PREVIEW_ROUGE : TSDL_Color = (r: 100; g: 0; b: 0; a: 255);
  COULEUR_PREVIEW_VERT : TSDL_Color = (r: 0; g: 100; b: 0; a: 255);
  COULEUR_PREVIEW_JAUNE : TSDL_Color = (r: 100; g: 100; b: 0; a: 255);
  COULEUR_PREVIEW_BLEU : TSDL_Color = (r: 0; g: 100; b: 100; a: 255);
implementation
end.