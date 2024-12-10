unit achat;

interface
uses Types, affichageUnit,traitement,sysutils,musique;

procedure placeFauxConnexionAutourJoueur(affichage : TAffichage;plateau : TPlateau; id : Integer);
procedure deplacementSouillard(var plateau : TPlateau; var joueurs : TJoueurs ;var affichage : TAffichage);
procedure achatElements(var joueur: TJoueur; var plateau: TPlateau; var affichage: TAffichage; choix : Integer);
procedure placementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur;debut : Boolean);
procedure PlacementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur);


function resteEmplacementConnexion(var affichage : TAffichage;plateau: TPlateau; joueur: TJoueur): Boolean;
function verificationPointsVictoire(plateau : TPlateau;var joueurs: TJoueurs;var affichage : TAffichage):TIntegerTab;

implementation
procedure placeFauxConnexion(affichage : TAffichage;coord1 : Tcoord;coord2 : Tcoord; id : Integer);forward;
procedure placeFauxPersonne(affichage : TAffichage;coords : Tcoords; id : Integer;eleve : Boolean);forward;

procedure trouver3EmeHexagone(plateau : TPlateau;coords1,coords2,coords: TCoords);forward;
procedure tirerCarteTutorat(var cartesTutorat : TCartesTutorat;var  joueur : Tjoueur);forward;
procedure ChangementProfesseur(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);forward;

function trouverXemeConnexion(plateau: TPlateau; joueur: TJoueur;nbr:Integer): TConnexion;forward;
function compterConnexionAutour(var connexionDejaVisite : Tconnexions;connexion : TConnexion;plateau: TPlateau; joueur: TJoueur): Integer;forward;
function nombreConnexionJoueur(plateau: TPlateau; joueur: TJoueur): Integer;forward;
function connexionExisteDeja(plateau: TPlateau; coord1: TCoord; coord2: TCoord): Boolean;forward;
function clicConnexion(var affichage: TAffichage; plateau: TPlateau): TCoords;forward;
function ClicPersonne(var affichage: TAffichage; plateau: TPlateau; estEleve: Boolean): TCoords;forward;
function connexionValide(coords: TCoords; plateau: TPlateau; joueur: TJoueur;var affichage : TAffichage): Boolean;forward;
function professeurValide(var affichage: TAffichage; plateau: TPlateau; joueurActuel: TJoueur; HexagonesCoords: TCoords; var ProfesseurCoords: TCoords; var indexEleve: Integer): Boolean;forward;
function personneValide(plateau: TPlateau; HexagonesCoords: TCoords; estEleve: Boolean; joueurActuel: TJoueur;var affichage : TAffichage): Boolean;forward;
function VerifierAdjacencePersonnes(HexagonesCoords: TCoords; plateau: TPlateau): Boolean;forward;
function enContactEleveConnexion( plateau: TPlateau; coords: TCoords; var joueur: TJoueur): Boolean;forward;
function enContactConnexionEleve( plateau: TPlateau; coords: TCoords; var joueur: TJoueur): Boolean;forward;
function aucuneConnexionAdjacente(coords: TCoords;  plateau: TPlateau; joueur: TJoueur; var affichage : TAffichage): Boolean;forward;
function enContactAutreEleveConnexion(plateau:TPlateau ;coords: TCoords; var joueur:TJoueur; var affichage : TAffichage):Boolean;forward;
function resteEleve(var affichage : TAffichage;plateau:TPlateau; joueur:Tjoueur): Boolean;forward;
function resteEmplacementEleve(var affichage : TAffichage;plateau: TPlateau; joueur: TJoueur): Boolean;forward;
function compterConnexionSuite(plateau: TPlateau; joueur: TJoueur): Integer;forward;
function encontactAutreconnexionEleve(plateau: TPlateau;Eleve:Tcoords; var joueur:Tjoueur): Boolean;forward;
function coordsDansTableau(connexion: TConnexion; tableau: array of TConnexion): Boolean;forward;
function conterNombrePersonnes(personnes: TPersonnes; estEleve: Boolean; joueur: TJoueur): Integer;forward;


procedure placeFauxConnexionAutourJoueur(affichage : TAffichage; plateau : TPlateau; id : Integer);
var coords : Tcoords;
begin
  coords := plateau.Personnes[length(plateau.personnes)-1].Position;
  placeFauxConnexion(affichage,coords[0],coords[1],id);
  placeFauxConnexion(affichage,coords[1],coords[2],id);
  placeFauxConnexion(affichage,coords[0],coords[2],id);
  affichagePersonne(plateau.Personnes[length(plateau.personnes)-1],affichage);
  miseAJourRenderer(affichage);
end;


procedure tirerCarteTutorat(var cartesTutorat : TCartesTutorat; var  joueur : Tjoueur);
var  i,j,nbrTotal,min,max: Integer;
begin
  nbrTotal :=0;
  for i := 0 to 4 do
    nbrTotal :=nbrTotal  + cartesTutorat[i].nbr;

  min := 1;
  max := 0;
  i := Random(nbrTotal)+1;
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
          affichageInformation('Vous n''avez pas d''emplacement pour mettre une connexion.', 25, COULEUR_TEXT_ROUGE, affichage);
          jouerSonValide(affichage,false);
        end
      else
      begin
        affichageInformation('Vous n''avez pas les ressources nécessaires pour acheter une connexion.', 25, COULEUR_TEXT_ROUGE, affichage);
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
        enleverRessources(joueur,COUT_CARTE_TUTORAT);
        tirerCarteTutorat(plateau.CartesTutorat, joueur);

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
    valide := personneValide(plateau, HexagonesCoords, True, joueur,affichage);
    jouerSonValide(affichage,valide);
    if(not valide)then
    begin
      affichagePlateau(plateau,affichage);
      resteEmplacementEleve(affichage,plateau,joueur);
    end;
  until valide;

  SetLength(plateau.Personnes, Length(plateau.Personnes) + 1);
  with plateau.Personnes[length(plateau.Personnes)-1] do
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

function personneValide(plateau: TPlateau; HexagonesCoords: TCoords; estEleve: Boolean; joueurActuel: TJoueur;var affichage : TAffichage): Boolean;
begin
  personneValide := False;
  if not enContact(HexagonesCoords) then
    exit(False);

  if(joueurActuel.Points >=2 ) then
    if not enContactEleveConnexion(plateau,HexagonesCoords,joueurActuel) then
      exit(False);

  if(VerifierAdjacencePersonnes(HexagonesCoords,plateau)) then
    exit(False)
  else
    personneValide := True;

  if encontactAutreconnexionEleve(plateau,HexagonesCoords,joueurActuel) then
    exit(False);
end;

function ClicPersonne(var affichage: TAffichage; plateau: TPlateau; estEleve: Boolean): TCoords;
var i: Integer;
  valide : Boolean;
begin
  ClicPersonne := nil;
  SetLength(ClicPersonne,3);
  for i := 0 to 2 do
  begin
    repeat 
      clicHexagone(affichage,ClicPersonne[i]);
      valide := dansLaGrille(plateau,ClicPersonne[i]);
      if(not valide)then
      begin
        affichageInformation('Veuillez jouer dans le plateau.', 25, COULEUR_TEXT_ROUGE, affichage);
        jouerSonValide(affichage,false); 
      end;
    until valide;
    affichageHexagone(plateau,affichage, ClicPersonne[i],true);
    miseAJourRenderer(affichage);
  end;
end;

function VerifierAdjacencePersonnes(HexagonesCoords: TCoords; plateau: TPlateau): Boolean;
var i,j, k, nombreCommuns: Integer;
begin
  VerifierAdjacencePersonnes := False;
  for i := 0 to length(HexagonesCoords) - 1 do
    for j := i + 1 to length(HexagonesCoords) -1 do
      if ((HexagonesCoords[i].x = HexagonesCoords[j].x)
          and (HexagonesCoords[i].y = HexagonesCoords[j].y)) then
        Exit(True);
  for i := 0 to length(plateau.Personnes) -1 do
  begin
    nombreCommuns := 0;
    for j := 0 to length(HexagonesCoords) -1 do
    begin
      for k := 0 to 2 do
        if (HexagonesCoords[j].x = plateau.Personnes[i].Position[k].x) and
            (HexagonesCoords[j].y = plateau.Personnes[i].Position[k].y) then
        begin
          Inc(nombreCommuns);
          Break;
        end;
      if nombreCommuns >= 2 then
        exit(True);
    end;
  end;
end;

function conterNombrePersonnes(personnes: TPersonnes; estEleve: Boolean; joueur: TJoueur): Integer;
var i: Integer;
begin
  conterNombrePersonnes := 0; 
  for i := 0 to length(personnes)-1 do
    if (personnes[i].estEleve = estEleve) and (personnes[i].IdJoueur = joueur.Id) then
      Inc(conterNombrePersonnes); 
end;

function professeurValide(var affichage: TAffichage; plateau: TPlateau; joueurActuel: TJoueur; HexagonesCoords: TCoords; var ProfesseurCoords: TCoords; var indexEleve: Integer): Boolean;
var i, j, k, compteur: Integer;
begin
  professeurValide := False;
  indexEleve := -1; 
  setLength(ProfesseurCoords, 3);

  if enContact(HexagonesCoords) then
    for i := 0 to length(plateau.Personnes) -1 do
      if (plateau.Personnes[i].IdJoueur = joueurActuel.Id) and (plateau.Personnes[i].estEleve) then
      begin
        compteur := 0;
        for j := 0 to length(HexagonesCoords) -1 do
          for k := 0 to length(HexagonesCoords) -1 do
            if (plateau.Personnes[i].Position[j].x = HexagonesCoords[k].x) and
              (plateau.Personnes[i].Position[j].y = HexagonesCoords[k].y) then
              Inc(compteur);
        if compteur = 3 then
        begin
          ProfesseurCoords[0] := HexagonesCoords[0];
          ProfesseurCoords[1] := HexagonesCoords[1];
          ProfesseurCoords[2] := HexagonesCoords[2];
          indexEleve := i;
          exit(True);
        end
        else
          affichageInformation('Il n''y a pas d''élève vous appartenant ici.', 25, FCouleur(255, 0, 0, 255), affichage);
      end
  else
    affichageInformation('Les hexagones sélectionnés ne sont pas adjacents.', 25, FCouleur(255, 0, 0, 255), affichage);
end;

procedure ChangementProfesseur(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
var HexagonesCoords, ProfesseurCoords: TCoords;
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
var i,n: Integer;
begin
  trouverXemeConnexion.IdJoueur := -1;

  n := 0;
  for i := 0 to length(plateau.Connexions) -1 do
    if plateau.Connexions[i].IdJoueur = joueur.Id then
    begin
      n := n + 1;
      if(n=nbr)then
        begin
        SetLength(trouverXemeConnexion.Position, 2);
        trouverXemeConnexion.position[0] := plateau.Connexions[i].Position[0];
        trouverXemeConnexion.position[1] := plateau.Connexions[i].Position[1];
        trouverXemeConnexion.IdJoueur := plateau.Connexions[i].IdJoueur;
        Exit;
        end;
    end;
end;

function nombreConnexionJoueur(plateau: TPlateau; joueur: TJoueur): Integer;
var i: Integer;
begin
  nombreConnexionJoueur := 0;
  for i := 0 to length(plateau.Connexions) -1 do
    if plateau.Connexions[i].IdJoueur = joueur.Id then
      nombreConnexionJoueur := nombreConnexionJoueur + 1;
end;

function coordsDansTableau(connexion: TConnexion; tableau: array of TConnexion): Boolean;
var i: Integer;
begin
  coordsDansTableau := False;
  for i := 0 to length(tableau) -1 do
    if CoordsEgales(connexion.position, tableau[i].position) then
      exit(True);
end;

function compterConnexionSuite(plateau: TPlateau; joueur: TJoueur): Integer;
var nombreDeConnexion1,nombreDeConnexion2 : Integer;
  connexionDejaVisite : TConnexions;
begin
  nombreDeConnexion2 := 0;

  nombreDeConnexion1 := compterConnexionAutour(connexionDejaVisite,trouverXemeConnexion(plateau,joueur,1),plateau,joueur);
  if(length(connexionDejaVisite)<nombreConnexionJoueur(plateau,joueur))then
    nombreDeConnexion2 := compterConnexionAutour(connexionDejaVisite,trouverXemeConnexion(plateau,joueur,2),plateau,joueur);

  if(nombreDeConnexion1 > nombreDeConnexion2) then
    compterConnexionSuite := nombreDeConnexion1
  else
    compterConnexionSuite := nombreDeConnexion2;
end;

function trouverConnexion(plateau: TPlateau; coord1, coord2: TCoord): TConnexion;
var i: Integer;
  coords: TCoords;
begin
  SetLength(coords, 2);
  coords[0] := coord1;
  coords[1] := coord2;

  for i := 0 to length(plateau.Connexions) -1 do
    if CoordsEgales(plateau.Connexions[i].Position, coords) then
      exit(plateau.Connexions[i]);
  trouverConnexion.IdJoueur := -1;
end;



function compterConnexionAutour(var connexionDejaVisite : Tconnexions;connexion : TConnexion;plateau: TPlateau; joueur: TJoueur): Integer;
var coords1,coords2 : TCoords;
  nouvelleConnexion : TConnexion;
begin
  compterConnexionAutour := 0;

  if ((connexion.IdJoueur = joueur.Id) and not coordsDansTableau(connexion,connexionDejaVisite)) then
  begin
    compterConnexionAutour := 1;
    SetLength(connexionDejaVisite, Length(connexionDejaVisite) + 1);
    connexionDejaVisite[length(connexionDejaVisite) -1] := connexion;

    coords1 := [connexion.Position[0],connexion.Position[1]];
    coords2 := [connexion.Position[0],connexion.Position[1]];
    setLength(coords1,3);
    setLength(coords2,3);

    trouver3EmeHexagone(plateau,coords1,coords2,connexion.position);

    nouvelleConnexion := trouverConnexion(plateau,coords1[0],coords1[2]);
    if(nouvelleConnexion.IdJoueur <> -1)then
      compterConnexionAutour := compterConnexionAutour + compterConnexionAutour(connexionDejaVisite,nouvelleConnexion ,plateau,joueur);

    nouvelleConnexion := trouverConnexion(plateau,coords1[1],coords1[2]);
    if(nouvelleConnexion.IdJoueur <> -1)then
      compterConnexionAutour := compterConnexionAutour + compterConnexionAutour(connexionDejaVisite,nouvelleConnexion ,plateau,joueur);

    nouvelleConnexion := trouverConnexion(plateau,coords2[0],coords2[2]);
    if(nouvelleConnexion.IdJoueur <> -1)then
      compterConnexionAutour := compterConnexionAutour + compterConnexionAutour(connexionDejaVisite,nouvelleConnexion ,plateau,joueur);
    
    nouvelleConnexion := trouverConnexion(plateau,coords2[1],coords2[2]);
    if(nouvelleConnexion.IdJoueur <> -1)then
      compterConnexionAutour := compterConnexionAutour + compterConnexionAutour(connexionDejaVisite,nouvelleConnexion ,plateau,joueur);
  end;
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

function connexionExisteDeja(plateau: TPlateau; coord1: TCoord; coord2: TCoord): Boolean;
var i : Integer;
begin
  for i := 0 to length(plateau.Connexions) -1 do
    if(CoordsEgales(plateau.Connexions[i].Position,[coord1,coord2]))then
      exit(True);
  connexionExisteDeja := False;
end;

function connexionValide(coords: TCoords; plateau: TPlateau; joueur: TJoueur;var affichage :TAffichage): Boolean;
begin
  attendre(16);

  // 1. Verifie si une connexion existe dejà avec les mêmes coordonnees (independamment de l'ordre)
  if(connexionExisteDeja(plateau, coords[0],coords[1]))then
  begin
    affichageInformation('Position de connexion déjà occupée.', 25, COULEUR_TEXT_ROUGE, affichage);
    exit(False);
  end;

  // 2. Verifie si les deux hexagones sont adjacents
  if not enContact(coords) then
  begin
    affichageInformation('Les deux hexagones ne sont pas adjacents.', 25, COULEUR_TEXT_ROUGE, affichage);
    exit(False);
  end;

  if (aucuneConnexionAdjacente(coords, plateau, joueur,affichage) and (not enContactConnexionEleve(plateau, coords, joueur))) then
  begin
    affichageInformation('La connexion doit être adjacente à une autre connexion ou en contact avec un élève ou un professeur.', 25, COULEUR_TEXT_ROUGE, affichage);
    exit(False);
  end;

  // 4. Verifie si au moins 1 des hexagones est dans le plateau
  if (not dansLePlateau(plateau,coords[0]) and not dansLePlateau(plateau,coords[1])) then 
  begin
    affichageInformation('Au moins 1 des hexagones choisis doit être dans le plateau', 25, COULEUR_TEXT_ROUGE, affichage);
    exit(False);
  end;
  attendre(16);
end;

function clicConnexion(var affichage: TAffichage; plateau: TPlateau): TCoords;
var i: Integer;
  valide : Boolean;
begin
  clicConnexion := nil;
  SetLength(clicConnexion,2);
  for i := 0 to 1 do
  begin
    repeat 
      clicHexagone(affichage,clicConnexion[i]);
      valide := dansLaGrille(plateau,clicConnexion[i]);
      if(not valide)then
      begin
        affichageInformation('Veuillez jouer dans le plateau.', 25, COULEUR_TEXT_ROUGE, affichage);
        jouerSonValide(affichage,false); 
      end;
    until valide;
    affichageHexagone(plateau,affichage, clicConnexion[i],true);
    miseAJourRenderer(affichage);
    attendre(16);
  end;
end;

procedure placementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur;debut : Boolean);
var coords: TCoords;
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
var i : Integer;
begin
  enContactEleveConnexion := False;
  for i := 0 to length(plateau.Connexions) -1 do
    if plateau.Connexions[i].IdJoueur = joueur.Id then
      if(coordsEgales(coords, plateau.Connexions[i].Position)) then
        exit(True);
end;

function aucuneConnexionAdjacente(coords: TCoords; plateau: TPlateau; joueur: TJoueur; var affichage : TAffichage): Boolean;
var coords1,coords2 : TCoords;
  i: Integer;
begin
  aucuneConnexionAdjacente := True;

  coords1 := [coords[0],coords[1]];
  coords2 := [coords[0],coords[1]];
  setLength(coords1,3);
  setLength(coords2,3);

  trouver3EmeHexagone(plateau,coords1,coords2,coords);

  for i := 0 to length(plateau.Connexions)-1 do
    if (plateau.Connexions[i].IdJoueur = joueur.id) then
      if(CoordsEgales(plateau.Connexions[i].position,[coords1[0],coords1[2]]) or CoordsEgales(plateau.Connexions[i].position,[coords1[1],coords1[2]]) 
          or CoordsEgales(plateau.Connexions[i].position,[coords2[0],coords2[2]]) or CoordsEgales(plateau.Connexions[i].position,[coords2[1],coords2[2]]))then
        exit(False);
end;

function enContactAutreEleveConnexion(plateau:TPlateau ;coords: TCoords; var joueur:TJoueur; var affichage : TAffichage):Boolean;
var i, k, l: Integer;
begin
  enContactAutreEleveConnexion := False;
  for i := 0 to length(plateau.Personnes) -1 do
    if plateau.Personnes[i].IdJoueur <> joueur.Id then
    begin
      l := 0;
      for k := 0 to 2 do
      begin
        if (coords[0].x = plateau.Personnes[i].Position[k].x) and
            (coords[0].y = plateau.Personnes[i].Position[k].y) then
          Inc(l);

        if (coords[1].x = plateau.Personnes[i].Position[k].x) and
            (coords[1].y = plateau.Personnes[i].Position[k].y) then
          Inc(l);
        if l >= 2 then
        begin
          affichageInformation('Connexion en contact avec une personne d''un autre joueur.', 25, FCouleur(0,0,0,255), affichage);
          exit(True);
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

function resteEleve(var affichage : TAffichage;plateau: TPlateau; joueur: TJoueur): Boolean;
var i: Integer;
begin
  resteEleve := False;
  for i := 0 to length(plateau.Personnes) -1 do
    if (plateau.Personnes[i].IdJoueur = joueur.Id) and (plateau.Personnes[i].estEleve) then
    begin
      placeFauxPersonne(affichage, plateau.Personnes[i].position,joueur.Id,false);
      exit(True);
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
  for i := 0 to length(plateau.connexions) -1 do
    if (plateau.connexions[i].IdJoueur = joueur.Id) then
    begin
      coords1 := [plateau.connexions[i].Position[0],plateau.connexions[i].Position[1]];
      coords2 := [plateau.connexions[i].Position[0],plateau.connexions[i].Position[1]];
      setLength(coords1,3);
      setLength(coords2,3);


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
  for i:=0 to length(plateau.personnes)-1 do
    affichagePersonne(plateau.personnes[i],affichage);
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
var i: Integer;
  coords1,coords2 : Tcoords;
begin
  resteEmplacementEleve := False;
  for i := 0 to length(plateau.connexions) -1 do
    if (plateau.connexions[i].IdJoueur = joueur.Id) then
    begin
      coords1 := [plateau.connexions[i].Position[0],plateau.connexions[i].Position[1]];
      coords2 := [plateau.connexions[i].Position[0],plateau.connexions[i].Position[1]];
      setLength(coords1,3);
      setLength(coords2,3);

      trouver3EmeHexagone(plateau,coords1,coords2,plateau.connexions[i].position);

      if(not VerifierAdjacencePersonnes(coords1,plateau))then
      begin
        placeFauxPersonne(affichage, coords1,joueur.Id,true);
        resteEmplacementEleve := True;
      end;
      if(not VerifierAdjacencePersonnes(coords2,plateau))then
      begin
        placeFauxPersonne(affichage, coords2,joueur.Id,true);
        resteEmplacementEleve := True;
      end;
    end;
  attendre(30);
  miseAJourRenderer(affichage);
end;

procedure placeFauxPersonne(affichage : TAffichage;coords : Tcoords; id : Integer;eleve : Boolean);
var personne : TPersonne;
begin
  with personne do
  begin
    SetLength(Position, 3);
    Position[0] := coords[0];
    Position[1] := coords[1];
    Position[2] := coords[2];

    estEleve := eleve;
    IdJoueur := -id-1;
  end;
  affichagePersonne(personne, affichage);
end;

// TODO simplifier
function encontactAutreconnexionEleve(plateau: TPlateau; Eleve: TCoords; var joueur: TJoueur): Boolean;
var i, l: Integer;
  coord1, coord2: TCoords;
begin
  encontactAutreconnexionEleve := False;
  l := 0;
  SetLength(coord1, 2);
  SetLength(coord2, 2);

  for i := 0 to length(plateau.Connexions) -1 do
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

// TODO simplifier
function enContactConnexionEleve( plateau: TPlateau; coords: TCoords; var joueur: TJoueur): Boolean;
var
  i, k, l: Integer;
begin
  enContactConnexionEleve := False;
  for i := 0 to length(plateau.Personnes) -1 do
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