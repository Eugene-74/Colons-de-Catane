unit gestion;

interface
uses Types,affichageUnit,SysUtils,achat;
function chargementPlateau(): TPlateau;
procedure initialisationPartie(var joueurs : TJoueurs;var  plateau : TPlateau;var affichage : TAffichage);
procedure partie(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);




implementation

function chargerGrille(num : Integer): TGrille;
var 
  grille: TGrille;
  numeros: array of array of Integer;
  ressources: array of array of TRessource;
  i, j: Integer;
begin
// Tableau static pose des problème
  SetLength(grille, 7, 7);

  SetLength(ressources, 7, 7);
  SetLength(numeros, 7, 7);

  if(num = 1) then 
    begin

    ressources[0] := [Aucune, Aucune, Aucune, Aucune, Aucune, Aucune, Aucune];
    ressources[1] := [Aucune, Aucune, Aucune, Humanites, Mathematiques, Chimie, Aucune];
    ressources[2] := [Aucune, Aucune, Mathematiques, Chimie, Informatique, Physique, Aucune];
    ressources[3] := [Aucune, Humanites, Informatique, Rien, Humanites, Chimie, Aucune];
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

  chargerGrille := grille;
end;



function chargementPlateau(): TPlateau;
var
  grille: TGrille;
  plat : TPlateau;
  num : Integer;
begin
  num :=1;

  grille := chargerGrille(num);
  if(num = 1) then
  begin
    plat.Grille := grille;
    plat.Souillard.Position.x := 3;
    plat.Souillard.Position.y := 3;
  end;

  chargementPlateau := plat;
    
end;

function tirerCarteTutorat(var cartesTutorat : TCartesTutorat):TCarteTutorat;
var carteTutorat : TCarteTutorat;
  i,nbrTotal: Integer;
begin
  carteTutorat.nom := '';
  carteTutorat.description := '';
  carteTutorat.nbr := 0;
  Randomize();

  // TODO penser à verif que il en reste avant d'accepter l'achat 
  nbrTotal := cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr + cartesTutorat.carte3.nbr + cartesTutorat.carte4.nbr + cartesTutorat.carte5.nbr;

  i := Random(nbrTotal) + 1;
  if (i >= 1) and (i <= cartesTutorat.carte1.nbr) then
    begin
    carteTutorat.nom := cartesTutorat.carte1.nom;
    carteTutorat.description := cartesTutorat.carte1.description;
    carteTutorat.nbr := 1;

    cartesTutorat.carte1.nbr := cartesTutorat.carte1.nbr - 1; 
    end
  else if (i > cartesTutorat.carte1.nbr) and (i <= cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr) then
    begin
    carteTutorat.nom := cartesTutorat.carte2.nom;
    carteTutorat.description := cartesTutorat.carte2.description;
    carteTutorat.nbr := 1;

    cartesTutorat.carte2.nbr := cartesTutorat.carte2.nbr - 1; 
    end
  else if (i > cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr) and (i <= cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr + cartesTutorat.carte3.nbr) then
    begin
    carteTutorat.nom := cartesTutorat.carte3.nom;
    carteTutorat.description := cartesTutorat.carte3.description;
    carteTutorat.nbr := 1;

    cartesTutorat.carte3.nbr := cartesTutorat.carte3.nbr - 1;
    end
  else if (i > cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr + cartesTutorat.carte3.nbr) and (i <= cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr + cartesTutorat.carte3.nbr + cartesTutorat.carte4.nbr) then
    begin
    carteTutorat.nom := cartesTutorat.carte4.nom;
    carteTutorat.description := cartesTutorat.carte4.description;
    carteTutorat.nbr := 1;

    cartesTutorat.carte4.nbr := cartesTutorat.carte4.nbr - 1;
    end
  else
    begin
    carteTutorat.nom := cartesTutorat.carte5.nom;
    carteTutorat.description := cartesTutorat.carte5.description;
    carteTutorat.nbr := 1;

    cartesTutorat.carte5.nbr := cartesTutorat.carte5.nbr - 1;
    end;



  tirerCarteTutorat := carteTutorat;
end;



function intialisationTutorat():TCartesTutorat;
var carteTutorat : TCarteTutorat;
  i : Integer;
begin

intialisationTutorat := CARTES_TUTORAT;
end;

procedure 

initialisationPartie(var joueurs : TJoueurs;var plateau : TPlateau;var affichage : TAffichage);
var i : integer;
  coord : Tcoord;
  text : string;
  stop : Boolean;
  res : TRessources;
  r : Tressource;
  cartesTutorat : TCartesTutorat;
begin

  cartesTutorat := intialisationTutorat();

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
      joueurs[i-1].Id := i;
      
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


  SetLength(plateau.Connexions, 1);
  SetLength(plateau.Connexions[0].Position, 2);

  initialisationAffichage(affichage);
  plateau := chargementPlateau();
  affichageTour(plateau, affichage);
  
  writeln('start');
  for i:=1 to length(joueurs) do
    begin
    text := 'Le joueur '+IntToStr(i)+' joue et place une connexion puis un élève';
    affichageTexte(text,0,coord,affichage);
    placementConnexion(plateau,affichage,joueurs[i-1]);
    affichageTour(plateau, affichage);

    placementEleve(plateau,affichage,joueurs[i-1]);
    affichageTour(plateau, affichage);

    end;
  writeln('start 1');

  for i:=length(joueurs) downto 1 do
    begin
    text := 'Le joueur '+IntToStr(i)+' rejoue et replace une connexion puis un élève';
    affichageTexte(text,0,coord,affichage);
    placementConnexion(plateau,affichage,joueurs[i-1]);
    affichageTour(plateau, affichage);

    placementEleve(plateau,affichage,joueurs[i-1]);
    affichageTour(plateau, affichage);

    end;
    writeln('start 2');

end;


function nombreAleatoire(n : Integer): Integer;
begin
  Randomize;
  nombreAleatoire := Random(n) + 1;
end;

    
procedure deplacementSouillard(var plateau : TPlateau; var affichage : TAffichage);
begin
  writeln('deplacementSouillard activer');
end;


procedure distributionConnaissance(var joueurs : TJoueurs;var plateau : TPlateau;des : integer);
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

procedure gestionDes(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);
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

procedure tour(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);
var j : Tjoueur;
    coord : Tcoord;
  
begin
  for j in joueurs do 
    begin


    // TODO choisir l'ordre grace à des clicks
    // achatElements(j,plateau,affichage);
    // gestionDes(joueurs,plateau,affichage);
    end;


end;

procedure partie(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);
var gagnant : integer;
  gagner : boolean;
begin
  // repeat
    tour(joueurs,plateau,affichage);

    verificationPointsVictoire(plateau,joueurs,gagner,gagnant);
  // until (gagner);
  // affichageGagnant(joueurs[gagnant],affichage);

end;


procedure utiliserCarte1(var plateau : TPlateau; var affichage : TAffichage;joueur : Tjoueur);
begin
placementConnexion(plateau,affichage,joueur);
placementConnexion(plateau,affichage,joueur);

end;

procedure utiliserCarte2(var plateau : TPlateau;var affichage : TAffichage;joueur : Tjoueur);
begin
affichageTexte('Deplacement du souillard par le joueur '+joueur.nom,0,plateau.Souillard.Position,affichage);
deplacementSouillard(plateau, affichage);

end;

procedure utiliserCarte3(var plateau : TPlateau; joueur : Tjoueur);
var joueurAVoler : TJoueur;
begin
// VOLER UNE CONNAISSANCE

// choix du joueur

// choix du type de ressources a voler
// ON EST PAS SENCER CONNAITER LES CARTES DES AUTRES
end;

procedure utiliserCarte4(var plateau : TPlateau; joueur : Tjoueur);
begin
// CHOISIR 2 CONNAISSANCE



end;

procedure utiliserCarte5(var joueurs : TJoueurs;joueur : Tjoueur);
var j : Tjoueur;
begin
for j in joueurs do
  if(j.Id = joueur.Id) then
    joueur.Points := joueur.Points + 1;


end;

procedure utiliserCarteTutorat(var plateau : TPlateau;var affichage : TAffichage;var joueurs : TJoueurs; joueur : Tjoueur;nom : String);
begin
  if nom = plateau.cartesTutorat.carte1.nom then
  begin
    writeln('Utilisation de la carte ', plateau.cartesTutorat.carte1.nom);
    utiliserCarte1(plateau,affichage,joueur);

  end
  else if nom = plateau.cartesTutorat.carte2.nom then
  begin
    writeln('Utilisation de la carte ', plateau.cartesTutorat.carte2.nom);
    utiliserCarte2(plateau, affichage, joueur);

  end
  else if nom = plateau.cartesTutorat.carte3.nom then
  begin
    writeln('Utilisation de la carte ', plateau.cartesTutorat.carte3.nom);
    utiliserCarte3(plateau,joueur);

  end
  else if nom = plateau.cartesTutorat.carte4.nom then
  begin
    writeln('Utilisation de la carte ', plateau.cartesTutorat.carte4.nom);
    utiliserCarte4(plateau,joueur);

  end
  else if nom = plateau.cartesTutorat.carte5.nom then
  begin
    writeln('Utilisation de la carte ', plateau.cartesTutorat.carte5.nom);
    utiliserCarte5(joueurs,joueur);

  end
  else
  begin
    writeln('Carte inconnue');
  end;
end;

end.