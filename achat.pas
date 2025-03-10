unit achat;

interface
uses Types, affichageUnit,traitement,sysutils,musique,TypInfo;

procedure deplacementSouillard(var plateau : TPlateau; var joueurs : TJoueurs ;var affichage : TAffichage);
procedure achatElements(var joueur: TJoueur; var plateau: TPlateau; var affichage: TAffichage; choix : Integer);
procedure placementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur;debut : Boolean);
procedure PlacementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur);
procedure placeFauxConnexionAutourJoueur(var affichage : TAffichage;plateau : TPlateau; id : Integer);
procedure utiliserCarteTutorat(var affichage : TAffichage;var plateau : TPlateau;var joueurs : TJoueurs;id : Integer;nom : String);

function resteEmplacementConnexion(var affichage : TAffichage;plateau: TPlateau; joueur: TJoueur): Boolean;

implementation
procedure placeFauxConnexion(var affichage : TAffichage;coord1 : Tcoord;coord2 : Tcoord; id : Integer);forward;
procedure placeFauxPersonne(var affichage : TAffichage;coords : Tcoords; id : Integer;eleve : Boolean);forward;

procedure tirerCarteTutorat(var cartesTutorat : TCartesTutorat;var  joueur : Tjoueur);forward;
procedure ChangementProfesseur(var affichage: TAffichage; var plateau: TPlateau; var joueurActuel: TJoueur);forward;
procedure utiliserCarte1(var affichage : TAffichage; var plateau : TPlateau; joueurs : Tjoueurs; id : Integer);forward;
procedure utiliserCarte2(var affichage : TAffichage; var plateau : TPlateau; joueurs : Tjoueurs; id : Integer);forward;
procedure utiliserCarte3(var affichage: TAffichage;var plateau : TPlateau; joueurs : Tjoueurs;id : Integer);forward;
procedure utiliserCarte4(var affichage : TAffichage;var plateau : TPlateau;var joueurs : Tjoueurs; id : Integer);forward;
procedure utiliserCarte5(var affichage : TAffichage;var joueurs : TJoueurs;id :Integer);forward;

function clicConnexion(var affichage: TAffichage; plateau: TPlateau): TCoords;forward;
function ClicPersonne(var affichage: TAffichage; plateau: TPlateau; estEleve: Boolean): TCoords;forward;
function connexionExisteDeja(plateau: TPlateau; coord1: TCoord; coord2: TCoord): Boolean;forward;
function connexionValide(coords: TCoords; plateau: TPlateau; joueur: TJoueur;var affichage : TAffichage; debut : Boolean): Boolean;forward;
function professeurValide(var affichage: TAffichage; plateau: TPlateau; joueurActuel: TJoueur; HexagonesCoords: TCoords; var ProfesseurCoords: TCoords; var indexEleve: Integer): Boolean;forward;
function eleveValide(plateau: TPlateau; HexagonesCoords: TCoords; joueurActuel: TJoueur;var affichage : TAffichage): Boolean;forward;
function VerifierAdjacencePersonnes(HexagonesCoords: TCoords; plateau: TPlateau): Boolean;forward;
function enContactEleveConnexion( plateau: TPlateau; eleve: TCoords; var joueur: TJoueur): Boolean;forward;
function enContactConnexionEleve( plateau: TPlateau; connexion: TCoords; var joueur: TJoueur): Boolean;forward;
function aucuneConnexionAdjacente(coords: TCoords;  plateau: TPlateau; joueur: TJoueur; var affichage : TAffichage): Boolean;forward;
function enContactAutreEleveConnexion(plateau:TPlateau ;connexion: TCoords; var joueur:TJoueur; var affichage : TAffichage):Boolean;forward;
function resteEleve(var affichage : TAffichage;plateau:TPlateau; joueur:Tjoueur): Boolean;forward;
function resteEmplacementEleve(var affichage : TAffichage;plateau: TPlateau; joueur: TJoueur): Boolean;forward;
function compterNombrePersonnes(personnes: TPersonnes; estEleve: Boolean; joueur: TJoueur): Integer;forward;


procedure placeFauxConnexionAutourJoueur(var affichage : TAffichage; plateau : TPlateau; id : Integer);
var coords : Tcoords;
begin
  coords := plateau.Personnes[length(plateau.personnes)-1].Position;
  if(dansLePlateau(plateau,coords[0]) or dansLePlateau(plateau,coords[1]))then
    placeFauxConnexion(affichage,coords[0],coords[1],id);
  if(dansLePlateau(plateau,coords[1]) or dansLePlateau(plateau,coords[2]))then
    placeFauxConnexion(affichage,coords[1],coords[2],id);
  if(dansLePlateau(plateau,coords[0]) or dansLePlateau(plateau,coords[2]))then
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
        if (compterNombrePersonnes(plateau.Personnes,true,joueur) < 5)  then
          if(resteEmplacementEleve(affichage,plateau,joueur))then
          begin
          enleverRessources(joueur,COUT_ELEVE);
          PlacementEleve(plateau, affichage, joueur);
          end
          else
          begin
            affichageInformationAndRender('Vous n''avez pas d''emplacement pour mettre un élève.', 25, COULEUR_TEXT_ROUGE, affichage);
            jouerSonValide(affichage,false);
          end
        else
        begin
          affichageInformationAndRender('Vous avez déjà atteint la limite de 5 élèves.', 25, COULEUR_TEXT_ROUGE, affichage);
          jouerSonValide(affichage,false);
        end
      else
        begin
        affichageInformationAndRender('Vous n''avez pas les ressources nécessaires pour acheter un élève (1 Physique + 1 Chimie + 1 Humanités + 1 Mathématiques).', 25,COULEUR_TEXT_ROUGE, affichage);
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
          affichageInformationAndRender('Vous n''avez pas d''emplacement pour mettre une connexion.', 25, COULEUR_TEXT_ROUGE, affichage);
          jouerSonValide(affichage,false);
        end
      else
      begin
        affichageInformationAndRender('Vous n''avez pas les ressources nécessaires pour acheter une connexion (1 Chimie + 1 Humanités).', 25, COULEUR_TEXT_ROUGE, affichage);
        jouerSonValide(affichage,false);
      end;
    // PROFESSEUR
    3:
      if(aLesRessources(joueur,COUT_PROFESSEUR)) then
        if (compterNombrePersonnes(plateau.Personnes,false,joueur) < 4) then
          if(resteEleve(affichage,plateau,joueur))then
          begin
            enleverRessources(joueur,COUT_PROFESSEUR);
            changementProfesseur(affichage, plateau, joueur);
          end
          else
          begin
          affichageInformationAndRender('Vous n''avez plus d''élève à modifier.', 25, COULEUR_TEXT_ROUGE, affichage);
          jouerSonValide(affichage,false);
          end
        else
        begin
          affichageInformationAndRender('Vous avez déjà atteint la limite de 4 professeurs.', 25, COULEUR_TEXT_ROUGE, affichage);
          jouerSonValide(affichage,false);
        end
      else
      begin
        affichageInformationAndRender('Vous n''avez pas les ressources nécessaires pour changer un élève en professeur (3 Informatique + 2 Mathématiques).', 25, COULEUR_TEXT_ROUGE, affichage);
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
        affichageInformationAndRender('Impossible d''acheter une carte de tutorat car il n''y en a plus.', 25, COULEUR_TEXT_ROUGE, affichage);
        jouerSonValide(affichage,false);
        end
    else
      begin
      affichageInformationAndRender('Vous n''avez pas les ressources nécessaires pour acheter une carte de tutorat (1 Physique + 1 Informatique + 1 Humanités).', 25, COULEUR_TEXT_ROUGE, affichage);
      jouerSonValide(affichage,false);
      end;
  end;
end;

procedure placementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur);
var HexagonesCoords: TCoords;
  valide : Boolean;
begin
  affichageInformationAndRender('Cliquez sur 3 hexagones entre lesquels vous voulez placer l''élève.', 25, FCouleur(0, 0, 0, 255), affichage);
  repeat
    HexagonesCoords := ClicPersonne(affichage,plateau,True);
    valide := eleveValide(plateau, HexagonesCoords, joueur,affichage);
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

  affichageInformationAndRender('Élève placé avec succès !', 25, COULEUR_TEXT_VERT, affichage);
  affichageScoreAndClear(joueur, affichage);
  affichagePlateau(plateau,affichage);
  miseAJourRenderer(affichage);
end;

function eleveValide(plateau: TPlateau; HexagonesCoords: TCoords; joueurActuel: TJoueur;var affichage : TAffichage): Boolean;
begin
  eleveValide := False;

  // 1. Verifie si les hexagones sont adjacents
  if not enContact(HexagonesCoords) then
  begin
    affichageInformation('Les hexagones ne sont pas adjacents.', 25, COULEUR_TEXT_ROUGE, affichage);
    exit(False);
  end;


  if(joueurActuel.Points >=2 ) then
    // 2. Vérifie si l'élève est en contact avec une connexion (après l'initialisation)
    if (not enContactEleveConnexion(plateau,HexagonesCoords,joueurActuel)) then
    begin 
      affichageInformation('L''élève doit être en contact avec une connexion.', 25, COULEUR_TEXT_ROUGE, affichage);
      exit(False);
    end;

  // 3. Vérifie si l'élève est à au moins 2 cases des autres élèves
  if(VerifierAdjacencePersonnes(HexagonesCoords,plateau)) then
    exit(False)
  else
    begin
    affichageInformation('L''élève doit être à au moins 2 cases des autres élèves.', 25, COULEUR_TEXT_ROUGE, affichage); 
    eleveValide := True;
    end;
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
        affichageInformationAndRender('Veuillez jouer dans le plateau.', 25, COULEUR_TEXT_ROUGE, affichage);
        jouerSonValide(affichage,false); 
      end;
    until valide;
    attendre(32);
    affichageHexagone(plateau,affichage, ClicPersonne[i],true);
    miseAJourRenderer(affichage);
    attendre(32);
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

function compterNombrePersonnes(personnes: TPersonnes; estEleve: Boolean; joueur: TJoueur): Integer;
var i: Integer;
begin
  compterNombrePersonnes := 0; 
  for i := 0 to length(personnes)-1 do
    if (personnes[i].estEleve = estEleve) and (personnes[i].IdJoueur = joueur.Id) then
      Inc(compterNombrePersonnes); 
end;

function professeurValide(var affichage: TAffichage; plateau: TPlateau; joueurActuel: TJoueur; HexagonesCoords: TCoords; var ProfesseurCoords: TCoords; var indexEleve: Integer): Boolean;
var i, j, k, compteur: Integer;
begin
  professeurValide := False;
  indexEleve := -1; 
  setLength(ProfesseurCoords, 3);

  // 1.vérifie si les hexagones sont adjacents et qu'il y a un élève a cet emplacement
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

procedure ChangementProfesseur(var affichage: TAffichage; var plateau: TPlateau; var joueurActuel: TJoueur);
var HexagonesCoords, ProfesseurCoords: TCoords;
  indexEleve: Integer;
  valide: Boolean;
begin
  affichageInformationAndRender('Cliquez sur 3 hexagones entre lesquels vous voulez placer le professeur.', 25, FCouleur(0, 0, 0, 255), affichage);
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

    affichageInformationAndRender('Élève converti en professeur avec succès !', 25, FCouleur(0, 255, 0, 255), affichage);
    
    affichageScoreAndClear(joueurActuel, affichage);
    affichagePlateau(plateau,affichage);
    miseAJourRenderer(affichage);
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

function connexionValide(coords: TCoords; plateau: TPlateau; joueur: TJoueur;var affichage :TAffichage;debut : Boolean): Boolean;
begin
  connexionValide := True;
  attendre(32);

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

  if(not debut)then
  begin
    // 3.1 Verifie si la connexion est adjacente à une autre connexion ou en contact avec un eleve
    if ((aucuneConnexionAdjacente(coords, plateau, joueur,affichage) and (not enContactConnexionEleve(plateau, coords, joueur)))) then
    begin
      affichageInformation('La connexion doit être adjacente à une autre connexion ou en contact avec un élève ou un professeur.', 25, COULEUR_TEXT_ROUGE, affichage);
      exit(False);
    end;
  end
  else
    // 3.2 Verifie si la connexion est adjacente à un eleve
    if (not enContactConnexionEleve(plateau, coords, joueur)) then
    begin
      affichageInformation('La connexion doit être adjacente à un élève.', 25, COULEUR_TEXT_ROUGE, affichage);
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
        affichageInformationAndRender('Veuillez jouer dans le plateau.', 25, COULEUR_TEXT_ROUGE, affichage);
        jouerSonValide(affichage,false);
      end;
    until valide;
    attendre(32);
    affichageHexagone(plateau,affichage, clicConnexion[i],true);
    miseAJourRenderer(affichage);
    attendre(32);
  end;
end;

procedure placementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur;debut : Boolean);
var coords: TCoords;
  valide : boolean;
begin
  attendre(32);
  affichageInformationAndRender('Cliquez sur 2 hexagones entre lesquels vous voulez placer la connexion', 25, FCouleur(0,0,0,255), affichage);
  attendre(50);
  repeat
  attendre(32);
    if(debut)then
      placeFauxConnexionAutourJoueur(affichage,plateau,joueur.id);
    coords := clicConnexion(affichage,plateau);
    valide := connexionValide(coords, plateau, joueur,affichage,debut);
    jouerSonValide(affichage,valide);
    if(not valide)then
    begin
      affichagePlateau(plateau,affichage);
      if(not debut)then
        resteEmplacementConnexion(affichage,plateau,joueur);
      miseAJourRenderer(affichage);
    end;
  until valide;

  SetLength(plateau.Connexions, Length(plateau.Connexions) + 1);
  plateau.Connexions[length(plateau.Connexions)-1].IdJoueur := joueur.Id;

  setLength(plateau.Connexions[length(plateau.Connexions)-1].Position,2);

  plateau.Connexions[length(plateau.Connexions)-1].Position[0] := coords[0];
  plateau.Connexions[length(plateau.Connexions)-1].Position[1] := coords[1];

  affichageScoreAndClear(joueur, affichage);
  affichagePlateau(plateau,affichage);
  affichageInformationAndRender('Connexion placée avec succès !', 25, COULEUR_TEXT_VERT, affichage);
  attendre(50);
end;


function enContactEleveConnexion( plateau: TPlateau; eleve: TCoords; var joueur: TJoueur): Boolean;
var i, k, j : Integer;
begin
  for i := 0 to length(plateau.Connexions) -1 do
    if plateau.Connexions[i].IdJoueur = joueur.Id then
      for k := 0 to 1 do
        for j := k+1 to 2 do
          if(CoordsEgales(plateau.Connexions[i].Position,[eleve[j],eleve[k]])) then
            exit(True);
  enContactEleveConnexion := False;
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

function enContactAutreEleveConnexion(plateau:TPlateau ;connexion: TCoords; var joueur:TJoueur; var affichage : TAffichage):Boolean;
var i, k, j : Integer;
begin
  for i := 0 to length(plateau.Personnes) -1 do
    if plateau.Personnes[i].IdJoueur = joueur.Id then
      for k := 0 to 1 do
        for j := k+1 to 2 do
          if(CoordsEgales(connexion,[plateau.Personnes[i].Position[j],plateau.Personnes[i].Position[k]])) then
            exit(True);
   enContactAutreEleveConnexion := False;
end;



procedure deplacementSouillard(var plateau : TPlateau;var joueurs : TJoueurs ;var affichage : TAffichage);
var coord : Tcoord;
  valide : Boolean;
begin
   affichageInformationAndRender('Cliquez sur 1 hexagones pour déplacer le souillard.', 25, FCouleur(0,0,0,255), affichage);

  repeat
    clicHexagone(affichage, coord);
    valide := dansLaGrille(plateau,coord);
    jouerSonValide(affichage,valide);
  until (valide);

  plateau.Souillard.Position := coord;
  
  affichagePlateau(plateau,affichage);
  attendre(16);

  affichageInformationAndRender('Souillard déplacé avec succès !', 25, COULEUR_TEXT_VERT, affichage);
end;

function resteEleve(var affichage : TAffichage;plateau: TPlateau; joueur: TJoueur): Boolean;
var i: Integer;
begin
  resteEleve := False;
  for i := 0 to length(plateau.Personnes) -1 do
    if (plateau.Personnes[i].IdJoueur = joueur.Id) and (plateau.Personnes[i].estEleve) then
    begin
      placeFauxPersonne(affichage, plateau.Personnes[i].position,joueur.Id,false);
      resteEleve := True;
    end;
  miseAJourRenderer(affichage);
end;

procedure placeFauxConnexion(var affichage : TAffichage;coord1 : Tcoord;coord2 : Tcoord; id : Integer);
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

procedure placeFauxPersonne(var affichage : TAffichage;coords : Tcoords; id : Integer;eleve : Boolean);
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

function enContactConnexionEleve( plateau: TPlateau; connexion: TCoords; var joueur: TJoueur): Boolean;
var i, k, j : Integer;
begin
  for i := 0 to length(plateau.Personnes) -1 do
    if plateau.Personnes[i].IdJoueur = joueur.Id then
      for k := 0 to 1 do
        for j := k+1 to 2 do
          if(CoordsEgales(connexion,[plateau.Personnes[i].Position[j],plateau.Personnes[i].Position[k]])) then
            exit(True);
   enContactConnexionEleve := False;
end;

procedure utiliserCarte1(var affichage : TAffichage;var plateau : TPlateau; joueurs : Tjoueurs;id : Integer);
begin
  placementConnexion(plateau,affichage,joueurs[id],false);
  attendre(16);
  if (resteEmplacementConnexion(affichage,plateau,joueurs[id]))then
  begin
    attendre(16);
    placementConnexion(plateau,affichage,joueurs[id],false);
  end
  else
  begin
    attendre(16);
    affichageInformationAndRender('Vous n''avez plus d''emplacement pour placer la deuxième connexion.',25,COULEUR_TEXT_ROUGE,affichage);
  end;
end;

procedure utiliserCarte2(var affichage : TAffichage;var plateau : TPlateau;joueurs : Tjoueurs; id : Integer);
begin
  deplacementSouillard(plateau,joueurs,affichage);
  affichageInformationAndRender(joueurs[id].nom + ' viens de déplacer le souillard.',25,FCouleur(0,0,0,255),affichage);
end;

procedure utiliserCarte3(var affichage: TAffichage; var plateau : TPlateau; joueurs : Tjoueurs; id : Integer);
var ressource : TRessource;
  idJoueurAVoler : Integer;
begin
  if(id< length(joueurs)-1) then
    idJoueurAVoler := id + 1
  else
    idJoueurAVoler := 0;

  selectionDepouiller(ressource,id,idJoueurAVoler,joueurs,affichage,'Sélectionnez la ressource et le joueur à dépouiller');
  
  if(ressource <> Rien) then
  begin
    joueurs[id].ressources[ressource] := joueurs[id].ressources[ressource] + joueurs[idJoueurAVoler].ressources[ressource];
    joueurs[idJoueurAVoler].ressources[ressource] := 0;
  end;
    
  affichageTour(plateau, joueurs, id, affichage);
  jouerSonValide(affichage, true);
  attendre(50);
  affichageInformationAndRender(joueurs[id].Nom +  ' viens de gagner toutes les ressources du type '+ GetEnumName(TypeInfo(TRessource), Ord(ressource)) +' de '+joueurs[idJoueurAVoler].Nom + '.' ,25,COULEUR_TEXT_VERT,affichage);
end;

procedure utiliserCarte4(var affichage : TAffichage;var plateau : TPlateau; var joueurs : Tjoueurs;id : Integer);
var ressource : TRessource;
begin
  selectionRessource(affichage,ressource,'Sélectionnez la ressource que vous souhaitez récupérer 2 fois',joueurs);
  joueurs[id].ressources[ressource] := joueurs[id].ressources[ressource] + 2;

  affichageTour(plateau, joueurs, Id, affichage);
  jouerSonValide(affichage, true);
  attendre(50);
  affichageInformationAndRender(joueurs[id].Nom +  ' viens de gagner 2 : ' +GetEnumName(TypeInfo(TRessource), Ord(ressource)) + '.',25,COULEUR_TEXT_VERT,affichage);
end;

procedure utiliserCarte5(var affichage : TAffichage;var joueurs : TJoueurs;id :Integer);
begin
  joueurs[id].Points := joueurs[id].Points + 1;
  affichageInformation(joueurs[id].Nom +  ' viens de gagner 1 point de victoire.',25,COULEUR_TEXT_VERT,affichage);
end;

procedure utiliserCarteTutorat(var affichage : TAffichage;var plateau : TPlateau;var joueurs : TJoueurs;id : Integer;nom : String);
var i : Integer;
begin
  for i := 0 to length(plateau.cartesTutorat) -1 do
    if (nom = plateau.cartesTutorat[i].nom) then
      break;
  if (joueurs[id].CartesTutorat[i].utilisee < joueurs[id].CartesTutorat[i].nbr) then
  begin
    case i of
      0:
      begin
        if(resteEmplacementConnexion(affichage,plateau,joueurs[id]))then
          utiliserCarte1(affichage, plateau, joueurs, id)
        else
          exit;
      end;
      1: utiliserCarte2(affichage, plateau, joueurs, id);
      2: utiliserCarte3(affichage, plateau, joueurs, id);
      3: utiliserCarte4(affichage, plateau, joueurs, id);
      4: utiliserCarte5(affichage,joueurs, id);
    end;

    attendre(50);
    joueurs[id].CartesTutorat[i].utilisee := joueurs[id].CartesTutorat[i].utilisee + 1;

    affichageScoreAndClear(joueurs[id],affichage);
    affichageCartesTutoratAndRender(joueurs[id],affichage);
    attendre(16);
  end
  else
  begin
    jouerSonValide(affichage,false);
    affichageInformationAndRender('Vous avez déjà utilisé toutes vos cartes de ce type.',25,COULEUR_TEXT_ROUGE,affichage);
  end;
end;
end.