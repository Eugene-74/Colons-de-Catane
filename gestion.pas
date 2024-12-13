unit gestion;

interface
uses Types,affichageUnit,SysUtils,achat,traitement,musique,TypInfo;

procedure initialisationPartie(var joueurs : TJoueurs;var  plateau : TPlateau;var affichage : TAffichage);
procedure partie(var affichage : TAffichage;var joueurs: TJoueurs;var plateau:TPlateau);

implementation
procedure enleverMoitieRessources(var joueur : Tjoueur);forward;
procedure gestionEchange(var affichage : TAffichage;var plateau:TPlateau;joueurs : TJoueurs;id : Integer);forward;
procedure gestionEchange4Pour1(var affichage : TAffichage;var plateau:TPlateau;joueurs : TJoueurs;id : Integer);forward;
procedure distributionConnaissance(var joueurs : TJoueurs;var plateau : TPlateau;des : integer);forward;
procedure gestionDes(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);forward;
procedure tour(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);forward;
procedure donnerRessources( var joueur : Tjoueur; ressources : TRessources);forward;

function intialisationTutorat():TCartesTutorat;forward;
function chargerGrille(num : Integer): TGrille; forward;
function chargementPlateau(num : Integer): TPlateau;forward;
function ressourcesVide(ressources : TRessources):boolean;forward;
function ressourcesEgales(ressources1 : TRessources;ressources2 : TRessources):boolean;forward;
function verificationPointsVictoire(plateau : TPlateau;var joueurs: TJoueurs;var affichage : TAffichage):TIntegerTab;forward;


function chargerGrille(num : Integer): TGrille;
var
  grille: TGrille;
  numeros: array of TIntegerTab;
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
  plateau : TPlateau;
begin
  plateau.Grille := chargerGrille(num);
  plateau.Souillard.Position.x := 3;
  plateau.Souillard.Position.y := 3;
  chargementPlateau := plateau;
end;

function intialisationTutorat():TCartesTutorat;
begin
  intialisationTutorat := CARTES_TUTORAT;
end;

procedure initialisationPartie(var joueurs : TJoueurs;var plateau : TPlateau;var affichage : TAffichage);
var i,j,num,count : integer;
  valide,unique : Boolean;
  res : TRessources;
  r : Tressource;
  cartesTutorat : TCartesTutorat;
  noms : TStringTab;
begin
  randomize;   

  for r := Aucune to Mathematiques do
    res[r] := 0;
  initialisationAffichage(affichage);
  initisationMusique(affichage);
  demarrerMusique(affichage);
  affichageRegles(affichage);

  affichageFond(affichage);
  
  setlength(noms,4);
  for i:=0 to 3 do
    noms[i] := '';
  repeat
    count := 0;
    recupererNomsJoueurs(noms,affichage);

    valide := True;
    unique := true;

    for i:=0 to length(noms) - 1 do
      if ((noms[i] <> '') and (noms[i] <> ' ') ) then
      begin
        for j:=i+1 to length(noms) - 1 do
          if (noms[i] = noms[j]) then
          begin
            unique := False;
            jouerSonValide(affichage,unique);
            affichageInformation('Il faut des noms différents.',25,COULEUR_TEXT_ROUGE,affichage);
            break;
          end;
        if(unique) then
          Inc(count)
        else
          break;
      end
      else
        break;
    if ((count < 2)) then
    begin
      valide := False;
      if(unique)then
      begin
        jouerSonValide(affichage,valide);
        affichageInformation('Il faut au moins 2 joueurs.',25,COULEUR_TEXT_ROUGE,affichage);
      end;
    end;
  until valide;

  setlength(noms,count);

  for i := 0 to length(noms) - 1 do
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

  num := random(2)+1;

  plateau := chargementPlateau(num);

  plateau.des1 := 1;
  plateau.des2 := 1;

  cartesTutorat := intialisationTutorat();
  plateau.cartesTutorat := cartesTutorat;
  
  affichageTour(plateau, joueurs, 0, affichage);



  for i:=0 to length(joueurs)-1 do
  begin
    affichageJoueurActuel(joueurs,i,affichage);
    placementEleve(plateau,affichage,joueurs[i]);
    attendre(32);
    placementConnexion(plateau,affichage,joueurs[i],true);
  end;

  for i:=length(joueurs)-1 downto 0 do
  begin
    affichageJoueurActuel(joueurs,i,affichage);
    placementEleve(plateau,affichage,joueurs[i]);
    attendre(32);
    placementConnexion(plateau,affichage,joueurs[i],true);
  end;
end;  

procedure distributionConnaissance(var joueurs : TJoueurs;var plateau : TPlateau;des : integer);
var personne : TPersonne;
  coo : Tcoord;
begin
  for personne in plateau.Personnes do
    for coo in personne.Position do
      if (plateau.Grille[coo.x,coo.y].Numero = des) then
        if(not ((plateau.Souillard.Position.x = coo.x) and (plateau.Souillard.Position.y = coo.y))) then
          joueurs[personne.IdJoueur].Ressources[plateau.Grille[coo.x,coo.y].ressource] := joueurs[personne.IdJoueur].Ressources[plateau.Grille[coo.x,coo.y].ressource] +1 ;
end;

procedure gestionDes(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);
var
  des,i,totalRessources: Integer;
  res : TRessource;
  tropDeRessources : Boolean;
begin
  plateau.des1 := random(6)+1;
  plateau.des2 := random(6)+1;
  des := plateau.des1 + plateau.des2;
  affichageDes(plateau.des1,plateau.des2,affichage);

  if(des = 7)then
  begin
    tropDeRessources := False;
    deplacementSouillard(plateau,joueurs,affichage);
    for i := 0 to Length(joueurs) - 1 do
    begin
      totalRessources := 0;
      for res := Physique to Mathematiques do
        totalRessources := totalRessources + joueurs[i].ressources[res];
      if totalRessources > 7 then
      begin
        tropDeRessources := True;
        enleverMoitieRessources(joueurs[i]);
      end;
    end;
    if(tropDeRessources) then
      affichageInformation('Tout les joueurs qui avaient plus de 7 ressources on perdu la moitié de leurs ressources à cause du souillard.',25,COULEUR_TEXT_ROUGE,affichage);
  end
  else
    distributionConnaissance(joueurs,plateau,des);

  for i:=0 to length(joueurs)-1 do
    affichageScoreAndClear(joueurs[i],affichage);
  miseAJourRenderer(affichage);
end;

procedure gestionEchange(var affichage : TAffichage;var plateau:TPlateau;joueurs : TJoueurs;id : Integer);
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
    affichageInformationAndRender('L''échange entre ' + joueurs[id1].Nom +  ' et ' + joueurs[id2].Nom  + ' est vide.',25,COULEUR_TEXT_ROUGE,affichage);
    jouerSonValide(affichage,false);
  end
  else if(ressourcesEgales(ressources1,ressources2))then
  begin
    affichageTour(plateau, joueurs, id, affichage);
    affichageInformationAndRender('L''échange entre ' + joueurs[id1].Nom +  ' et ' + joueurs[id2].Nom  + ' est inutile car il ne change rien.',25,COULEUR_TEXT_ROUGE,affichage);
    jouerSonValide(affichage,false);
  end
  else if(aLesRessources(joueurs[id1],ressources1) and aLesRessources(joueurs[id2],ressources2)) then
  begin
    enleverRessources(joueurs[id1],ressources1);
    enleverRessources(joueurs[id2],ressources2);

    donnerRessources(joueurs[id1],ressources2);
    donnerRessources(joueurs[id2],ressources1);

    affichageTour(plateau, joueurs, id, affichage);
    affichageInformationAndRender('L''échange entre ' + joueurs[id1].Nom +  ' et ' + joueurs[id2].Nom  + ' a été validé.',25,COULEUR_TEXT_VERT,affichage);
    jouerSonValide(affichage,true);
  end
  else
  begin
    affichageTour(plateau, joueurs, id, affichage);
    affichageInformationAndRender('L''échange entre ' + joueurs[id1].Nom +  ' et ' + joueurs[id2].Nom  + ' est impossible, un des 2 joueurs n''a pas assez de ressources.',25,COULEUR_TEXT_ROUGE,affichage);
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
    affichageCartesTutoratAndRender(joueurs[i],affichage);
    attendre(16);

    gestionDes(joueurs,plateau,affichage);

    finTour := False;
    repeat
      clicBouton(affichage,affichage.boutonsAction,valeurBouton);
    
      if(valeurBouton = 'achat_eleve')  then
        achatElements(joueurs[i], plateau, affichage,1)

      else if(valeurBouton = 'achat_connexion')  then
        achatElements(joueurs[i], plateau, affichage,2)

      else if(valeurBouton = 'changement_en_prof')  then
        achatElements(joueurs[i], plateau, affichage,3)

      else if(valeurBouton = 'achat_carte_tutorat')  then
        achatElements(joueurs[i], plateau, affichage,4)

      else if(valeurBouton = '4pour1')  then
        gestionEchange4Pour1(affichage,plateau,joueurs,i)

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
        utiliserCarteTutorat(affichage,plateau, joueurs,joueurs[i].id ,valeurBouton);
        
    until (finTour);
    attendre(16);
  end;
end;

procedure partie(var affichage:TAffichage;var joueurs: TJoueurs;var plateau:TPlateau);
var gagnants : TIntegerTab;
  id : Integer;
  text : String;
begin
  repeat
    tour(joueurs,plateau,affichage);
    gagnants := verificationPointsVictoire(plateau,joueurs,affichage);
  until (length(gagnants)>=1);

  text := '';
  for id in gagnants do
    if(id = gagnants[length(gagnants)-1])then
      text := text + joueurs[id].Nom +' '
    else
      text := text + joueurs[id].Nom +' et ';
  if (length(gagnants) > 1 )then
    text := text + 'viennent de gagner la partie en dépassant les 10 points au même tour'
  else if (length(gagnants) = 1 )then
    text := text + 'viens de gagner la partie en dépassant les 10 points';
  
  jouerSonFinDePartie(affichage);

  affichageGagnant(affichage,text);
  
  suppresionAffichage(affichage);
end;

procedure donnerRessources( var joueur : Tjoueur; ressources : TRessources);
var res : TRessource;
begin
  for res in [Physique..Mathematiques] do
    joueur.ressources[res] := joueur.ressources[res] + ressources[res]
end;

procedure enleverMoitieRessources(var joueur : Tjoueur);
var res: TRessource;
  totalRessources, ressourcesAEnlever, i,j,min,max: Integer;
begin
  totalRessources := 0;
  for res in [Physique..Mathematiques] do
    totalRessources := totalRessources + joueur.ressources[res];

  ressourcesAEnlever := totalRessources div 2;

  for j := 0 to ressourcesAEnlever - 1 do
  begin
    i := Random(totalRessources);
    min := 0;
    max := 0;
    for res := Physique to Mathematiques do
    begin
      max := max + joueur.Ressources[res];
      if (i >= min) and (i < max) then
      begin
        totalRessources := totalRessources - 1;
        joueur.Ressources[res] := joueur.Ressources[res] - 1;
        break;
      end;
      min := min + joueur.Ressources[res];
    end;
  end;
end;

procedure gestionEchange4Pour1(var affichage : TAffichage;var plateau:TPlateau;joueurs : TJoueurs;id : Integer);
var ressource1,ressource2 : TRessource;
begin
  selectionRessource(affichage,ressource2,'Sélectionnez la ressource à donner (4)',joueurs);
  selectionRessource(affichage,ressource1,'Sélectionnez la ressource à recevoir (1)',joueurs);
  if(ressource1 <> ressource2) then
    if joueurs[id].Ressources[ressource2] >= 4 then
    begin
      joueurs[id].Ressources[ressource2] := joueurs[id].Ressources[ressource2] - 4;
      joueurs[id].Ressources[ressource1] := joueurs[id].Ressources[ressource1] + 1;
      jouerSonValide(affichage, true);
      affichageTour(plateau, joueurs, id, affichage);
      attendre(50);
      affichageInformationAndRender('Échange 4 pour 1 réussi.', 25, COULEUR_TEXT_VERT, affichage);
    end
    else
    begin
      jouerSonValide(affichage, false);
      affichageTour(plateau, joueurs, id, affichage);
      attendre(50);
      affichageInformationAndRender('Échange 4 pour 1 impossible.', 25, COULEUR_TEXT_ROUGE, affichage);
    end
  else
  begin
    jouerSonValide(affichage, false);
    affichageTour(plateau, joueurs, id, affichage);
    attendre(50);
    affichageInformationAndRender('Échange 4 pour 1 inutile.', 25, COULEUR_TEXT_ROUGE, affichage);
  end;

end;

function ressourcesVide(ressources : TRessources):boolean;
var res : TRessource;
begin
  ressourcesVide := True;
  for res in [Physique..Mathematiques] do
    if( ressources[res]>=1) then
      exit(False);
end;

function ressourcesEgales(ressources1 : TRessources;ressources2 : TRessources):boolean;
var res : TRessource;
begin
  ressourcesEgales := True;
  for res in [Physique..Mathematiques] do
    if( ressources1[res]<> ressources2[res]) then
      exit(False);
end;

function verificationPointsVictoire(plateau : TPlateau;var joueurs: TJoueurs;var affichage : TAffichage):TIntegerTab;
var plusGrandeConnexion,plusDeplacementSouillard : Boolean;
  id,i : Integer;
  points,longueurRoutes : TIntegerTab;
begin
  verificationPointsVictoire := nil;

  SetLength(points,Length(joueurs));
  SetLength(longueurRoutes,Length(joueurs));
  
  for i := 0 to length(joueurs)-1 do
    longueurRoutes[i] := compterConnexionSuite(plateau,joueurs[i]);

  for id := 0 to length(joueurs)-1 do
  begin
    points[id] := joueurs[id].points;
    plusGrandeConnexion := True;
    plusDeplacementSouillard :=True;

    joueurs[id].PlusGrandeConnexion := False;
    if (longueurRoutes[id] >= 5) then
    begin
      for i := 0 to length(joueurs) -1 do
        if(id <> i )then
          if(longueurRoutes[id] < longueurRoutes[i]) then
            plusGrandeConnexion := False;
      if plusGrandeConnexion then
        begin
        joueurs[id].PlusGrandeConnexion := True;
        points[id] := points[id] + 2;
        end;
    end;

    joueurs[id].PlusGrandeNombreDeWordReference := False;
    if(joueurs[id].CartesTutorat[1].utilisee >= 3) then
    begin
      for i := 0 to length(joueurs) -1 do
        if(joueurs[id].CartesTutorat[1].utilisee < joueurs[i].CartesTutorat[1].utilisee) then
          plusDeplacementSouillard := False;
        if(plusDeplacementSouillard) then
        begin
          points[id] := points[id] + 2;
          joueurs[id].PlusGrandeNombreDeWordReference := True;
        end;
    end;
    if points[id] >= 10 then
    begin
      setlength(verificationPointsVictoire,length(verificationPointsVictoire)+1);
      verificationPointsVictoire[length(verificationPointsVictoire)-1] := id;
    end;
    affichageScoreAndClear(joueurs[id],affichage);
  end;
end;
end.