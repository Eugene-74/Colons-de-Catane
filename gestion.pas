unit gestion;

interface
uses Types,affichageUnit,SysUtils,achat,traitement,musique;

procedure initialisationPartie(var joueurs : TJoueurs;var  plateau : TPlateau;var affichage : TAffichage);
procedure partie(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);

// TODO enlever de l'interface
function chargementPlateau(num : Integer): TPlateau;


implementation

function chargerGrille(num : Integer): TGrille; forward;
function intialisationTutorat():TCartesTutorat;forward;
function nombreAleatoire(n : Integer): Integer;forward;
procedure distributionConnaissance(var joueurs : TJoueurs;var plateau : TPlateau;des : integer);forward;
procedure gestionDes(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);forward;
function aLesRessources(joueur : Tjoueur; ressources : TRessources):boolean;forward;
procedure enleverRessources( var joueur : Tjoueur; ressources : TRessources);forward;
procedure tour(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);forward;
procedure utiliserCarte1(var plateau : TPlateau; var affichage : TAffichage;joueur : Tjoueur);forward;
procedure utiliserCarte2(var plateau : TPlateau;var affichage : TAffichage;joueurs : Tjoueurs; joueur : Tjoueur);forward;
procedure utiliserCarte3(var plateau : TPlateau; joueur : Tjoueur);forward;
procedure utiliserCarte4(var plateau : TPlateau; joueur : Tjoueur);forward;
procedure utiliserCarte5(var joueurs : TJoueurs;joueur : Tjoueur);forward;
procedure utiliserCarteTutorat(var plateau : TPlateau;var affichage : TAffichage;var joueurs : TJoueurs; joueur : Tjoueur;nom : String);forward;


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
    case num of
    1 : begin
    ressources[0] := [Aucune, Aucune, Aucune, Rien, Rien, Rien, Rien];
    ressources[1] := [Aucune, Aucune, Rien, Humanites, Mathematiques, Chimie, Rien];
    ressources[2] := [Aucune, Rien, Mathematiques, Chimie, Informatique, Physique, Rien];
    ressources[3] := [Rien, Humanites, Informatique, Rien, Humanites, Chimie, Rien];
    ressources[4] := [Rien, Physique, Mathematiques, Informatique, Physique, Rien, Aucune];
    ressources[5] := [Rien, Physique, Humanites, Mathematiques, Rien, Aucune, Aucune];
    ressources[6] := [Rien, Rien, Rien, Rien, Aucune, Aucune, Aucune];
    numeros[0] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[1] := [-1, -1, -1, 5, 10, 8, -1];
    numeros[2] := [-1, -1, 2, 9, 11, 4, -1];
    numeros[3] := [-1, 6, 4, -1, 3, 11, -1];
    numeros[4] := [-1, 3, 5, 6, 12, -1, -1];
    numeros[5] := [-1, 8, 10, 9, -1, -1, -1];
    numeros[6] := [-1, -1, -1, -1, -1, -1, -1];
    end;
    2 : begin
    ressources[0] := [Aucune, Aucune, Aucune, Rien, Rien, Rien, Rien];
    ressources[1] := [Aucune, Aucune, Rien, Chimie, Physique, Chimie, Rien];
    ressources[2] := [Aucune, Rien, Mathematiques, Informatique, Humanites, Physique, Rien];
    ressources[3] := [Rien, Humanites, Chimie, Rien, Informatique, Mathematiques, Rien];
    ressources[4] := [Rien, Mathematiques, Informatique, Mathematiques, Humanites, Rien, Aucune];
    ressources[5] := [Rien, Humanites, Physique, Physique, Rien, Aucune, Aucune];
    ressources[6] := [Rien, Rien, Rien, Rien, Aucune, Aucune, Aucune];
    numeros[0] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[1] := [-1, -1, -1, 8, 4, 11, -1];
    numeros[2] := [-1, -1, 10, 11, 3, 12, -1];
    numeros[3] := [-1, 5, 9, -1, 6, 9, -1];
    numeros[4] := [-1, 2, 4, 5, 10, -1, -1];
    numeros[5] := [-1, 6, 3, 8, -1, -1, -1];
    numeros[6] := [-1, -1, -1, -1, -1, -1, -1];
    end;

  end;

  for i := 0 to 6 do
    for j := 0 to 6 do
    begin
      grille[i, j].ressource := ressources[i][j];
      grille[i, j].numero := numeros[i][j];
    end;

  chargerGrille := grille;
end;



function chargementPlateau(num : Integer): TPlateau;
var
  grille: TGrille;
  plat : TPlateau;
begin

  grille := chargerGrille(num);

  plat.Grille := grille;
  plat.Souillard.Position.x := 3;
  plat.Souillard.Position.y := 3;

  chargementPlateau := plat;
    
end;





function intialisationTutorat():TCartesTutorat;
begin

intialisationTutorat := CARTES_TUTORAT;
end;

procedure initialisationPartie(var joueurs : TJoueurs;var plateau : TPlateau;var affichage : TAffichage);
var i,j,num : integer;
  text : string;
  stop,unique : Boolean;
  res : TRessources;
  r : Tressource;
  cartesTutorat : TCartesTutorat;
begin
  
  for r := Aucune to Mathematiques do
    res[r] := 0;
  stop := false;
  SetLength(joueurs,0);
  i:=0;
  repeat
    write('rentrer le nom du joueur '+IntToStr(i+1)+' : (Entrer pour arreter)');
    readln(text);
    unique := True;

    // for j:=0 to  length(joueurs) -1 do 
    //   if(joueurs[j].Nom = text) then
    //     begin
    //     writeln('Le nom du joueur doit être unique');
    //     unique := False;
    //     end;

    // if(((text <> '\n') and (text <> '')) and unique) then
    if((text <>  '0')) then
      begin
      SetLength(joueurs,i+1);
      joueurs[i].Nom:= text;
      joueurs[i].Points :=0;
      joueurs[i].Ressources := res;
      joueurs[i].Id := i;
      
      i := i + 1;
      end
    else 
      begin
        if(i < 2)then
          writeln('Le nombre de joueur invalide ( + 2 joueurs minimum)')
        else 
          stop := true;
      end;
  until ((i>3) or (stop));


  initialisationAffichage(affichage);
  
  num :=nombreAleatoire(2);

  plateau := chargementPlateau(num);

  plateau.des1 := 1;
  plateau.des2 := 1;

  cartesTutorat := intialisationTutorat();
  plateau.cartesTutorat := cartesTutorat;

  affichageTour(plateau, joueurs, 0, affichage);
  

  for i:=1 to length(joueurs) do
    begin
    // TODO re mettre apres
    
    // placementEleve(plateau,affichage,joueurs[i-1]);
    // placementConnexion(plateau,affichage,joueurs[i-1]);
    end;

  for i:=length(joueurs) downto 1 do
    begin


    // placementEleve(plateau,affichage,joueurs[i-1]);
    // placementConnexion(plateau,affichage,joueurs[i-1]);
    end;



  affichageTour(plateau, joueurs, 0, affichage);
  

end;


function nombreAleatoire(n : Integer): Integer;
begin
  nombreAleatoire := Random(n) + 1;
  Randomize();
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
                  if((plateau.Souillard.Position.x <> coord.x) and (plateau.Souillard.Position.y <> coord.y)) then
                    joueurs[perso.IdJoueur].Ressources[res] := joueurs[perso.IdJoueur].Ressources[res] +1 ;
                end;
            end;
          end;
      end;

end;

procedure gestionDes(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);
var
  des,des1, des2: Integer;
begin
  des1 := nombreAleatoire(6);
  des2 := nombreAleatoire(6);
  des := des1 + des2;

  plateau.des1 := des1;
  plateau.des2 := des2;


  if(des = 7)then
    begin
      affichageDes(plateau.des1,plateau.des2,FCoord(50,500),affichage);

      deplacementSouillard(plateau,joueurs,affichage)
    end
  else 
    begin
      distributionConnaissance(joueurs,plateau,des);
    end;
end;

function aLesRessources(joueur : Tjoueur; ressources : TRessources):boolean;
var res : TRessource;
begin
  aLesRessources := True;
  for res in [Physique..Mathematiques] do 
    if(joueur.ressources[res] >= ressources[res]) then
      aLesRessources := False;
end;


procedure enleverRessources( var joueur : Tjoueur; ressources : TRessources);
var res : TRessource;
begin
  for res in [Physique..Mathematiques] do 
    joueur.ressources[res] := joueur.ressources[res] - ressources[res]
  
end;


procedure tour(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);
var valeurBouton,text : String;
  finTour : boolean;
  ressources1,ressources2 : TRessources;
  res : TRessource;
  i,id1,id2 : Integer;
  j,k : Integer;
begin
  for i := 0 to length(joueurs)-1 do
    begin
    affichageJoueurActuel(joueurs,i,affichage);

    gestionDes(joueurs,plateau,affichage);
      
    affichageTour(plateau,joueurs,i,affichage);


    finTour := False;
    repeat
      clicAction(affichage, valeurBouton);

      if(valeurBouton = 'achat_eleve')  then
        achatElements(joueurs[i], plateau, affichage,1)
      else if(valeurBouton = 'achat_connexion')  then
        achatElements(joueurs[i], plateau, affichage,2)
      else if(valeurBouton = 'changement_en_prof')  then
        begin
        achatElements(joueurs[i], plateau, affichage,3);
        end
      else if(valeurBouton = 'achat_carte_tutorat')  then
          achatElements(joueurs[i], plateau, affichage,4)
      else if(valeurBouton = 'echange')  then
        begin
        id1 := joueurs[i].id;
        id2 := joueurs[i+1].id;
        echangeRessources(joueurs,id1, id2 ,ressources1,ressources2,affichage);
        if(aLesRessources(joueurs[id1],ressources1) and aLesRessources(joueurs[id2],ressources2)) then
            begin
            enleverRessources(joueurs[id1],ressources1);
            enleverRessources(joueurs[id2],ressources1);

            affichageTour(plateau, joueurs, i, affichage);
            affichageInformation('l''echange entre ' + joueurs[id1].Nom +  ' et ' + joueurs[id2].Nom  + ' a ete valide',25,FCouleur(0,255,0,255),affichage);
            end
        else
            affichageTour(plateau, joueurs, i, affichage);
            affichageInformation('l''echange entre ' + joueurs[id1].Nom +  ' et ' + joueurs[id2].Nom  + ' est impossible',25,FCouleur(255,0,0,255),affichage);
        end
      else if(valeurBouton = 'demarrer_musique')  then
          demarrerMusique(affichage)
      else if(valeurBouton = 'arreter_musique')  then
          arreterMusique(affichage)
      else if(valeurBouton = 'fin_tour')  then
        finTour := True;

    until (finTour);

    // TODO enlever apres
    verificationMusique(affichage);


    end;


end;

procedure partie(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);
var gagnant : integer;
  gagner : boolean;
begin
  repeat
    tour(joueurs,plateau,affichage);
  gagner := false;
    verificationPointsVictoire(plateau,joueurs,gagner,gagnant,affichage);
  until (gagner);
  affichageGagnant(joueurs[gagnant],affichage);

end;


procedure utiliserCarte1(var plateau : TPlateau; var affichage : TAffichage;joueur : Tjoueur);
begin
  placementConnexion(plateau,affichage,joueur);
  placementConnexion(plateau,affichage,joueur);
end;

procedure utiliserCarte2(var plateau : TPlateau;var affichage : TAffichage;joueurs : Tjoueurs; joueur : Tjoueur);
begin
  affichageInformation('Deplacement du souillard par le joueur '+joueur.nom,25,FCouleur(0,0,0,255),affichage);
  deplacementSouillard(plateau,joueurs,affichage);
end;

procedure utiliserCarte3(var plateau : TPlateau; joueur : Tjoueur);
// var joueurAVoler : TJoueur;
begin
// VOLER UNE CONNAISSANCE

// choix du joueur

// choix du type de ressources a voler
// ON EST PAS SENCER CONNAITER LES CARTES DES AUTRES
// On s'en fou (Yann)
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
    if(joueur.CartesTutorat.carte1.utilisee < joueur.CartesTutorat.carte1.nbr) then
    begin
      utiliserCarte1(plateau,affichage,joueur);
      joueur.CartesTutorat.carte1.utilisee := joueur.CartesTutorat.carte1.utilisee + 1 
    end;
  end
  else if nom = plateau.cartesTutorat.carte2.nom then
  begin
    if(joueur.CartesTutorat.carte2.utilisee < joueur.CartesTutorat.carte2.nbr) then
    begin
      utiliserCarte2(plateau, affichage,joueurs, joueur);
      joueur.CartesTutorat.carte2.utilisee := joueur.CartesTutorat.carte2.utilisee + 1 
    end;
  end
  else if nom = plateau.cartesTutorat.carte3.nom then
  begin
    if(joueur.CartesTutorat.carte3.utilisee < joueur.CartesTutorat.carte3.nbr) then
    begin
      utiliserCarte3(plateau,joueur);
      joueur.CartesTutorat.carte3.utilisee := joueur.CartesTutorat.carte3.utilisee + 1 
    end;

  end
  else if nom = plateau.cartesTutorat.carte4.nom then
  begin
    if(joueur.CartesTutorat.carte4.utilisee < joueur.CartesTutorat.carte4.nbr) then
    begin
      utiliserCarte4(plateau,joueur);
      joueur.CartesTutorat.carte4.utilisee := joueur.CartesTutorat.carte4.utilisee + 1 
    end;

  end
  else if nom = plateau.cartesTutorat.carte5.nom then
  begin
    if(joueur.CartesTutorat.carte5.utilisee < joueur.CartesTutorat.carte5.nbr) then
    begin
      utiliserCarte5(joueurs,joueur);
      joueur.CartesTutorat.carte5.utilisee := joueur.CartesTutorat.carte5.utilisee + 1 
    end;

  end
  else
  begin
    writeln('Erreur : Carte inconnue');
  end;
end;

end.