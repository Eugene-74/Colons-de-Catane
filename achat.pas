unit achat;

interface

uses Types, affichageUnit,traitement,sysutils,musique;

function CoordsEgales(coords1: TCoords; coords2: TCoords): Boolean;
procedure deplacementSouillard(var plateau : TPlateau; var joueurs : TJoueurs ;var affichage : TAffichage);
function aLesRessources(joueur : Tjoueur; ressources : TRessources):boolean;
procedure enleverRessources( var joueur : Tjoueur; ressources : TRessources);
procedure placementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur;debut : Boolean);
procedure PlacementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur);
procedure achatElements(var joueur: TJoueur; var plateau: TPlateau; var affichage: TAffichage; choix : Integer);
function verificationPointsVictoire(plateau : TPlateau;var joueurs: TJoueurs;var affichage : TAffichage):TIntegerTab;
procedure ChangementProfesseur(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
function resteEmplacementConnexion(var affichage : TAffichage;plateau: TPlateau; joueur: TJoueur): Boolean;

procedure placeFauxConnexionAutourJoueur(affichage : TAffichage;plateau : TPlateau; id : Integer);
function conterNombrePersonnes(personnes: TPersonnes; estEleve: Boolean; joueur: TJoueur): Integer;

implementation
procedure placeFauxEleve(affichage : TAffichage;coords : Tcoords;id : Integer);forward;
procedure placeFauxConnexion(affichage : TAffichage;coord1 : Tcoord;coord2 : Tcoord; id : Integer);forward;
procedure placeFauxProfesseur(affichage : TAffichage;coords : Tcoords; id : Integer);forward;
function compterConnexionAutour(var connexionDejaVisite : Tconnexions;connexion : TConnexion;plateau: TPlateau; joueur: TJoueur): Integer;forward;
function nombreConnexionJoueur(plateau: TPlateau; joueur: TJoueur): Integer;forward;


function connexionExisteDeja(plateau: TPlateau; coord1: TCoord; coord2: TCoord): Boolean;forward;

// procedure trouver3EmeHexagone(plateau : TPlateau;coords1: TCoords; coords2: TCoords;connexion : Tconnexion);forward;
procedure trouver3EmeHexagone(plateau : TPlateau;coords1,coords2,coords: TCoords);forward;

function clicConnexion(var affichage: TAffichage; plateau: TPlateau): TCoords;forward;

function connexionValide(coords: TCoords; plateau: TPlateau; joueur: TJoueur;var affichage : TAffichage): Boolean;forward;
function ClicPersonne(var affichage: TAffichage; plateau: TPlateau; estEleve: Boolean): TCoords;forward;
function professeurValide(var affichage: TAffichage; plateau: TPlateau; joueurActuel: TJoueur; HexagonesCoords: TCoords; var ProfesseurCoords: TCoords; var indexEleve: Integer): Boolean;forward;
function PersonneValide(plateau: TPlateau; HexagonesCoords: TCoords; estEleve: Boolean; joueurActuel: TJoueur;var affichage : TAffichage): Boolean;forward;
function VerifierAdjacencePersonnes(HexagonesCoords: TCoords; plateau: TPlateau): Boolean;forward;
function enContactEleveConnexion( plateau: TPlateau; coords: TCoords; var joueur: TJoueur): Boolean;forward;
function enContactConnexionEleve( plateau: TPlateau; coords: TCoords; var joueur: TJoueur): Boolean;forward;

function aucuneConnexionAdjacente(coords: TCoords;  plateau: TPlateau; joueur: TJoueur; var affichage : TAffichage): Boolean;forward;
function enContactAutreEleveConnexion(plateau:TPlateau ;coords: TCoords; var joueur:TJoueur; var affichage : TAffichage):Boolean;forward;
function enContactConnexionConnexion(coords1: TCoords; coords2: TCoords): Boolean;forward;
function resteEleve(var affichage : TAffichage;plateau:TPlateau; joueur:Tjoueur): Boolean;forward;
function resteEmplacementEleve(var affichage : TAffichage;plateau: TPlateau; joueur: TJoueur): Boolean;forward;

function enContactEleveConnexions(plateau: TPlateau; eleve: TPersonne; var joueur: TJoueur): TCoords;forward;
function compterConnexionSuite(plateau: TPlateau; joueur: TJoueur): Integer;forward;
function adjacence3Connexions(coords: TCoords; plateau: TPlateau; joueur: TJoueur; var affichage : TAffichage): Boolean;forward;
function encontactAutreconnexionEleve(plateau: TPlateau;Eleve:Tcoords; var joueur:Tjoueur): Boolean;forward;
procedure tirerCarteTutorat(var cartesTutorat : TCartesTutorat;var  joueur : Tjoueur);forward;
function coordsDansTableau(connexion: TConnexion; tableau: array of TConnexion): Boolean;forward;


procedure placeFauxConnexionAutourJoueur(affichage : TAffichage;plateau : TPlateau; id : Integer);
var coords : Tcoords;
begin
  coords := plateau.Personnes[length(plateau.personnes)-1].Position;
  placeFauxConnexion(affichage,coords[0],coords[1],id);
  placeFauxConnexion(affichage,coords[1],coords[2],id);
  placeFauxConnexion(affichage,coords[0],coords[2],id);
  affichagePersonne(plateau.Personnes[length(plateau.personnes)-1],affichage);
  miseAJourRenderer(affichage);
end;


procedure tirerCarteTutorat(var cartesTutorat : TCartesTutorat;var  joueur : Tjoueur);
var  i,j,nbrTotal,min,max: Integer;
begin
  nbrTotal :=0;
  for i := 0 to 4 do
    nbrTotal :=nbrTotal  + cartesTutorat[i].nbr;
    
  if nbrTotal = 0 then
  begin
    Exit;
  end;

  i := Random(nbrTotal)+1;

  min := 1;
  max := 0;

  for j := 0 to 4 do
    begin
    max := max + cartesTutorat[j].nbr;
    if(i>=min) and ((i <= max))then
      begin
      joueur.cartesTutorat[j].nbr := joueur.cartesTutorat[j].nbr +1;
      cartesTutorat[j].nbr := cartesTutorat[j].nbr - 1;
      exit;
      end;
    min := min + cartesTutorat[j].nbr;

    end;

end;




procedure achatElements(var joueur: TJoueur; var plateau: TPlateau; var affichage: TAffichage; choix : Integer);
begin
  case choix of
   // ELEVE
    1:
      if(aLesRessources(joueur,COUT_ELEVE)) then
        if (conterNombrePersonnes(plateau.Personnes,true,joueur) < 5)  then
          if(resteEmplacementEleve(affichage,plateau,joueur))then
          begin
          enleverRessources(joueur,COUT_ELEVE);
          PlacementEleve(plateau, affichage, joueur);
          end
          else
          begin
            affichageInformation('Vous n''avez pas d''emplacement pour mettre un élève.', 25, COULEUR_TEXT_ROUGE, affichage);
            jouerSonValide(affichage,false);
          end
        else
        begin
          affichageInformation('Vous avez déjà atteint la limite de 5 élèves.', 25, COULEUR_TEXT_ROUGE, affichage);
          jouerSonValide(affichage,false);
        end
      else
        begin
        affichageInformation('Vous n''avez pas les ressources nécessaires pour acheter un eleve.', 25,COULEUR_TEXT_ROUGE, affichage);
        jouerSonValide(affichage,false);
        end;

    // CONNEXION
    2:
      if(aLesRessources(joueur,COUT_CONNEXION)) then
        if(resteEmplacementConnexion(affichage,plateau,joueur))then
          begin
          enleverRessources(joueur,COUT_CONNEXION);
          placementConnexion(plateau, affichage, joueur,false);
          
        end
        else
          begin
            affichageInformation('Vous n''avez pas les ressources nécessaires pour acheter une connexion.', 25, COULEUR_TEXT_ROUGE, affichage);
            jouerSonValide(affichage,false);
          end
      else
        begin
        affichageInformation('Vous n''avez pas d''emplacement pour mettre une connexion.', 25, COULEUR_TEXT_ROUGE, affichage);
        jouerSonValide(affichage,false);
        end;
    

    // PROFESSEUR
    3:
      if(aLesRessources(joueur,COUT_PROFESSEUR)) then
        if (conterNombrePersonnes(plateau.Personnes,false,joueur) < 4) then
          if(resteEleve(affichage,plateau,joueur))then
          begin

            enleverRessources(joueur,COUT_PROFESSEUR);

            changementProfesseur(plateau, affichage, joueur);
            
          end
          else
          begin
            affichageInformation('Vous n''avez pas les ressources nécessaires pour changer un élève en professeur.', 25, COULEUR_TEXT_ROUGE, affichage);
            jouerSonValide(affichage,false);
          end
        else
        begin
          affichageInformation('Vous avez déjà atteint la limite de 4 professeurs.', 25, COULEUR_TEXT_ROUGE, affichage);
          jouerSonValide(affichage,false);
        end
      else
        begin
        affichageInformation('Vous n''avez plus d''élève à modifier.', 25, COULEUR_TEXT_ROUGE, affichage);
        jouerSonValide(affichage,false);
        end;

    // carte de tutorat
    4:
    if(aLesRessources(joueur,COUT_CARTE_TUTORAT)) then
      if(plateau.cartesTutorat[0].nbr + plateau.cartesTutorat[1].nbr + plateau.cartesTutorat[2].nbr + plateau.cartesTutorat[3].nbr + plateau.cartesTutorat[4].nbr >0) then
        begin
        tirerCarteTutorat(plateau.CartesTutorat, joueur);

        enleverRessources(joueur,COUT_CARTE_TUTORAT);

        affichageCartesTutorat(joueur,affichage);
        affichageScoreAndClear(joueur,affichage);
        miseAJourRenderer(affichage);
        end
      else
        begin
        affichageInformation('Impossible d''acheter une carte de tutorat car il n''y en a plus.', 25, COULEUR_TEXT_ROUGE, affichage);
        jouerSonValide(affichage,false);
        end
    else
      begin
      affichageInformation('Vous n''avez pas les ressources nécessaires pour acheter une carte de tutorat.', 25, COULEUR_TEXT_ROUGE, affichage);
      jouerSonValide(affichage,false);
      end;
  end;
end;

procedure placementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur);
var HexagonesCoords: TCoords;
  valide : Boolean;
begin
  affichageInformation('Cliquez sur 3 hexagones entre lesquels vous voulez placer l''élève.', 25, FCouleur(0, 0, 0, 255), affichage);
  repeat
    HexagonesCoords := ClicPersonne(affichage,plateau,True);
    valide := PersonneValide(plateau, HexagonesCoords, True, joueur,affichage);
    jouerSonValide(affichage,valide);
    if(not valide)then
      begin
      affichagePlateau(plateau,affichage);
      resteEmplacementEleve(affichage,plateau,joueur);
      // miseAJourRenderer(affichage);
      end;
  until valide;

  SetLength(plateau.Personnes, Length(plateau.Personnes) + 1);
  with plateau.Personnes[High(plateau.Personnes)] do
    begin
        SetLength(Position, 3); 
        Position[0] := HexagonesCoords[0];
        Position[1] := HexagonesCoords[1];
        Position[2] := HexagonesCoords[2];

      estEleve := True;
      IdJoueur := joueur.Id;
      end;
  joueur.Points:=1+joueur.Points;

  affichageInformation('Elève placé avec succès !', 25, COULEUR_TEXT_VERT, affichage);

  affichageScoreAndClear(joueur, affichage);
  affichagePlateau(plateau,affichage);
  miseAJourRenderer(affichage);
end;

function PersonneValide(plateau: TPlateau; HexagonesCoords: TCoords; estEleve: Boolean; joueurActuel: TJoueur;var affichage : TAffichage): Boolean;
var
  personneAdjacente: Boolean;
begin
  personneAdjacente := False;
  if not enContact(HexagonesCoords) then
  begin
    PersonneValide := False;
    Exit;
  end;

  if(joueurActuel.Points >=2 ) then
    if not enContactEleveConnexion(plateau,HexagonesCoords,joueurActuel) then
    begin
      PersonneValide:=false;
      exit;
    end;

    if  VerifierAdjacencePersonnes(HexagonesCoords,plateau) then
    begin
        PersonneValide := False;
        exit;
    end
    else
        personneAdjacente := True;

  if encontactAutreconnexionEleve(plateau,HexagonesCoords,joueurActuel) then
  begin
    PersonneValide:=False;
    exit;
  end;
  PersonneValide := personneAdjacente;

end;


function ClicPersonne(var affichage: TAffichage; plateau: TPlateau; estEleve: Boolean): TCoords;
var
  i: Integer;
  HexagonesCoords: TCoords;
  valide : Boolean;
begin
  SetLength(HexagonesCoords,3);
  
  for i := 0 to 2 do
  begin
    repeat 
      clicHexagone(affichage,HexagonesCoords[i]);
      valide := dansLaGrille(plateau,HexagonesCoords[i]);
      if(not valide)then
      begin
        affichageInformation('Veuillez jouer dans le plateau.', 25, COULEUR_TEXT_ROUGE, affichage);
        jouerSonValide(affichage,false); 
      end;
    until valide;
    affichageHexagone(plateau,affichage, HexagonesCoords[i],true);
    miseAJourRenderer(affichage);
  end;
  ClicPersonne := HexagonesCoords;
end;

function VerifierAdjacencePersonnes(HexagonesCoords: TCoords; plateau: TPlateau): Boolean;
var
  i,j, k, nombreCommuns: Integer;
begin
  VerifierAdjacencePersonnes := False;
  for i := 0 to High(HexagonesCoords) - 1 do
  begin
    for j := i + 1 to High(HexagonesCoords) do
    begin
      if (HexagonesCoords[i].x = HexagonesCoords[j].x) and 
        (HexagonesCoords[i].y = HexagonesCoords[j].y) then
      begin
        Exit(True);
      end;
    end;
  end;
  for i := 0 to High(plateau.Personnes) do
  begin
    nombreCommuns := 0;
    for j := 0 to High(HexagonesCoords) do
    begin
      for k := 0 to 2 do
      begin
        if (HexagonesCoords[j].x = plateau.Personnes[i].Position[k].x) and
            (HexagonesCoords[j].y = plateau.Personnes[i].Position[k].y) then
        begin
          Inc(nombreCommuns);
          Break;
        end;
      end;
      if nombreCommuns >= 2 then
      begin
        VerifierAdjacencePersonnes := True;
        Exit;
      end;
    end;
  end;
end;

function conterNombrePersonnes(personnes: TPersonnes; estEleve: Boolean; joueur: TJoueur): Integer;
var
  i,Result: Integer;

begin
  Result := 0; 
  for i := 0 to length(personnes)-1 do
  begin
    if (personnes[i].estEleve = estEleve) and (personnes[i].IdJoueur = joueur.Id) then
      Inc(Result); 
  end;
  conterNombrePersonnes:= Result;
end;

function professeurValide(var affichage: TAffichage; plateau: TPlateau; joueurActuel: TJoueur; HexagonesCoords: TCoords; var ProfesseurCoords: TCoords; var indexEleve: Integer): Boolean;
var
  i, j, k, compteur: Integer;
begin
  professeurValide := False;
  indexEleve := -1; 
  setLength(ProfesseurCoords, 3);

  if enContact(HexagonesCoords) then
  begin
    for i := 0 to High(plateau.Personnes) do
    begin
      if (plateau.Personnes[i].IdJoueur = joueurActuel.Id) and (plateau.Personnes[i].estEleve) then
      begin
        compteur := 0;
        for j := 0 to High(HexagonesCoords) do
        begin
          for k := 0 to High(HexagonesCoords) do
          begin
            if (plateau.Personnes[i].Position[j].x = HexagonesCoords[k].x) and
              (plateau.Personnes[i].Position[j].y = HexagonesCoords[k].y) then
              Inc(compteur);
          end;
        end;
        if compteur = 3 then
        begin
          professeurValide := True;
          ProfesseurCoords[0] := HexagonesCoords[0];
          ProfesseurCoords[1] := HexagonesCoords[1];
          ProfesseurCoords[2] := HexagonesCoords[2];
          indexEleve := i;
          Exit;
        end
        else
          affichageInformation('Il n''y a pas d''élève vous appartenant ici.', 25, FCouleur(255, 0, 0, 255), affichage);
      end;
    end;
  end
  else
  begin
    affichageInformation('Les hexagones sélectionnés ne sont pas adjacents.', 25, FCouleur(255, 0, 0, 255), affichage);
  end;
end;

procedure ChangementProfesseur(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
var
  HexagonesCoords, ProfesseurCoords: TCoords;
  indexEleve: Integer;
  valide: Boolean;
begin
  affichageInformation('Cliquez sur 3 hexagones entre lesquels vous voulez placer le professeur.', 25, FCouleur(0, 0, 0, 255), affichage);
  repeat
    HexagonesCoords := ClicPersonne(affichage,plateau, False);
    valide := professeurValide(affichage, plateau, joueurActuel, HexagonesCoords, ProfesseurCoords, indexEleve);
    if(not valide)then
      begin
      affichagePlateau(plateau,affichage);
      resteEleve(affichage,plateau,joueurActuel);
      // miseAJourRenderer(affichage);
      jouerSonValide(affichage,valide);
      end;
  until valide;
  jouerSonValide(affichage,valide);
  if indexEleve <> -1 then
  begin
    plateau.Personnes[indexEleve].Position := ProfesseurCoords;
    plateau.Personnes[indexEleve].estEleve := False;
    
    joueurActuel.Points := joueurActuel.Points + 1;

    affichageInformation('Élève converti en professeur avec succès !', 25, FCouleur(0, 255, 0, 255), affichage);
    
    affichageScoreAndClear(joueurActuel, affichage);
    affichagePlateau(plateau,affichage);
    miseAJourRenderer(affichage);
  end;
end;

function trouverXemeConnexion(plateau: TPlateau; joueur: TJoueur;nbr:Integer): TConnexion;
var
  i,n: Integer;
  connexion: TConnexion;
begin
  n := 0;
  for i := 0 to High(plateau.Connexions) do
  begin
    if plateau.Connexions[i].IdJoueur = joueur.Id then
    begin
      n := n + 1;
      if(n=nbr)then
        begin
        setlength(connexion.position,2);
        connexion.position[0] := plateau.Connexions[i].Position[0];
        connexion.position[1] := plateau.Connexions[i].Position[1];
        connexion.IdJoueur := plateau.Connexions[i].IdJoueur;
        trouverXemeConnexion := connexion;
            
        Exit;
        end;
    end;
  end;
end;

function nombreConnexionJoueur(plateau: TPlateau; joueur: TJoueur): Integer;
var
  i: Integer;
begin
  nombreConnexionJoueur :=0;
  for i := 0 to High(plateau.Connexions) do
  begin
    if plateau.Connexions[i].IdJoueur = joueur.Id then
      nombreConnexionJoueur := nombreConnexionJoueur + 1;
  end;
end;

function coordsDansTableau(connexion: TConnexion; tableau: array of TConnexion): Boolean;
var
  i: Integer;
begin
  coordsDansTableau := False;
  for i := 0 to High(tableau) do
  begin
    if CoordsEgales(connexion.position, tableau[i].position) then
    begin
      coordsDansTableau := True;
      Exit;
    end;
  end;
end;


function compterConnexionSuite(plateau: TPlateau; joueur: TJoueur): Integer;
var
  nombreDeConnexion1,nombreDeConnexion2 : Integer;
  connexionDejaVisite : array of Tconnexion;
begin
nombreDeConnexion2 := 0;

nombreDeConnexion1 := compterConnexionAutour(connexionDejaVisite,trouverXemeConnexion(plateau,joueur,1),plateau,joueur);
if(length(connexionDejaVisite)<nombreConnexionJoueur(plateau,joueur))then
  begin
  nombreDeConnexion2 := compterConnexionAutour(connexionDejaVisite,trouverXemeConnexion(plateau,joueur,2),plateau,joueur);
  end;

if(nombreDeConnexion1 > nombreDeConnexion2) then
  compterConnexionSuite := nombreDeConnexion1
else
  compterConnexionSuite := nombreDeConnexion2;
end;


function trouverConnexion(plateau: TPlateau; coord1, coord2: TCoord): TConnexion;
var
  i: Integer;
  coords: TCoords;
begin
  SetLength(coords, 2);
  coords[0] := coord1;
  coords[1] := coord2;

  for i := 0 to High(plateau.Connexions) do
  begin
    if CoordsEgales(plateau.Connexions[i].Position, coords) then
    begin
      trouverConnexion := plateau.Connexions[i];
      Exit;
    end;
  end;
  trouverConnexion.IdJoueur := -1;
end;



function compterConnexionAutour(var connexionDejaVisite : Tconnexions;connexion : TConnexion;plateau: TPlateau; joueur: TJoueur): Integer;
var coords1,coords2 : TCoords;
  total: Integer ;
  nbr1,nbr2,nbr3,nbr4: Integer ;

  nouvelleConnexion : TConnexion;
begin

compterConnexionAutour := 0;

if ((connexion.IdJoueur = joueur.Id) and not coordsDansTableau(connexion,connexionDejaVisite)) then
  begin
    compterConnexionAutour := 1;
    SetLength(connexionDejaVisite, Length(connexionDejaVisite) + 1);
    connexionDejaVisite[High(connexionDejaVisite)] := connexion;

    setLength(coords1,3);
    setLength(coords2,3);
    
    coords1[0] := connexion.Position[0];
    coords1[1] := connexion.Position[1];
    
    coords2[0] := connexion.Position[0];
    coords2[1] := connexion.Position[1];

    trouver3EmeHexagone(plateau,coords1,coords2,connexion.position);

    total :=0;

    nbr1 := 0;
    nbr2 := 0;
    nbr3 := 0;
    nbr4 := 0;

    nouvelleConnexion := trouverConnexion(plateau,coords1[0],coords1[2]);
    if(nouvelleConnexion.IdJoueur <> -1)then
      nbr1 := compterConnexionAutour(connexionDejaVisite,nouvelleConnexion ,plateau,joueur);

    nouvelleConnexion := trouverConnexion(plateau,coords1[1],coords1[2]);
    if(nouvelleConnexion.IdJoueur <> -1)then
      nbr2 := compterConnexionAutour(connexionDejaVisite,nouvelleConnexion ,plateau,joueur);

    nouvelleConnexion := trouverConnexion(plateau,coords2[0],coords2[2]);
    if(nouvelleConnexion.IdJoueur <> -1)then
      nbr3 := compterConnexionAutour(connexionDejaVisite,nouvelleConnexion ,plateau,joueur);
    
    nouvelleConnexion := trouverConnexion(plateau,coords2[1],coords2[2]);
    if(nouvelleConnexion.IdJoueur <> -1)then
      nbr4 := compterConnexionAutour(connexionDejaVisite,nouvelleConnexion ,plateau,joueur);

    if(nbr1 > nbr2) then
      total := total + nbr1
    else
      total := total + nbr2;
    
    if(nbr3 > nbr4) then
      total := total + nbr3
    else
      total := total + nbr4;
    // total := nbr1 + nbr2 + nbr3 + nbr4;

    compterConnexionAutour := compterConnexionAutour + total;

  end;
end;



function verificationPointsVictoire(plateau : TPlateau;var joueurs: TJoueurs;var affichage : TAffichage):TIntegerTab;
var
  plusGrandeConnexion,plusDeplacementSouillard : Boolean;
  id,i,nombreDeGagnant : Integer;
  points,longueurRoutes : TIntegerTab;
begin
  setlength(verificationPointsVictoire,0);

  gagnant := -1;
  nombreDeGagnant := 0;

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
      for i := 0 to High(joueurs) do
        if(id <> i )then
          if(longueurRoutes[id] < longueurRoutes[i]) then
            plusGrandeConnexion := False;
      if plusGrandeConnexion then
        begin
        writeln('longueurRoutes[id] : ',longueurRoutes[id]);
        joueurs[id].PlusGrandeConnexion := True;
        points[id] := points[id] + 2;
        end;
    end;
    

    joueurs[id].PlusGrandeNombreDeWordReference := False;

    if(joueurs[id].CartesTutorat[1].utilisee >= 3) then
    begin
      for i := 0 to High(joueurs) do
        if(joueurs[id].CartesTutorat[1].utilisee < joueurs[i].CartesTutorat[1].utilisee) then
          plusDeplacementSouillard := False;
        if(plusDeplacementSouillard) then
        begin
          points[id] := points[id] + 2;
          joueurs[id].PlusGrandeNombreDeWordReference := True;
        end;
    end;
    if points[id] >= 10 then
      nombreDeGagnant := nombreDeGagnant +1;
    affichageScoreAndClear(joueurs[id],affichage);
  end;


  for id := 0 to length(joueurs)-1 do
    if points[id] >= 10 then
    begin
      setlength(verificationPointsVictoire,length(verificationPointsVictoire));
      verificationPointsVictoire[length(verificationPointsVictoire)-1] := id;
    end;
end;

function connexionExisteDeja(plateau: TPlateau; coord1: TCoord; coord2: TCoord): Boolean;
var i : Integer;
begin
for i := 0 to High(plateau.Connexions) do
  begin
  if (((plateau.Connexions[i].Position[0].x = coord1.x) and
        (plateau.Connexions[i].Position[0].y = coord1.y) and
        (plateau.Connexions[i].Position[1].x = coord2.x) and
        (plateau.Connexions[i].Position[1].y = coord2.y))
      or
      ((plateau.Connexions[i].Position[0].x = coord2.x) and
        (plateau.Connexions[i].Position[0].y = coord2.y) and
        (plateau.Connexions[i].Position[1].x = coord1.x) and
        (plateau.Connexions[i].Position[1].y = coord1.y))) then
  exit(True);
  end;
exit(False);
end;


function connexionValide(coords: TCoords; plateau: TPlateau; joueur: TJoueur;var affichage :TAffichage): Boolean;
var
  enContactAvecAutreConnexion, enContactAvecPersonne: Boolean;
begin
  // Initialisation
  connexionValide := True;
  enContactAvecAutreConnexion := False;
  // enContactAvecPersonne := False;
  attendre(16);


  // 1. Verifie si une connexion existe dejà avec les mêmes coordonnees (independamment de l'ordre)
  if(connexionExisteDeja(plateau, coords[0],coords[1]))then
    begin
      // connexionValide := False;
      affichageInformation('Position de connexion déjà occupée.', 25, COULEUR_TEXT_ROUGE, affichage);
      Exit(False);
    end;
  // end;

  // 2. Verifie si les deux hexagones sont adjacents
  if not enContact(coords) then
  begin
    // connexionValide := False;
    affichageInformation('Les deux hexagones ne sont pas adjacents.', 25, COULEUR_TEXT_ROUGE, affichage);
    Exit(False);
  end;

  enContactAvecPersonne := enContactConnexionEleve(plateau, coords, joueur);
  enContactAvecAutreConnexion := not aucuneConnexionAdjacente(coords, plateau, joueur,affichage);
  writeln('enContactAvecPersonne : ',enContactAvecPersonne);
  writeln('enContactAvecAutreConnexion : ',enContactAvecAutreConnexion);

  if not enContactAvecPersonne then
  begin
    if  not enContactAvecAutreConnexion then
    begin
      // connexionValide := False;
      affichageInformation('La connexion doit être adjacente à une autre connexion ou en contact avec un élève ou un professeur.', 25, COULEUR_TEXT_ROUGE, affichage);
      Exit(False);
    end;
  end;

  // 4. Verifie si au moins 1 des hexagones est dans le plateau
  if (not dansLePlateau(plateau,coords[0]) and not dansLePlateau(plateau,coords[1])) then 
    begin
    // connexionValide:= False;
    affichageInformation('Au moins 1 des hexagones choisis doit être dans le plateau', 25, COULEUR_TEXT_ROUGE, affichage);
    Exit(False);
    end;
  attendre(16);
end;






function clicConnexion(var affichage: TAffichage; plateau: TPlateau): TCoords;
var
  i: Integer;
  HexagonesCoords: TCoords;
  valide : Boolean;
begin
  SetLength(HexagonesCoords,2);
  for i := 0 to 1 do
  begin
    repeat 
      clicHexagone(affichage,HexagonesCoords[i]);
      valide := dansLaGrille(plateau,HexagonesCoords[i]);
      if(not valide)then
      begin
        affichageInformation('Veuillez jouer dans le plateau.', 25, COULEUR_TEXT_ROUGE, affichage);
        jouerSonValide(affichage,false); 
      end;
    until valide;
    affichageHexagone(plateau,affichage, HexagonesCoords[i],true);
    miseAJourRenderer(affichage);

    attendre(16);
  end;
  clicConnexion := HexagonesCoords;
end;

procedure placementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur;debut : Boolean);
var
  coords: TCoords;
  valide : boolean;
begin
  attendre(16);
  affichageInformation('Cliquez sur 2 hexagones entre lesquels vous voulez placer la connexion', 25, FCouleur(0,0,0,255), affichage);
  attendre(50);
  repeat
    if(debut)then
      placeFauxConnexionAutourJoueur(affichage,plateau,joueur.id);
    coords := clicConnexion(affichage,plateau);
    valide := connexionValide(coords, plateau, joueur,affichage);
    jouerSonValide(affichage,valide);
    if(not valide)then
      begin
      affichagePlateau(plateau,affichage);
      resteEmplacementConnexion(affichage,plateau,joueur);
      end;
  until valide;

  SetLength(plateau.Connexions, Length(plateau.Connexions) + 1);
  plateau.Connexions[length(plateau.Connexions)-1].IdJoueur := joueur.Id;

  setLength(plateau.Connexions[length(plateau.Connexions)-1].Position,2);

  plateau.Connexions[length(plateau.Connexions)-1].Position[0] := coords[0];
  plateau.Connexions[length(plateau.Connexions)-1].Position[1] := coords[1];

  affichageScoreAndClear(joueur, affichage);
  affichagePlateau(plateau,affichage);
  affichageInformation('Connexion placée avec succès !', 25, COULEUR_TEXT_VERT, affichage);
  attendre(50);
end;


function enContactEleveConnexion( plateau: TPlateau; coords: TCoords; var joueur: TJoueur): Boolean;
var
  i, k, l: Integer;
begin
  enContactEleveConnexion := False;
  for i := 0 to High(plateau.Connexions) do
  begin
    if plateau.Connexions[i].IdJoueur = joueur.Id then
    begin
      l := 0;
      for k := 0 to 1 do
        for l := 0 to 1 do
          if (coords[k].x = plateau.Connexions[i].Position[l].x) and
              (coords[k].y = plateau.Connexions[i].Position[l].y) then
          begin
            enContactEleveConnexion := True;
            Exit;
          end;
    end;
  end;
end;
function adjacence3Connexions(coords: TCoords; plateau: TPlateau; joueur: TJoueur; var affichage: TAffichage): Boolean;
var
  i, k: Integer;
  autreCoord: TCoords;
begin
  SetLength(autreCoord, 2);
  k := 0;
  for i := 0 to High(plateau.Connexions) do
  begin
    if plateau.Connexions[i].IdJoueur <> joueur.Id then
    begin
      autreCoord[0] := plateau.Connexions[i].Position[0];
      autreCoord[1] := plateau.Connexions[i].Position[1];
      if enContactConnexionConnexion(coords, autreCoord) then
        Inc(k);
    end;
  end;
  if k = 2 then
    adjacence3Connexions := True
  else
    adjacence3Connexions := False;
end;

function aucuneConnexionAdjacente(coords: TCoords; plateau: TPlateau; joueur: TJoueur; var affichage : TAffichage): Boolean;
var coords1,coords2 : TCoords;
  i: Integer;
begin
  aucuneConnexionAdjacente := True;

  setLength(coords1,3);
  setLength(coords2,3);
  
  coords1[0] := coords[0];
  coords1[1] := coords[1];
  
  coords2[0] := coords[0];
  coords2[1] := coords[1];

  trouver3EmeHexagone(plateau,coords1,coords2,coords);

  for i := 0 to length(plateau.Connexions)-1 do
    if(CoordsEgales(coords,coords1) or CoordsEgales(coords,coords2))then
      exit(False);
end;

function enContactAutreEleveConnexion(plateau:TPlateau ;coords: TCoords; var joueur:TJoueur; var affichage : TAffichage):Boolean;
  var
  i, k, l: Integer;
begin
  enContactAutreEleveConnexion := False;
  for i := 0 to High(plateau.Personnes) do
  begin
    if plateau.Personnes[i].IdJoueur <> joueur.Id then
    begin
      l := 0;
      for k := 0 to 2 do
      begin
        if (coords[0].x = plateau.Personnes[i].Position[k].x) and
            (coords[0].y = plateau.Personnes[i].Position[k].y) then
        begin
          Inc(l);
        end;

        if (coords[1].x = plateau.Personnes[i].Position[k].x) and
            (coords[1].y = plateau.Personnes[i].Position[k].y) then
        begin
          Inc(l);
        end;
        if l >= 2 then
        begin
          enContactAutreEleveConnexion := True;
          affichageInformation('Connexion en contact avec une personne d''un autre joueur.', 25, FCouleur(0,0,0,255), affichage);
          Exit;
        end;
      end;
    end;
  end;
end;


procedure deplacementSouillard(var plateau : TPlateau;var joueurs : TJoueurs ;var affichage : TAffichage);
var coord : Tcoord;
  valide : Boolean;
begin
  affichageInformation('Cliquez sur 1 hexagones pour déplacer le souillard.', 25, FCouleur(0,0,0,255), affichage);

  repeat
    clicHexagone(affichage, coord);
    valide := dansLePlateau(plateau,coord);
    jouerSonValide(affichage,valide);
  until (valide);

  plateau.Souillard.Position := coord;
  
  affichagePlateau(plateau,affichage);
  attendre(16);

  affichageInformation('Souillard déplacé avec succès !', 25, COULEUR_TEXT_VERT, affichage);
end;

function enContactConnexionConnexion( coords1: TCoords; coords2: TCoords): Boolean;
var autreCoord1, autreCoord2: TCoord;
    i, j: Integer;
begin
  enContactConnexionConnexion := False;
  for i := 0 to 1 do
    for j := 0 to 1 do
    begin
      if (coords1[i].x = coords2[j].x) and (coords1[i].y = coords2[j].y) then
      begin
        autreCoord1 := coords1[1-i];
        autreCoord2 := coords2[1-j];
        Exit;
      end;
  end;
  if sontAdjacents(autreCoord1, autreCoord2) then
    enContactConnexionConnexion := True;
end;



function CoordsEgales(coords1: TCoords; coords2: TCoords): Boolean;
var i : Integer;
begin
  CoordsEgales := False;
  if Length(coords1) = Length(coords2) then
  begin
    CoordsEgales := True;
    for i := 0 to High(coords1) do
    begin
      if not ((coords1[i].x = coords2[i].x) and (coords1[i].y = coords2[i].y)) and
          not ((coords1[i].x = coords2[High(coords2) - i].x) and (coords1[i].y = coords2[High(coords2) - i].y)) then
      begin
        CoordsEgales := False;
        Break;
      end;
    end;
  end;
end;

function enContactConnexions(plateau: TPlateau; coords: TCoords; joueur: TJoueur): Boolean;
var
  i: Integer;
  coord1, coord2, autreCoord, autreCoord2: TCoord;
begin
  enContactConnexions := False;
  for i := 0 to High(plateau.Connexions) do
  begin
    if plateau.Connexions[i].IdJoueur = joueur.Id then
    begin
      coord1 := plateau.Connexions[i].Position[0];
      coord2 := plateau.Connexions[i].Position[1];
      if (coords[0].x = coord1.x) and (coords[0].y = coord1.y) then
      begin
        autreCoord := coords[1];
        autreCoord2 := coord2;
      end
      else if (coords[1].x = coord1.x) and (coords[1].y = coord1.y) then
      begin
        autreCoord := coords[0];
        autreCoord2 := coord2;
      end
      else if (coords[0].x = coord2.x) and (coords[0].y = coord2.y) then
      begin
        autreCoord := coords[1];
        autreCoord2 := coord1;
      end
      else if (coords[1].x = coord2.x) and (coords[1].y = coord2.y) then
      begin
        autreCoord := coords[0];
        autreCoord2 := coord1;
      end
      else
        Continue;
      if sontAdjacents(autreCoord, autreCoord2) then
      begin
        enContactConnexions := True;
        Exit;
      end;
    end;
  end;
end;
function enContactEleveConnexions(plateau: TPlateau; eleve: TPersonne; var joueur: TJoueur): TCoords;
var
  i: Integer;
  connexionsTrouvees: Integer;
begin
  enContactEleveConnexions := nil;

  connexionsTrouvees := 0;
  SetLength(enContactEleveConnexions, 6);
  for i := 0 to High(plateau.Connexions) do
  begin
    if enContactEleveConnexion(plateau, plateau.Connexions[i].Position, joueur) then
    begin
      enContactEleveConnexions[connexionsTrouvees] := plateau.Connexions[i].Position[0];
      enContactEleveConnexions[connexionsTrouvees+1] := plateau.Connexions[i].Position[1];

      connexionsTrouvees:=+2;
      if connexionsTrouvees = 6 then
        Exit;
    end;
  end;

  SetLength(enContactEleveConnexions, connexionsTrouvees);
end;

function resteEleve(var affichage : TAffichage;plateau: TPlateau; joueur: TJoueur): Boolean;
var i: Integer;
begin
  resteEleve := False;
  for i := 0 to High(plateau.Personnes) do
  begin
    if (plateau.Personnes[i].IdJoueur = joueur.Id) and (plateau.Personnes[i].estEleve) then
    begin
      placeFauxProfesseur(affichage, plateau.Personnes[i].position,joueur.Id);
      resteEleve := True;
    end;
  end;
  miseAJourRenderer(affichage);
end;

procedure placeFauxConnexion(affichage : TAffichage;coord1 : Tcoord;coord2 : Tcoord; id : Integer);
var connexion : TConnexion;
begin

  with connexion do
  begin
    SetLength(Position, 2);
    Position[0] := coord1;
    Position[1] := coord2;

    IdJoueur := -id-1;
  end;
  affichageConnexion(connexion, affichage);
end;

function resteEmplacementConnexion(var affichage : TAffichage;plateau: TPlateau; joueur: TJoueur): Boolean;
var i: Integer;
  coords1,coords2 : Tcoords;
begin
  resteEmplacementConnexion := False;
  for i := 0 to High(plateau.connexions) do
  begin
    if (plateau.connexions[i].IdJoueur = joueur.Id) then
    begin
      setLength(coords1,3);
      setLength(coords2,3);

      coords1[0] := plateau.connexions[i].Position[0];
      coords1[1] := plateau.connexions[i].Position[1];

      coords2[0] := plateau.connexions[i].Position[0];
      coords2[1] := plateau.connexions[i].Position[1];

      trouver3EmeHexagone(plateau,coords1,coords2,plateau.connexions[i].position);


      if(not connexionExisteDeja(plateau, coords1[0],coords1[2])
          and (dansLePlateau(plateau,coords1[0]) or dansLePlateau(plateau,coords1[2])))then
      begin
        placeFauxConnexion(affichage, coords1[0],coords1[2], joueur.Id);
        resteEmplacementConnexion := True;
      end;
      if(not connexionExisteDeja(plateau, coords1[1],coords1[2])
          and (dansLePlateau(plateau,coords1[1]) or dansLePlateau(plateau,coords1[2])))then
      begin
        placeFauxConnexion(affichage, coords1[1],coords1[2], joueur.Id);
        resteEmplacementConnexion := True;
      end;
      if(not connexionExisteDeja(plateau, coords2[0],coords2[2])
          and (dansLePlateau(plateau,coords2[0]) or dansLePlateau(plateau,coords2[2])))then
      begin
        placeFauxConnexion(affichage, coords2[0],coords2[2], joueur.Id);
        resteEmplacementConnexion := True;
      end;
      if(not connexionExisteDeja(plateau, coords2[1],coords2[2])
          and (dansLePlateau(plateau,coords2[1]) or dansLePlateau(plateau,coords2[2])))then
      begin
        placeFauxConnexion(affichage, coords2[1],coords2[2], joueur.Id);
        resteEmplacementConnexion := True;
      end;
    end;
  end;
  for i:=0 to length(plateau.personnes)-1 do
    affichagePersonne(plateau.personnes[i],affichage);
  attendre(16);
  miseAJourRenderer(affichage);
  attendre(16);
end;

procedure trouver3EmeHexagone(plateau : TPlateau;coords1,coords2,coords: TCoords);
var x1,x2,y1,y2: Integer;
  j : Boolean;
begin
j := false;
// diagonale 1
if(coords[0].x = coords[1].x)then
  begin
  x1:=-1; y1:=1;
  x2:=1; y2:=0;
  if(coords[0].y < coords[1].y)then
    j:=true;
  end
// horizontale
else if(coords[0].y = coords[1].y)then
  begin
  x1:=1; y1:=-1;
  x2:=0; y2:=1;
  if(coords[0].x < coords[1].x)then
    j:=true;
  end
// diagonale 2
else
  begin
  x1:=1; y1:=0;
  x2:=0; y2:=-1;
  if(coords[0].x < coords[1].x)then
    j:=true;
  end;
if(j)then
  begin
  coords1[2] := FCoord(coords[0].x+x1,coords[0].y+y1);
  coords2[2] := FCoord(coords[0].x+x2,coords[0].y+y2);
  end
else
  begin
  coords1[2] := FCoord(coords[1].x+x1,coords[1].y+y1);
  coords2[2] := FCoord(coords[1].x+x2,coords[1].y+y2);
  end;

end;


function resteEmplacementEleve(var affichage : TAffichage;plateau: TPlateau; joueur: TJoueur): Boolean;
var
  i: Integer;
  coords1,coords2 : Tcoords;

begin
  resteEmplacementEleve := False;
  for i := 0 to High(plateau.connexions) do
  begin
    if (plateau.connexions[i].IdJoueur = joueur.Id) then
    begin
    setLength(coords1,3);
    setLength(coords2,3);

    coords1[0] := plateau.connexions[i].Position[0];
    coords1[1] := plateau.connexions[i].Position[1];

    coords2[0] := plateau.connexions[i].Position[0];
    coords2[1] := plateau.connexions[i].Position[1];

    trouver3EmeHexagone(plateau,coords1,coords2,plateau.connexions[i].position);

    if(not VerifierAdjacencePersonnes(coords1,plateau))then
      begin
      placeFauxEleve(affichage, coords1,joueur.Id);
      resteEmplacementEleve := True;
      end;
    if(not VerifierAdjacencePersonnes(coords2,plateau))then
      begin
      placeFauxEleve(affichage, coords2,joueur.Id);
      resteEmplacementEleve := True;
      end;
    end;
  end;
  attendre(30);
  miseAJourRenderer(affichage);
end;



procedure placeFauxEleve(affichage : TAffichage;coords : Tcoords; id : Integer);
var personne : TPersonne;
begin

  with personne do
    begin
    SetLength(Position, 3);
    Position[0] := coords[0];
    Position[1] := coords[1];
    Position[2] := coords[2];

    estEleve := True;
    IdJoueur := -id-1;
    end;
  affichagePersonne(personne, affichage);
end;

procedure placeFauxProfesseur(affichage : TAffichage;coords : Tcoords; id : Integer);
var personne : TPersonne;
begin
  with personne do
    begin
    SetLength(Position, 3);
    Position[0] := coords[0];
    Position[1] := coords[1];
    Position[2] := coords[2];

    estEleve := False;
    IdJoueur := -id-1;
    end;
  affichagePersonne(personne, affichage);
end;

function encontactAutreconnexionEleve(plateau: TPlateau; Eleve: TCoords; var joueur: TJoueur): Boolean;
var
  i, l: Integer;
  coord1, coord2: TCoords;
begin
  encontactAutreconnexionEleve := False;
  l := 0;
  SetLength(coord1, 2);
  SetLength(coord2, 2);

  for i := 0 to High(plateau.Connexions) do
  begin
    if plateau.Connexions[i].IdJoueur <> joueur.Id then
    begin
      coord1[0] := plateau.Connexions[i].Position[0];
      coord1[1] := plateau.Connexions[i].Position[1];
      coord2[0] := Eleve[0];
      coord2[1] := Eleve[1];
      if CoordsEgales(coord2, coord1) then
      begin
        Inc(l);
        Break;
      end;

      coord2[0] := Eleve[1];
      coord2[1] := Eleve[2];
      if CoordsEgales(coord2, coord1) then
      begin
        Inc(l);
        Break;
      end;
      coord2[0] := Eleve[0];
      coord2[1] := Eleve[2];
      if CoordsEgales(coord2, coord1) then
      begin
        Inc(l);
        Break;
      end;
    end;
  end;
  if l > 0 then
    encontactAutreconnexionEleve := True;
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

function enContactConnexionEleve( plateau: TPlateau; coords: TCoords; var joueur: TJoueur): Boolean;
var
  i, k, l: Integer;
begin
  enContactConnexionEleve := False;
  for i := 0 to High(plateau.Personnes) do
  begin
    if plateau.Personnes[i].IdJoueur = joueur.Id then
    begin
      l := 0;
      for k := 0 to 2 do
      begin
        if (coords[0].x = plateau.Personnes[i].Position[k].x) and
            (coords[0].y = plateau.Personnes[i].Position[k].y) then
        begin
          Inc(l);
        end;

        if (coords[1].x = plateau.Personnes[i].Position[k].x) and
            (coords[1].y = plateau.Personnes[i].Position[k].y) then
        begin
          Inc(l);
        end;
        if l >= 2 then
        begin
          enContactConnexionEleve := True;
          Exit;
        end;
      end;
    end;
  end;
end;
end.