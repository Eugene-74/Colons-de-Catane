unit gestion;

interface
uses Types,affichageUnit,SysUtils,achat;
// function chagerGrille():TGrille;
// function chargementPlateau(): TPlateau;
procedure initialisationPartie(var joueurs : TJoueurs; plateau : TPlateau; affichage : TAffichage);
procedure partie(joueurs: TJoueurs;plateau:TPlateau;affichage:TAffichage);




implementation

function chagerGrille():TGrille;
var
  grille: TGrille;
begin
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
  plat : TPlateau;
begin
    grille := chagerGrille();
    plat.Grille := grille;
    chargementPlateau := plat;
end;

procedure initialisationPartie(var joueurs : TJoueurs; plateau : TPlateau; affichage : TAffichage);
var i : integer;
  coord : Tcoord;
  text : string;
  stop : Boolean;
  res : TRessources;
  r : Tressource;
begin
  for r := Aucune to Mathematiques do
    res[r] := 0;
  stop := false;
  SetLength(joueurs,0);
  i:=1;
  repeat
    write('rentrer le nom du joueur '+IntToStr(i)+' : (0 pour arêter)');
    readln(text);
    if(text <> '0') then
      begin
      SetLength(joueurs,i);
      joueurs[i-1].Nom:= text;
      joueurs[i-1].Points :=0;
      joueurs[i-1].Ressources := res;
      i := i + 1;
      end
    else 
      begin
        if(i < 3)then
          writeln('Le nombre de joueur doit être de au moins 2')
        else 
          stop := true;
      end;
  until ((i>4) or (stop));

  

  for i:=1 to 3 do
    begin
    text := 'Le joueur '+IntToStr(i)+' joue et place une connexion puis un élève';
    affichageText(text,0,coord,affichage);
    placementConnexion(plateau,affichage);
    placementEleve(plateau,affichage);
    end;

  for i:=3 downto 1 do
    begin
    text := 'Le joueur '+IntToStr(i)+' rejoue et replace une connexion puis un élève';
    affichageText(text,0,coord,affichage);
    placementConnexion(plateau,affichage);
    placementEleve(plateau,affichage);

    end;
  plateau := chargementPlateau();

  initialisationAffichage(plateau, affichage);
  affichageGrille(plateau, affichage);

end;


function nombreAleatoire(n : Integer):integer;
begin
  Randomize;  
  nombreAleatoire := Random(n) + 1;
end;

    
procedure deplacementSouillard(plateau : TPlateau;affichage : TAffichage);
begin
  writeln('deplacementSouillard activer');
end;


procedure distributionConnaissance(joueurs : TJoueurs;plateau : TPlateau;des : integer);
var q,r : integer;
  res : Tressource;
  perso : TPersonne;
  coord,coo : Tcoord;
begin
  for r:=0 to length(plateau.Grille) -1 do
    for q:=0 to length(plateau.Grille)-1 do 
      begin
        if (plateau.Grille[q,r].Numero = des) then 
          begin
            
          res := plateau.Grille[q,r].ressource;
          coord.x := q;
          coord.y := r;
          for perso in plateau.Personnes do 
            begin
              for coo in perso.Position do 
                begin
                if((coo.x = coord.x )and (coo.y = coord.y))then
                  joueurs[perso.IdJoueur].Ressources[res] := joueurs[perso.IdJoueur].Ressources[res] +1 ;
                end;
            end;
          end;
      end;

end;

procedure gestionDes(joueurs: TJoueurs;plateau:TPlateau;affichage:TAffichage);
var
  des,des1, des2: Integer;
  j : Tjoueur;


begin

  des1 := nombreAleatoire(6);
  des2 := nombreAleatoire(6);
  des := des1 + des2;
  if(des = 7)then
    deplacementSouillard(plateau,affichage)
  else 
    begin
      distributionConnaissance(joueurs,plateau,des);
    end;
  


end;

procedure tour(joueurs: TJoueurs;plateau:TPlateau;affichage:TAffichage);
var j : Tjoueur; 
begin
  for j in joueurs do 
    begin
    // TODO choisir l'ordre grace à des clicks
    achatElements(j,plateau,affichage);
    miseAJourRender(affichage);  
    gestionDes(joueurs,plateau,affichage);
    end;


end;

procedure partie(joueurs: TJoueurs;plateau:TPlateau;affichage:TAffichage);
var gagnant : integer;
  gagener : boolean;
begin
  // repeat
  tour(joueurs,plateau,affichage);

  verificationPointsVictoire(joueurs,gagener,gagnant);
  // until (gagener);
  affichageGagnant(joueurs[gagnant],affichage);

end;



end.