unit gestion;

interface
uses Types;
function chagerGrille():TGrille;


implementation

function chagerGrille():TGrille;
var
  grille: TGrille;
begin
  // Initialisation de la grille 3x3 (3 lignes, 3 colonnes)
  SetLength(grille, 7, 7);

  grille[0][0].ressource := Aucune; grille[0][0].Numero := -1;
  grille[1][0].ressource := Aucune; grille[1][0].Numero := -1;
  grille[2][0].ressource := Aucune; grille[2][0].Numero := -1;
  grille[3][0].ressource := Aucune; grille[3][0].Numero := -1;
  grille[4][0].ressource := Aucune; grille[4][0].Numero := -1;
  grille[5][0].ressource := Aucune; grille[5][0].Numero := -1;
  grille[6][0].ressource := Aucune; grille[6][0].Numero := -1;

  grille[0][1].ressource := Aucune; grille[0][1].Numero := -1;
  grille[1][1].ressource := Aucune; grille[1][1].Numero := -1;
  grille[2][1].ressource := Aucune; grille[2][1].Numero := -1;
  grille[3][1].ressource := Humanites; grille[3][1].Numero := 6;
  grille[4][1].ressource := Physique; grille[4][1].Numero := 3;
  grille[5][1].ressource := Physique; grille[5][1].Numero := 8;
  grille[6][1].ressource := Aucune; grille[6][1].Numero := -1;

  grille[0][2].ressource := Aucune; grille[0][2].Numero := -1;
  grille[1][2].ressource := Aucune; grille[1][2].Numero := -1;
  grille[2][2].ressource := Mathematiques; grille[2][2].Numero := 2;
  grille[3][2].ressource := Informatique; grille[3][2].Numero := 4;
  grille[4][2].ressource := Mathematiques; grille[4][2].Numero := 5;
  grille[5][2].ressource := Humanites; grille[5][2].Numero := 10;
  grille[6][2].ressource := Aucune; grille[6][2].Numero := -1;

  grille[0][3].ressource := Aucune; grille[0][3].Numero := -1;
  grille[1][3].ressource := Humanites; grille[1][3].Numero := 5;
  grille[2][3].ressource := Chimie; grille[2][3].Numero := 9;
  grille[3][3].ressource := Aucune; grille[3][3].Numero := 0;
  grille[4][3].ressource := Informatique; grille[4][3].Numero := 6;
  grille[5][3].ressource := Mathematiques; grille[5][3].Numero := 9;
  grille[6][3].ressource := Aucune; grille[6][3].Numero := 61;

  grille[0][4].ressource := Aucune; grille[0][4].Numero := -1;
  grille[1][4].ressource := Mathematiques; grille[1][4].Numero := 10;
  grille[2][4].ressource := Informatique; grille[2][4].Numero := 11;
  grille[3][4].ressource := Humanites; grille[3][4].Numero := 3;
  grille[4][4].ressource := Physique; grille[4][4].Numero := 12;
  grille[5][4].ressource := Aucune; grille[5][4].Numero := -1;
  grille[6][4].ressource := Aucune; grille[6][4].Numero := -1;

  grille[0][5].ressource := Aucune; grille[0][5].Numero := -1;
  grille[1][5].ressource := Chimie; grille[1][5].Numero := 8;
  grille[2][5].ressource := Physique; grille[2][5].Numero := 4;
  grille[3][5].ressource := Chimie; grille[3][5].Numero := 11;
  grille[4][5].ressource := Aucune; grille[4][5].Numero := -1;
  grille[5][5].ressource := Aucune; grille[5][5].Numero := -1;
  grille[6][5].ressource := Aucune; grille[6][5].Numero := -1;

  grille[0][6].ressource := Aucune; grille[0][6].Numero := -1;
  grille[1][6].ressource := Aucune; grille[1][6].Numero := -1;
  grille[2][6].ressource := Aucune; grille[2][6].Numero := -1;
  grille[3][6].ressource := Aucune; grille[3][6].Numero := -1;
  grille[4][6].ressource := Aucune; grille[4][6].Numero := -1;
  grille[5][6].ressource := Aucune; grille[5][6].Numero := -1;
  grille[6][6].ressource := Aucune; grille[6][6].Numero := -1;


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


end.