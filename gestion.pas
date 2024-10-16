unit gestion;

interface
uses Types,affichageUnit,SysUtils,achat;
// function chagerGrille():TGrille;
// function chargementPlateau(): TPlateau;
procedure initialisationPartie(var joueurs : TJoueurs; plateau : TPlateau; affichage : TAffichage);
procedure partie(joueurs: TJoueurs;plateau:TPlateau;affichage:TAffichage);




implementation

function chagerGrille(): TGrille;
var 
  grille: TGrille;
  numeros: array of array of Integer;
  ressources: array of array of TRessource;
  i, j: Integer;
  num : Integer;
begin
// Tableau static pose des problème
  SetLength(grille, 7, 7);

  SetLength(ressources, 7, 7);
  SetLength(numeros, 7, 7);

// INITIALISER PLUSIEUR TABLEAU
  num :=1;
  if(num = 1) then 
    begin
    ressources[0] := [Aucune, Aucune, Aucune, Aucune, Aucune, Aucune, Aucune];
    ressources[1] := [Aucune, Aucune, Aucune, Humanites, Mathematiques, Chimie, Aucune];
    ressources[2] := [Aucune, Aucune, Mathematiques, Chimie, Informatique, Physique, Aucune];
    ressources[3] := [Aucune, Humanites, Informatique, Aucune, Humanites, Chimie, Aucune];
    ressources[4] := [Aucune, Physique, Mathematiques, Informatique, Physique, Aucune, Aucune];
    ressources[5] := [Aucune, Physique, Humanites, Mathematiques, Aucune, Aucune, Aucune];
    ressources[6] := [Aucune, Aucune, Aucune, Aucune, Aucune, Aucune, Aucune];
    numeros[0] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[1] := [-1, -1, -1, 6, 3, 8, -1];
    numeros[2] := [-1, -1, 2, 9, 11, 4, -1];
    numeros[3] := [-1, 5, 4, 0, 3, 11, -1];
    numeros[4] := [-1, 10, 5, 6, 12, -1, -1];
    numeros[5] := [-1, 8, 10, 9, -1, -1, -1];
    numeros[6] := [-1, -1, -1, -1, -1, -1, -1];
    end
  else 
    begin
    ressources[0] := [Physique, Physique, Physique, Physique, Physique, Physique, Physique];
    ressources[1] := [Physique, Physique, Physique, Physique, Physique, Physique, Physique];
    ressources[2] := [Physique, Physique, Physique, Physique, Physique, Physique, Physique];
    ressources[3] := [Physique, Physique, Physique, Physique, Physique, Physique, Physique];
    ressources[4] := [Physique, Physique, Physique, Physique, Physique, Physique, Physique];
    ressources[5] := [Physique, Physique, Physique, Physique, Physique, Physique, Physique];
    ressources[6] := [Physique, Physique, Physique, Physique, Physique, Physique, Physique];
    numeros[0] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[1] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[2] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[3] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[4] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[5] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[6] := [-1, -1, -1, -1, -1, -1, -1];
    end;


  for i := 0 to 6 do
    for j := 0 to 6 do
    begin
      grille[i, j].ressource := ressources[i][j];
      grille[i, j].numero := numeros[i][j];
    end;

  chagerGrille := grille;
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
  gagner : boolean;
begin
  // repeat
  tour(joueurs,plateau,affichage);

  verificationPointsVictoire(joueurs,gagner,gagnant);
  // until (gagener);
  affichageGagnant(joueurs[gagnant],affichage);

end;



end.