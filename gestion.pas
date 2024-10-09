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

 // Ligne 1
  grille[0][0].ressource := Aucune; grille[0][0].Numero := -1;
  grille[0][1].ressource := Aucune; grille[0][1].Numero := -1;
  grille[0][2].ressource := Aucune; grille[0][2].Numero := -1;
  grille[0][3].ressource := Aucune; grille[0][3].Numero := -1;
  grille[0][4].ressource := Aucune; grille[0][4].Numero := -1;
  grille[0][5].ressource := Aucune; grille[0][5].Numero := -1;
  grille[0][6].ressource := Aucune; grille[0][6].Numero := -1;

  // Ligne 2
  grille[1][0].ressource := Aucune; grille[1][0].Numero := -1;
  grille[1][1].ressource := Aucune; grille[1][1].Numero := -1;
  grille[1][2].ressource := Aucune; grille[1][2].Numero := -1;
  grille[1][3].ressource := Aucune; grille[1][3].Numero := -1;
  grille[1][4].ressource := Mathematiques; grille[1][4].Numero := 12;
  grille[1][5].ressource := Mathematiques; grille[1][5].Numero := 0;
  grille[1][6].ressource := Mathematiques; grille[1][6].Numero := 0;

  // Ligne 3
  grille[2][0].ressource := Aucune; grille[2][0].Numero := -1;
  grille[2][1].ressource := Aucune; grille[2][1].Numero := -1;
  grille[2][2].ressource := Aucune; grille[2][2].Numero := -1;
  grille[2][3].ressource := Physique; grille[2][3].Numero := 18;
  grille[2][4].ressource := Physique; grille[2][4].Numero := 19;
  grille[2][5].ressource := Physique; grille[2][5].Numero := 20;
  grille[2][6].ressource := Physique; grille[2][6].Numero := 1;

  // Ligne 4
  grille[3][0].ressource := Informatique; grille[3][0].Numero := 22;
  grille[3][1].ressource := Informatique; grille[3][1].Numero := 23;
  grille[3][2].ressource := Informatique; grille[3][2].Numero := 24;
  grille[3][3].ressource := Informatique; grille[3][3].Numero := 25;
  grille[3][4].ressource := Informatique; grille[3][4].Numero := 26;
  grille[3][5].ressource := Informatique; grille[3][5].Numero := 27;
  grille[3][6].ressource := Informatique; grille[3][6].Numero := 28;

  // Ligne 5
  grille[4][0].ressource := Humanites; grille[4][0].Numero := 1;
  grille[4][1].ressource := Humanites; grille[4][1].Numero := 1;
  grille[4][2].ressource := Humanites; grille[4][2].Numero := 31;
  grille[4][3].ressource := Humanites; grille[4][3].Numero := 32;
  grille[4][4].ressource := Humanites; grille[4][4].Numero := 33;
  grille[4][5].ressource := Aucune; grille[4][5].Numero := -1;
  grille[4][6].ressource := Aucune; grille[4][6].Numero := -1;

  // Ligne 6
  grille[5][0].ressource := Informatique; grille[5][0].Numero := 1;
  grille[5][1].ressource := Informatique; grille[5][1].Numero := 1;
  grille[5][2].ressource := Informatique; grille[5][2].Numero := 38;
  grille[5][3].ressource := Aucune; grille[5][3].Numero := -1;
  grille[5][4].ressource := Aucune; grille[5][4].Numero := -1;
  grille[5][5].ressource := Aucune; grille[5][5].Numero := -1;
  grille[5][6].ressource := Aucune; grille[5][6].Numero := -1;

  // Ligne 7
  grille[6][0].ressource := Aucune; grille[6][0].Numero := -1;
  grille[6][1].ressource := Aucune; grille[6][1].Numero := -1;
  grille[6][2].ressource := Aucune; grille[6][2].Numero := -1;
  grille[6][3].ressource := Aucune; grille[6][3].Numero := -1;
  grille[6][4].ressource := Aucune; grille[6][4].Numero := -1;
  grille[6][5].ressource := Aucune; grille[6][5].Numero := -1;
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