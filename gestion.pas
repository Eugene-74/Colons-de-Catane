program gestion;

uses Types;


function chagerGrille():TGrille;
var
  grille: TGrille;
begin
  // Initialisation de la grille 3x3 (3 lignes, 3 colonnes)
  SetLength(grille, 7, 7);

 // Ligne 1
  grille[0][0].TypeRessource := Mathematiques; grille[0][0].Numero := 1;
  grille[0][1].TypeRessource := Physique; grille[0][1].Numero := 2;
  grille[0][2].TypeRessource := Informatique; grille[0][2].Numero := 3;
  grille[0][3].TypeRessource := Chimie; grille[0][3].Numero := 4;
  grille[0][4].TypeRessource := Humanites; grille[0][4].Numero := 5;
  grille[0][5].TypeRessource := Mathematiques; grille[0][5].Numero := 6;
  grille[0][6].TypeRessource := Physique; grille[0][6].Numero := 7;

  // Ligne 2
  grille[1][0].TypeRessource := Informatique; grille[1][0].Numero := 8;
  grille[1][1].TypeRessource := Chimie; grille[1][1].Numero := 9;
  grille[1][2].TypeRessource := Humanites; grille[1][2].Numero := 10;
  grille[1][3].TypeRessource := Mathematiques; grille[1][3].Numero := 11;
  grille[1][4].TypeRessource := Physique; grille[1][4].Numero := 12;
  grille[1][5].TypeRessource := Informatique; grille[1][5].Numero := 13;
  grille[1][6].TypeRessource := Chimie; grille[1][6].Numero := 14;

  // Ligne 3
  grille[2][0].TypeRessource := Humanites; grille[2][0].Numero := 15;
  grille[2][1].TypeRessource := Mathematiques; grille[2][1].Numero := 16;
  grille[2][2].TypeRessource := Physique; grille[2][2].Numero := 17;
  grille[2][3].TypeRessource := Informatique; grille[2][3].Numero := 18;
  grille[2][4].TypeRessource := Chimie; grille[2][4].Numero := 19;
  grille[2][5].TypeRessource := Humanites; grille[2][5].Numero := 20;
  grille[2][6].TypeRessource := Mathematiques; grille[2][6].Numero := 21;

  // Ligne 4
  grille[3][0].TypeRessource := Physique; grille[3][0].Numero := 22;
  grille[3][1].TypeRessource := Informatique; grille[3][1].Numero := 23;
  grille[3][2].TypeRessource := Chimie; grille[3][2].Numero := 24;
  grille[3][3].TypeRessource := Humanites; grille[3][3].Numero := 25;
  grille[3][4].TypeRessource := Mathematiques; grille[3][4].Numero := 26;
  grille[3][5].TypeRessource := Physique; grille[3][5].Numero := 27;
  grille[3][6].TypeRessource := Informatique; grille[3][6].Numero := 28;

  // Ligne 5
  grille[4][0].TypeRessource := Chimie; grille[4][0].Numero := 29;
  grille[4][1].TypeRessource := Humanites; grille[4][1].Numero := 30;
  grille[4][2].TypeRessource := Mathematiques; grille[4][2].Numero := 31;
  grille[4][3].TypeRessource := Physique; grille[4][3].Numero := 32;
  grille[4][4].TypeRessource := Informatique; grille[4][4].Numero := 33;
  grille[4][5].TypeRessource := Chimie; grille[4][5].Numero := 34;
  grille[4][6].TypeRessource := Humanites; grille[4][6].Numero := 35;

  // Ligne 6
  grille[5][0].TypeRessource := Mathematiques; grille[5][0].Numero := 36;
  grille[5][1].TypeRessource := Physique; grille[5][1].Numero := 37;
  grille[5][2].TypeRessource := Informatique; grille[5][2].Numero := 38;
  grille[5][3].TypeRessource := Chimie; grille[5][3].Numero := 39;
  grille[5][4].TypeRessource := Humanites; grille[5][4].Numero := 40;
  grille[5][5].TypeRessource := Mathematiques; grille[5][5].Numero := 41;
  grille[5][6].TypeRessource := Physique; grille[5][6].Numero := 42;

  // Ligne 7
  grille[6][0].TypeRessource := Informatique; grille[6][0].Numero := 43;
  grille[6][1].TypeRessource := Chimie; grille[6][1].Numero := 44;
  grille[6][2].TypeRessource := Humanites; grille[6][2].Numero := 45;
  grille[6][3].TypeRessource := Mathematiques; grille[6][3].Numero := 46;
  grille[6][4].TypeRessource := Physique; grille[6][4].Numero := 47;
  grille[6][5].TypeRessource := Informatique; grille[6][5].Numero := 48;
  grille[6][6].TypeRessource := Chimie; grille[6][6].Numero := 49;

  chagerGrille:=grille;
end;


function chargementPlateau(): TPlateau;
var
  grille: TGrille;
begin
    grille := chagerGrille();

end;

procedure initialisationPartie(var joueurs : TJoueurs; plateau : TPlateau; affichage : TAffichage);
begin
    
end;


begin 


end.