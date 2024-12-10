unit traitement;

interface

uses Types,SDL2,Math;

procedure hexaToCart(coord: TCoord; var coord_output: TCoord; taille:Integer);
procedure cartToHexa(coord: TCoord; var coord_output: TCoord; taille:Integer);
procedure round_hexa(q_f,r_f:Real; var coord_output: TCoord);
procedure ajouterBoutonTableau(bouton: TBouton; var boutons: TBoutons);
procedure calculPosConnexion(connexion: TConnexion; var coord: Tcoord; var longueur: Real; var angle: Real);

function enContact(hexagones: TCoords): Boolean;
function sontAdjacents(coord1, coord2: TCoord): Boolean;
function splitValeur(texte: String): TStringTab;
function FCoord(x, y: Integer): TCoord;
function FCouleur(r, g, b, a: Integer): TSDL_Color;
function FRect(x, y, w, h: Integer): TSDL_Rect;
function FBouton(x, y, w, h: Integer; texte,valeur: String): TBouton;
function recupererCouleurJoueur(joueurId: Integer):TSDL_Color;
function calculPosPersonne(personne : TPersonne): Tcoord;
function dansLePlateau(plateau : TPlateau; coord : Tcoord): boolean;
function dansLaGrille(plateau : TPlateau; coord : Tcoord): boolean;
function CoordsEgales(coords1: TCoords; coords2: TCoords): Boolean;
function aLesRessources(joueur : Tjoueur; ressources : TRessources):boolean;
procedure enleverRessources( var joueur : Tjoueur; ressources : TRessources);

implementation



procedure round_hexa(q_f,r_f: Real; var coord_output: TCoord);
var s: Integer;
    s_f,dq,dr,ds: Real;
begin
  s_f:= -q_f-r_f;
  coord_output.x:= Round(q_f);
  coord_output.y:= Round(r_f);
  s:= Round(s_f);

  dq := Abs(coord_output.x-q_f);
  dr := Abs(coord_output.y-r_f);
  ds := Abs(s-s_f);

  if (dq > dr) and (dq > ds) then
    coord_output.x := -coord_output.y-s
  else if (dr > ds) then
    coord_output.y := -coord_output.x-s;
end;

procedure hexaToCart(coord: TCoord; var coord_output: TCoord; taille:Integer);
begin
    coord_output := FCoord(Round(taille*(sqrt(3)*coord.x+sqrt(3)/2*coord.y)),Round(taille*((3/2)*coord.y)));
end;

procedure cartToHexa(coord: TCoord; var coord_output: TCoord; taille:Integer);
var q_f,r_f:Real;
begin
    q_f := (coord.x*sqrt(3)/3-coord.y/3)/taille;
    r_f := (coord.y*2/3)/taille;
    round_hexa(q_f,r_f,coord_output);
end;

function sontAdjacents(coord1, coord2: TCoord): Boolean;
var dq, dr: Integer;
begin
    dq := coord1.x - coord2.x;
    dr := coord1.y - coord2.y;

    sontAdjacents := ((Abs(dq) = 1) and (dr = 0)) or ((Abs(dr) = 1) and (dq = 0)) or ((dq = -1) and (dr = 1)) or ((dq = 1) and (dr = -1));
end;

function enContact(hexagones: TCoords): Boolean;
var i,j: Integer;
begin
  enContact := True;
  for i := 0 to length(hexagones) - 1 do
    for j := i + 1 to length(hexagones) - 1 do
      if not sontAdjacents(hexagones[i], hexagones[j]) then
        enContact := False;
end;

function splitValeur(texte: String): TStringTab;
var i : Integer;
  tab: TStringTab;
begin
  i := 1;
  setLength(tab, 1);
  tab[length(tab)] := '';
  while i <= Length(texte) do
  begin
    if texte[i] = '_' then
    begin
      setLength(tab, length(tab)+1);
      tab[length(tab)] := '';
    end
    else
      tab[length(tab)-1] := tab[length(tab)-1] + texte[i];
    i := i + 1;
  end;
  splitValeur := tab;
end;

function FCoord(x, y: Integer): TCoord;
begin
  FCoord.x := x;
  FCoord.y := y;
end;

function FCouleur(r, g, b, a: Integer): TSDL_Color;
begin
  FCouleur.r := r;
  FCouleur.g := g;
  FCouleur.b := b;
  FCouleur.a := a;
end;

function FRect(x, y, w, h: Integer): TSDL_Rect;
begin
  FRect.x := x;
  FRect.y := y;
  FRect.w := w;
  FRect.h := h;
end;

function FBouton(x, y, w, h: Integer; texte,valeur: String): TBouton;
begin
  FBouton.coord := FCoord(x, y);
  FBouton.w := w;
  FBouton.h := h;
  FBouton.texte := texte;
  FBouton.valeur := valeur;
end;

{Calcul les coordonnees d'une connexion
Preconditions :
    - connexion : la connexion à calculer
Postconditions :
    - coord (TCoord) : les coordonnees du milieu de la connexion
    - longueur (Real) : la longueur de la connexion
    - angle (Real) : l'angle de la connexion}
procedure calculPosConnexion(connexion: TConnexion; var coord: Tcoord; var longueur: Real; var angle: Real);
var dx,dy: Integer;
  coord2: Tcoord;
begin
  hexaToCart(connexion.Position[0],coord,tailleHexagone div 2);
  hexaToCart(connexion.Position[1],coord2,tailleHexagone div 2);

  dx := coord2.x - coord.x;
  dy := coord2.y - coord.y;

  coord := FCoord((coord.x + coord2.x) div 2,(coord.y + coord2.y) div 2);

  longueur := tailleHexagone div 2;
  angle := RadToDeg(arctan2(dy,dx)+PI/2);
end;

{Renvoie la couleur associe au joueur
Preconditions :
    - joueurId : l'identifiant du joueur
Postconditions :
    - couleur (TSDL_Color) : la couleur associee au joueur}
function recupererCouleurJoueur(joueurId: Integer):TSDL_Color;
begin
  case joueurId of
    0:
      recupererCouleurJoueur := COULEUR_ROUGE;
    1:
      recupererCouleurJoueur := COULEUR_VERT;
    2:
      recupererCouleurJoueur := COULEUR_BLEU;
    3:
      recupererCouleurJoueur := COULEUR_JAUNE;
    -1:
      recupererCouleurJoueur := COULEUR_PREVIEW_ROUGE;
    -2:
      recupererCouleurJoueur := COULEUR_PREVIEW_VERT;
    -3:
      recupererCouleurJoueur := COULEUR_PREVIEW_BLEU;
    -4:
      recupererCouleurJoueur := COULEUR_PREVIEW_JAUNE;
  end;
end;

{Calcul les coordonnees d'une personne
Preconditions :
    - personne : la personne à calculer
Postconditions :
    - TCoord : les coordonnees de la personne}
function calculPosPersonne(personne : TPersonne): Tcoord;
var scoord,coord: Tcoord;
  i: Integer;
begin
  scoord := FCoord(0,0);
  
  for i:=0 to length(personne.Position)-1 do
  begin
    hexaToCart(personne.Position[i],coord,tailleHexagone div 2);
    scoord := FCoord(scoord.x + coord.x,scoord.y + coord.y);
  end;

  calculPosPersonne := FCoord(scoord.x div 3,scoord.y div 3);
end;

procedure ajouterBoutonTableau(bouton: TBouton; var boutons: TBoutons);
begin
  setLength(boutons, length(boutons)+1);
  boutons[length(boutons)-1] := bouton;
end;

function dansLePlateau(plateau : TPlateau; coord : Tcoord): boolean;
begin
  dansLePlateau := false;

  if(coord.x < 0) or (coord.x >= length(plateau.Grille)) or (coord.y < 0) or (coord.y >= length(plateau.Grille)) then
    exit(false);

  if((plateau.Grille[coord.x][coord.y].ressource <> Aucune)
      and (plateau.Grille[coord.x][coord.y].ressource <> Rien)) then
    dansLePlateau := true;
end;

function dansLaGrille(plateau : TPlateau; coord : Tcoord): boolean;
begin
  dansLaGrille := false;

  if(coord.x < 0) or (coord.x >= length(plateau.Grille)) or (coord.y < 0) or (coord.y >= length(plateau.Grille)) then
    exit(false);

  if(plateau.Grille[coord.x][coord.y].ressource <> Aucune) then
    dansLaGrille := true;
end;

function CoordsEgales(coords1: TCoords; coords2: TCoords): Boolean;
var i : Integer;
begin
  CoordsEgales := True;

  if (Length(coords1) <> Length(coords2)) then
    exit(False);

  for i := 0 to length(coords1) -1 do
    if not ((coords1[i].x = coords2[i].x) and (coords1[i].y = coords2[i].y)) and
        not ((coords1[i].x = coords2[length(coords2) -1 - i].x) and (coords1[i].y = coords2[length(coords2) -1 - i].y)) then
      exit(False);
end;

function aLesRessources(joueur : Tjoueur; ressources : TRessources):boolean;
var res : TRessource;
begin
  aLesRessources := True;
  for res in [Physique..Mathematiques] do
    if(joueur.ressources[res] < ressources[res]) then
      aLesRessources := False;
end;

procedure enleverRessources( var joueur : Tjoueur; ressources : TRessources);
var res : TRessource;
begin
  for res in [Physique..Mathematiques] do
    joueur.ressources[res] := joueur.ressources[res] - ressources[res]
end;
end.