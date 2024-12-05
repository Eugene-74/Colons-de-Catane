unit gestion;

interface
uses Types,affichageUnit,SysUtils,achat,traitement,musique,TypInfo;

procedure initialisationPartie(var joueurs : TJoueurs;var  plateau : TPlateau;var affichage : TAffichage);
procedure partie(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);

implementation
procedure gestionEchange(affichage : TAffichage;var plateau:TPlateau;joueurs : TJoueurs;id : Integer);forward;

function chargementPlateau(num : Integer): TPlateau;forward;
function chargerGrille(num : Integer): TGrille; forward;
function intialisationTutorat():TCartesTutorat;forward;
function nombreAleatoire(n : Integer): Integer;forward;
procedure distributionConnaissance(var joueurs : TJoueurs;var plateau : TPlateau;des : integer);forward;
procedure gestionDes(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);forward;
function ressourcesVide(ressources : TRessources):boolean;forward;
function ressourcesEguale(ressources1 : TRessources;ressources2 : TRessources):boolean;forward;
procedure tour(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);forward;

procedure utiliserCarteTutorat(var plateau : TPlateau;var affichage : TAffichage;var joueurs : TJoueurs;id : Integer;nom : String);forward;

procedure utiliserCarte1(var plateau : TPlateau; var affichage : TAffichage;joueurs : Tjoueurs; id : Integer);forward;
procedure utiliserCarte2(var plateau : TPlateau;var affichage : TAffichage;joueurs : Tjoueurs; id : Integer);forward;
procedure utiliserCarte3(var plateau : TPlateau; joueurs : Tjoueurs; id : Integer);forward;
procedure utiliserCarte4(var affichage : TAffichage;var plateau : TPlateau;var joueurs : Tjoueurs; id : Integer);forward;
procedure utiliserCarte5(var joueurs : TJoueurs;id :Integer);forward;

procedure donnerRessources( var joueur : Tjoueur; ressources : TRessources);forward;


function chargerGrille(num : Integer): TGrille;
var
  grille: TGrille;
  numeros: array of array of Integer;
  ressources: array of array of TRessource;
  i, j: Integer;
begin
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
var i,j,num,count : integer;
  valide,unique,nonVide : Boolean;
  res : TRessources;
  r : Tressource;
  cartesTutorat : TCartesTutorat;
  noms : TStringTab;
begin
  
  for r := Aucune to Mathematiques do
    res[r] := 0;
  
  initialisationAffichage(affichage);
  initisationMusique(affichage);


  setlength(noms,4);
  for i:=0 to 3 do
    noms[i] := '';
  valide := True;
  unique := true;
  nonVide := true;
  repeat
    count := 0;
    recupererNomsJoueurs(noms,affichage,valide,unique,nonVide);

    valide := True;
    unique := true;
    nonVide := true;

    for i:=0 to length(noms) - 1 do
    begin
      if ((noms[i] <> '') and (noms[i] <> ' ') ) then
        begin
        for j:=i+1 to length(noms) - 1 do
          if (noms[i] = noms[j]) then
            begin
            unique := False;
            end;
        if(unique) then
          Inc(count)
        end
      else
        begin
        nonVide := False;
        end;
    end;
    if (count < 2) then
      begin
      valide := False;
        
      end;
  until valide;
  jouerSonValide(affichage,true);

  setlength(noms,count);

  for i:=0 to length(noms) - 1 do
  begin
    SetLength(joueurs,i+1);
    joueurs[i].Nom:= noms[i];
    joueurs[i].Points :=0;
    joueurs[i].Ressources := res;
    joueurs[i].Id := i;
    joueurs[i].cartesTutorat := CARTES_TUTORAT;
    for j:=0 to length(plateau.cartesTutorat)-1 do
    begin
      joueurs[i].cartesTutorat[j].nbr := 0;
    end;
  end;

  Randomize;
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
    // TODO re mettre apres

    // placementEleve(plateau,affichage,joueurs[i-1]);
    // placementConnexion(plateau,affichage,joueurs[i-1]);
    end;

  // mise a jour de l'affichage
  // affichageTour(plateau, joueurs, 0, affichage);
  

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
  des,des1,des2,i: Integer;
begin
  des1 := nombreAleatoire(6);
  des2 := nombreAleatoire(6);
  des := des1 + des2;

  plateau.des1 := des1;
  plateau.des2 := des2;

  affichageDes(plateau.des1,plateau.des2,affichage);

  if(des = 7)then
    begin
      deplacementSouillard(plateau,joueurs,affichage)
    end
  else
    begin
      distributionConnaissance(joueurs,plateau,des);
      for i:=0 to length(joueurs)-1 do
        begin
        affichageScoreAndClear(joueurs[i],affichage);
        end;
    end;
  miseAJourRenderer(affichage);
end;

function ressourcesVide(ressources : TRessources):boolean;
var res : TRessource;
begin
  ressourcesVide := True;
  for res in [Physique..Mathematiques] do
    if( ressources[res]>=1) then
      ressourcesVide := False;
end;

function ressourcesEguale(ressources1 : TRessources;ressources2 : TRessources):boolean;
var res : TRessource;
begin
  ressourcesEguale := True;
  for res in [Physique..Mathematiques] do
    if( ressources1[res]<> ressources2[res]) then
      ressourcesEguale := False;
end;

procedure gestionEchange(affichage : TAffichage;var plateau:TPlateau;joueurs : TJoueurs;id : Integer);
var id1,id2 : Integer;
  ressources1,ressources2 : TRessources;

begin
id1 := joueurs[id].id;
if(id1< length(joueurs)-1) then
  id2 := id1 + 1
else
  id2 := 0;
echangeRessources(joueurs,id1, id2 ,ressources1,ressources2,affichage);

if(ressourcesVide(ressources1) and ressourcesVide(ressources2))then
  begin
  affichageTour(plateau, joueurs, id, affichage);
  affichageInformation('l''echange entre ' + joueurs[id1].Nom +  ' et ' + joueurs[id2].Nom  + ' est vide',25,FCouleur(255,0,0,255),affichage);
  jouerSonValide(affichage,false);
  end
else if(ressourcesEguale(ressources1,ressources2))then
  begin
  affichageTour(plateau, joueurs, id, affichage);
  affichageInformation('l''echange entre ' + joueurs[id1].Nom +  ' et ' + joueurs[id2].Nom  + ' est inutile car il ne change rien',25,FCouleur(255,0,0,255),affichage);
  jouerSonValide(affichage,false);
  end
else if(aLesRessources(joueurs[id1],ressources1) and aLesRessources(joueurs[id2],ressources2)) then
  begin
    enleverRessources(joueurs[id1],ressources1);
    enleverRessources(joueurs[id2],ressources2);

    donnerRessources(joueurs[id1],ressources2);
    donnerRessources(joueurs[id2],ressources1);

    affichageTour(plateau, joueurs, id, affichage);
    affichageInformation('l''echange entre ' + joueurs[id1].Nom +  ' et ' + joueurs[id2].Nom  + ' a ete valide',25,FCouleur(0,255,0,255),affichage);
    jouerSonValide(affichage,true);
  end
else
  begin
    affichageTour(plateau, joueurs, id, affichage);
    affichageInformation('l''echange entre ' + joueurs[id1].Nom +  ' et ' + joueurs[id2].Nom  + ' est impossible un des 2 joueurs n''a pas les ressources',25,FCouleur(255,0,0,255),affichage);
    jouerSonValide(affichage,false);

  end;
end;

procedure tour(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);
var valeurBouton : String;
  finTour : boolean;
  i : Integer;
begin
  for i := 0 to length(joueurs)-1 do
    begin
    affichageJoueurActuel(joueurs,i,affichage);
    
    gestionDes(joueurs,plateau,affichage);

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
        begin
        achatElements(joueurs[i], plateau, affichage,4);
        end
      else if(valeurBouton = 'echange')  then
        gestionEchange(affichage,plateau,joueurs,i)
      
      else if(valeurBouton = 'demarrer_musique')  then
          demarrerMusique(affichage)
      else if(valeurBouton = 'arreter_musique')  then
          arreterMusique(affichage)
      else if(valeurBouton = 'fin_tour')  then
        begin
        finTour := True;
        jouerSonFinDeTour(affichage);
        end
      else
        begin
        utiliserCarteTutorat(plateau,affichage, joueurs,joueurs[i].id ,valeurBouton);
        end;

    until (finTour);
    affichageJoueurActuel(joueurs,i,affichage);
    affichageCartesTutoratAndRender(joueurs[i],affichage);

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


procedure utiliserCarte1(var plateau : TPlateau; var affichage : TAffichage;joueurs : Tjoueurs;id : Integer);
begin
  placementConnexion(plateau,affichage,joueurs[id]);
  placementConnexion(plateau,affichage,joueurs[id]);
end;

procedure utiliserCarte2(var plateau : TPlateau;var affichage : TAffichage;joueurs : Tjoueurs; id : Integer);
begin
  affichageInformation('Deplacement du souillard par le joueur '+joueurs[id].nom,25,FCouleur(0,0,0,255),affichage);
  deplacementSouillard(plateau,joueurs,affichage);

  affichageSouillardAndRender(plateau,affichage);
  // affichageTour(plateau, joueurs, Id, affichage);
end;

procedure utiliserCarte3(var plateau : TPlateau; joueurs : Tjoueurs;id : Integer);
// var joueurAVoler : TJoueur;
begin
// VOLER UNE CONNAISSANCE

// choix du joueur

// choix du type de ressources a voler
// ON EST PAS SENCER CONNAITER LES CARTES DES AUTRES
// On s'en fou (Yann)
end;

procedure utiliserCarte4(var affichage : TAffichage;var plateau : TPlateau; var joueurs : Tjoueurs;id : Integer);
var ressource : TRessource;
begin
// CHOISIR 2 CONNAISSANCE

selectionRessource(affichage,ressource);
joueurs[id].ressources[ressource] := joueurs[id].ressources[ressource] + 2;
affichageInformation(joueurs[id].Nom +  'viens de gagner 2 : ' +GetEnumName(TypeInfo(TRessource), Ord(ressource)),25,FCouleur(0,255,0,255),affichage);

affichageTour(plateau, joueurs, Id, affichage);
end;

procedure utiliserCarte5(var joueurs : TJoueurs;id :Integer);
begin
  joueurs[id].Points := joueurs[id].Points + 1;
end;

procedure utiliserCarteTutorat(var plateau : TPlateau;var affichage : TAffichage;var joueurs : TJoueurs;id : Integer;nom : String);
var i : Integer;
begin

i := -1;
for i := 0 to High(plateau.cartesTutorat) do
  begin
  if (nom = plateau.cartesTutorat[i].nom) then
    break;
  end;

if (i <> -1) and (joueurs[id].CartesTutorat[i].utilisee < joueurs[id].CartesTutorat[i].nbr) then
  begin
  jouerSonValide(affichage, true);
  case i of
    0: utiliserCarte1(plateau, affichage, joueurs, id);
    1: utiliserCarte2(plateau, affichage, joueurs, id);
    2: utiliserCarte3(plateau, joueurs, id);
    3: utiliserCarte4(affichage, plateau, joueurs, id);
    4: utiliserCarte5(joueurs, id);
    end;
  joueurs[id].CartesTutorat[i].utilisee := joueurs[id].CartesTutorat[i].utilisee + 1;

  affichageCartesTutorat(joueurs[id],affichage);
  affichageScoreAndClear(joueurs[id],affichage);
  miseAJourRenderer(affichage);
  end
else
  begin
  jouerSonValide(affichage,false);
  affichageInformation('Vous avez deja utilise toutes vos cartes de ce type',25,FCouleur(255,0,0,255),affichage);
  end;
end;

procedure donnerRessources( var joueur : Tjoueur; ressources : TRessources);
var res : TRessource;
begin
  for res in [Physique..Mathematiques] do
    joueur.ressources[res] := joueur.ressources[res] + ressources[res]
end;

end.


