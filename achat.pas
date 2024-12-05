unit achat;

interface

uses
  Types, affichageUnit,traitement,sysutils,musique;

function dansLePlateau(plateau : TPlateau; coord : Tcoord): boolean;
function CoordsEgales(coords1: TCoords; coords2: TCoords): Boolean;
procedure deplacementSouillard(var plateau : TPlateau; var joueurs : TJoueurs ;var affichage : TAffichage);
function aLesRessources(joueur : Tjoueur; ressources : TRessources):boolean;
procedure enleverRessources( var joueur : Tjoueur; ressources : TRessources);
procedure placementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur);
procedure PlacementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur);
procedure affichageGagnant(joueur: TJoueur; affichage: TAffichage);
procedure achatElements(var joueur: TJoueur; var plateau: TPlateau; var affichage: TAffichage; choix : Integer);
procedure verificationPointsVictoire(plateau : TPlateau; joueurs: TJoueurs; var gagner: Boolean; var gagnant: Integer;var affichage : TAffichage);
procedure ChangementProfesseur(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);


implementation
procedure placeFauxEleve(affichage : TAffichage;plateau : TPlateau;coords : Tcoords;id : Integer);forward;
procedure placeFauxConnexion(affichage : TAffichage;plateau : TPlateau;coord1 : Tcoord;coord2 : Tcoord; id : Integer);forward;
procedure placeFauxProfesseur(affichage : TAffichage;plateau : TPlateau;coords : Tcoords; id : Integer);forward;

function connexionExisteDeja(plateau: TPlateau; coord1: TCoord; coord2: TCoord): Boolean;forward;

procedure trouver3EmeHexagone(plateau : TPlateau;coords1: TCoords; coords2: TCoords;i : Integer);forward;

procedure ClicConnexion(plateau : TPlateau;affichage : TAffichage;var coords : TCoords);forward;
function connexionValide(coords: TCoords; plateau: TPlateau; joueur: TJoueur;var affichage : TAffichage): Boolean;forward;
function ClicPersonne(affichage: TAffichage; plateau: TPlateau; estEleve: Boolean): TCoords;forward;
function CountPersonnes(personnes:TPersonnes; estEleve: Boolean; joueur: TJoueur): Integer;forward;
function professeurValide(affichage: TAffichage; plateau: TPlateau; joueurActuel: TJoueur; HexagonesCoords: TCoords; var ProfesseurCoords: TCoords; var indexEleve: Integer): Boolean;forward;
function PersonneValide(plateau: TPlateau; HexagonesCoords: TCoords; estEleve: Boolean; joueurActuel: TJoueur;affichage : TAffichage): Boolean;forward;
function VerifierAdjacencePersonnes(HexagonesCoords: TCoords; plateau: TPlateau): Boolean;forward;
function enContactEleveConnexion( plateau: TPlateau; coords: TCoords; var joueur: TJoueur): Boolean;forward;
function enContactConnexionEleve( plateau: TPlateau; coords: TCoords; var joueur: TJoueur): Boolean;forward;

function aucuneConnexionAdjacente(coords: TCoords;  plateau: TPlateau; joueur: TJoueur; var affichage : TAffichage): Boolean;forward;
function enContactAutreEleveConnexion(plateau:TPlateau ;coords: TCoords; var joueur:TJoueur; var affichage : TAffichage):Boolean;forward;
function enContactConnexionConnexion(coords1: TCoords; coords2: TCoords): Boolean;forward;
function resteEleve(affichage : TAffichage;plateau:TPlateau; joueur:Tjoueur): Boolean;forward;
function resteEmplacementEleve(affichage : TAffichage;plateau: TPlateau; joueur: TJoueur): Boolean;forward;
function resteEmplacementConnexion(affichage : TAffichage;plateau: TPlateau; joueur: TJoueur): Boolean;forward;

function enContactEleveConnexions(plateau: TPlateau; eleve: TPersonne; var joueur: TJoueur): TCoords;forward;
function compterConnexionSuite(plateau: TPlateau; joueur: TJoueur): Integer;forward;
function adjacence3Connexions(coords: TCoords; plateau: TPlateau; joueur: TJoueur; var affichage : TAffichage): Boolean;forward;
function encontactAutreconnexionEleve(plateau: TPlateau;Eleve:Tcoords; var joueur:Tjoueur): Boolean;forward;
procedure tirerCarteTutorat(var cartesTutorat : TCartesTutorat;var  joueur : Tjoueur);forward;


procedure clicHexagoneValide(var plateau: TPlateau; var affichage: TAffichage; var coord: Tcoord);
var valide : boolean;
begin
    repeat
        clicHexagone(plateau, affichage, coord);
        valide := dansLePlateau(plateau,coord);
        jouerSonValide(affichage,valide);
    until valide;

end;

procedure tirerCarteTutorat(var cartesTutorat : TCartesTutorat;var  joueur : Tjoueur);
var  i,j,nbrTotal,min,max: Integer;
begin
  Randomize();


  nbrTotal :=0;
  for i := 0 to 4 do
    nbrTotal :=nbrTotal  + cartesTutorat[i].nbr;
    
  if nbrTotal = 0 then
  begin
    Exit;
  end;

  i := Random(nbrTotal) + 1;
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
var i : Integer;
begin
  case choix of
   // ELEVE
    1:
      if(resteEmplacementEleve(affichage,plateau,joueur))then
        if(aLesRessources(joueur,COUT_ELEVE)) then
          begin
          jouerSonClicAction(affichage);
          enleverRessources(joueur,COUT_ELEVE);
          PlacementEleve(plateau, affichage, joueur);
          end
        else
          begin
          affichageInformation('Vous n''avez pas les ressources necessaires pour acheter un eleve.', 25, FCouleur(0,0,0,255), affichage);
          jouerSonValide(affichage,false);
          end
      else
        begin
        affichageInformation('Vous n''avez pas d''emplacement pour mettre un élève.', 25, FCouleur(255,0,0,255), affichage);
        jouerSonValide(affichage,false);
        end;

    // CONNEXION
    2:
      if(resteEmplacementConnexion(affichage,plateau,joueur))then
        if(aLesRessources(joueur,COUT_CONNEXION)) then
          begin
          jouerSonClicAction(affichage);
          enleverRessources(joueur,COUT_CONNEXION);
          placementConnexion(plateau, affichage, joueur);
          
        end
        else
          begin
            affichageInformation('Vous n''avez pas les ressources necessaires pour acheter une connexion.', 25, FCouleur(0,0,0,255), affichage);
            jouerSonValide(affichage,false);
          end
      else
        begin
        affichageInformation('Vous n''avez pas d''emplacement pour mettre une connexion.', 25, FCouleur(255,0,0,255), affichage);
        jouerSonValide(affichage,false);
        end;
    

    // PROFESSEUR
    3: 
      if(resteEleve(affichage,plateau,joueur))then
        if(aLesRessources(joueur,COUT_PROFESSEUR)) then
          begin

      

          jouerSonClicAction(affichage);
          enleverRessources(joueur,COUT_PROFESSEUR);

          changementProfesseur(plateau, affichage, joueur);
          
          end
        else
          begin
            affichageInformation('Vous n''avez pas les ressources necessaires pour changer un eleve en professeur.', 25, FCouleur(0,0,0,255), affichage);
            jouerSonValide(affichage,false);
          end
      else
        begin
        affichageInformation('Vous n''avez plus d''élève à modifier.', 25, FCouleur(255,0,0,255), affichage);
        jouerSonValide(affichage,false);
        end;

    // carte de tutorat
    4:
    //  verif ressource
    if(plateau.cartesTutorat[0].nbr + plateau.cartesTutorat[1].nbr + plateau.cartesTutorat[2].nbr + plateau.cartesTutorat[3].nbr + plateau.cartesTutorat[4].nbr >0) then
    begin
      if(aLesRessources(joueur,COUT_CARTE_TUTORAT)) then
        begin
        jouerSonClicAction(affichage);
        tirerCarteTutorat(plateau.CartesTutorat, joueur);

        enleverRessources(joueur,COUT_CARTE_TUTORAT);

        affichageCartesTutorat(joueur,affichage);
        affichageScoreAndClear(joueur,affichage);
        miseAJourRenderer(affichage);
        end;
    end
    else
    begin
      affichageInformation('Impossible d''acheter une carte de tutorat.', 25, FCouleur(255,0,0,255), affichage);
      jouerSonValide(affichage,false);
    end;
  end;
end;


function dansLePlateau(plateau : TPlateau; coord : Tcoord): boolean;
var taille : Integer;
begin
  
  dansLePlateau := True;
  taille := length(plateau.Grille)- 2;


  if(coord.x <= 0) then
    dansLePlateau := False;
  if(coord.x > taille) then
    dansLePlateau := False;
  if(coord.y <= 0) then
    dansLePlateau := False;
  if(coord.y > taille) then
    dansLePlateau := False;

  if(coord.x <= taille div 2) then
    begin
    if ((coord.y > taille) or (coord.y <=taille div 2 +1- coord.x)) then 
      dansLePlateau := False;
    end;
  
  if(coord.x > taille div 2 +1) then
    begin
    if ((coord.y >  taille - coord.x  + taille div 2 +1) or (coord.y <=0)) then 
      dansLePlateau := False;
    end;

end;

procedure placementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur);
var HexagonesCoords: TCoords;
  valide : Boolean;
  i : Integer;
begin

  repeat
    HexagonesCoords := ClicPersonne(affichage,plateau,True);
    valide := PersonneValide(plateau, HexagonesCoords, True, joueur,affichage);
    jouerSonValide(affichage,valide);
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

  affichageInformation('Eleve place avec succes !', 25, FCouleur(0,255,0,255), affichage);

  affichageScoreAndClear(joueur, affichage);
  affichagePlateau(plateau,affichage);
  miseAJourRenderer(affichage);
end;





function PersonneValide(plateau: TPlateau; HexagonesCoords: TCoords; estEleve: Boolean; joueurActuel: TJoueur;affichage : TAffichage): Boolean;
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
    // TODO verifier le contact avec une connexion du joueur
    if not enContactEleveConnexion(plateau,HexagonesCoords,joueurActuel) then
    begin
      writeln('pas en contact avec une connexion');
      PersonneValide:=false;
      exit;
    end;

    if  VerifierAdjacencePersonnes(HexagonesCoords,plateau) then
    begin
        writeln('VerifierAdjacencePersonnes');
        PersonneValide := False;
        exit;
    end
    else
        personneAdjacente := True;

  // 4. Vérifie si au moins 1 des hexagones est dans le plateau
  if (( not dansLePlateau(plateau,HexagonesCoords[0]) and not dansLePlateau(plateau,HexagonesCoords[1]) and not dansLePlateau(plateau,HexagonesCoords[2]) )
      ) then 
    begin
    PersonneValide:= False;      

    jouerSonValide(affichage,false);
    affichageInformation('Au moins 1 des hexagones choisis doit etre dans le plateau', 25, FCouleur(0,0,0,255), affichage);

    
    Exit;
    end; 
  if encontactAutreconnexionEleve(plateau,HexagonesCoords,joueurActuel) then
  begin
    PersonneValide:=False;
    exit;
  end;
  PersonneValide := personneAdjacente;

end;


function ClicPersonne(affichage: TAffichage; plateau: TPlateau; estEleve: Boolean): TCoords;
var
  i: Integer;
  HexagonesCoords: TCoords;
 
begin
  SetLength(HexagonesCoords,3);
  if estEleve then
    affichageInformation('Cliquez sur trois hexagones entre lesquels vous voulez placer l''eleve', 25, FCouleur(0,0,0,255), affichage)
  else
    affichageInformation('Cliquez sur trois hexagones entre lesquels vous voulez placer le professeur', 25, FCouleur(0,0,0,255), affichage);
  for i := 0 to 2 do
  begin
    clicHexagone(plateau, affichage, HexagonesCoords[i]); 
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





function CountPersonnes(personnes: TPersonnes; estEleve: Boolean; joueur: TJoueur): Integer;
var
  i,Result: Integer;

begin
  Result := 0; 
  for i := 0 to High(personnes)-1 do
  begin
    if (personnes[i].estEleve = estEleve) and (personnes[i].IdJoueur = joueur.Id) then
      Inc(Result); 
  end;
  CountPersonnes:= Result;
end;

function professeurValide(affichage: TAffichage; plateau: TPlateau; joueurActuel: TJoueur; HexagonesCoords: TCoords; var ProfesseurCoords: TCoords; var indexEleve: Integer): Boolean;
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
        end;
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
  indexEleve, nbProfesseurs, i: Integer;
  valide: Boolean;
begin
  
  // TODO faire avant ici le joueur a deja payer
  // nbProfesseurs := CountPersonnes(plateau.Personnes,false,joueurActuel);
  // if nbProfesseurs > 4 then
  // begin
  //   affichageInformation('Vous avez déjà atteint la limite de 4 professeurs.', 25, FCouleur(255, 0, 0, 255), affichage);
  //   Exit;
  // end;
  repeat
    // ne pas reaficher a chaque fois pour avoir les erreur
    // affichageInformation('Cliquez sur 3 hexagones entre lesquels vous voulez placer le professeur.', 25, FCouleur(0, 0, 0, 255), affichage);
    HexagonesCoords := ClicPersonne(affichage, plateau, False);
    valide := professeurValide(affichage, plateau, joueurActuel, HexagonesCoords, ProfesseurCoords, indexEleve);
  until valide;
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



function compterConnexionSuite(plateau: TPlateau; joueur: TJoueur): Integer;
var
  i, j, k, l: Integer;
  connexionsEleve: TCoords; 
  maxRoute, routeActuelle: Integer;
  connexionCourante: TCoords;
  dejaVisite: array of Boolean;
// TODO ne marche pas dutout
// méthode a revoir ...
begin
  maxRoute := 0;
  setLength (connexionCourante,2);
  SetLength(dejaVisite, Length(plateau.Connexions));
  for i := 0 to High(dejaVisite) do
    dejaVisite[i] := False;
  for i := 0 to High(plateau.Personnes) do
  begin
    if plateau.Personnes[i].IdJoueur = joueur.Id then
    begin
      connexionsEleve := enContactEleveConnexions(plateau, plateau.Personnes[i],joueur);
      for j := 0 to High(connexionsEleve) do
      begin
        routeActuelle := 1;
        connexionCourante[0]:= connexionsEleve[j];
        connexionCourante[1]:= connexionsEleve[j+1];
        while True do
        begin
          l := -1;
          for k := 0 to High(plateau.Connexions) do
          begin
            if (plateau.Connexions[k].IdJoueur = joueur.Id) and
               not dejaVisite[k] and
               enContactConnexionConnexion( connexionCourante, plateau.Connexions[k].Position) and
               not CoordsEgales(connexionCourante, plateau.Connexions[k].Position) then
            begin
              l := k; 
              Break;
            end;
          end;

          if l = -1 then
            Break;

          dejaVisite[l] := True;
          // TODO NE SURTOUT PAS METTRE ça CA CASSE TOUT CAR CA PASSE UN POINTEUR
          // connexionCourante := plateau.Connexions[l].Position;
          connexionCourante[0] := plateau.Connexions[l].Position[0];
          connexionCourante[1] := plateau.Connexions[l].Position[1];


          Inc(routeActuelle);
        end;

        if routeActuelle > maxRoute then
          maxRoute := routeActuelle;
      end;
    end;
  end;

  compterConnexionSuite := maxRoute;
end;



procedure verificationPointsVictoire(plateau : TPlateau; joueurs: TJoueurs; var gagner: Boolean; var gagnant: Integer;var affichage : TAffichage);
var
  joueur : TJoueur;
  plusGrandeRoute,plusDeplacementSouillard : Boolean;
  i,j : Integer;
  points : array of Integer;

begin
  gagner := False; 
  gagnant := -1;    

  SetLength(points,Length(joueurs));
  j:=0;
  for joueur in joueurs do
  begin

    points[j] := joueur.points;
    
    
    plusGrandeRoute := True;

    //writeln('compterConnexionSuite(plateau,joueur) : ',compterConnexionSuite(plateau,joueur));
    //writeln('joueur : ',joueur.nom);

    if (compterConnexionSuite(plateau,joueur) >= 5) then
    begin
    for i := 0 to High(joueurs) do
      if(compterConnexionSuite(plateau,joueur) < compterConnexionSuite(plateau,joueurs[i])) then
        plusGrandeRoute := False;
    if plusGrandeRoute then
      points[j] := points[j] + 2;
    end;
    

    if(joueur.CartesTutorat[0].utilisee >= 3) then
      for i := 0 to High(joueurs) do
        if(joueur.CartesTutorat[0].utilisee < joueurs[i].CartesTutorat[0].utilisee) then
          plusDeplacementSouillard := False;
    if(plusDeplacementSouillard) then
      points[j] := points[j] + 2;
    
    if points[j] >= 10 then
    begin

      gagner := True;
      gagnant := j+1; 
      affichageInformation(joueur.Nom + 'viens de gagner la partie en depassant les 10 points', 25, FCouleur(0,0,0,255), affichage);

      Break;
    end;

    j := j+1;

  end;


end;


procedure affichageGagnant(joueur: TJoueur; affichage: TAffichage);
var text : String;
begin
  text := ('Felicitations, ' + joueur.Nom + ' ! Vous avez gagne la partie avec ' + intToStr(joueur.Points) + ' points.');
  affichageInformation(text, 25, FCouleur(0,0,0,255), affichage);
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
  i: Integer;
  enContactAvecAutreConnexion, enContactAvecPersonne: Boolean;
begin
  // Initialisation
  connexionValide := True;
  enContactAvecAutreConnexion := False;
  // enContactAvecPersonne := False;


  // 1. Verifie si une connexion existe dejà avec les mêmes coordonnees (independamment de l'ordre)
  if(connexionExisteDeja(plateau, coords[0],coords[1]))then
    begin
      connexionValide := False;
      affichageInformation('Position de connexion deja occupee.', 25, FCouleur(0,0,0,255), affichage);
      Exit;
    end;
  // end;

  // 2. Verifie si les deux hexagones sont adjacents
  if not enContact(coords) then
  begin
    connexionValide := False;
    affichageInformation('Les deux hexagones ne sont pas adjacents.', 25, FCouleur(0,0,0,255), affichage);

    Exit;
  end;
    enContactAvecPersonne := enContactConnexionEleve(plateau, coords, joueur);
    enContactAvecAutreConnexion := not aucuneConnexionAdjacente(coords, plateau, joueur,affichage);

  // 3. Verifie si en contact avec un eleve ou une connexion
  // if enContactAutreEleveConnexion(plateau,coords,joueur,affichage)  or adjacence3Connexions(coords,plateau,joueur,affichage) then 
  // begin
  //   connexionValide:= False;
  //   exit;
  // end;
    // TODO pose probleme de acces violation au  placement de connexion du deuxieme joeuur apres un placement du premier joueur
  if not enContactAvecPersonne then
  begin
    if  not enContactAvecAutreConnexion then
    begin
      connexionValide := False;
      affichageInformation('La connexion doit etre adjacente a une autre connexion ou en contact avec un eleve ou un professeur.', 25, FCouleur(0,0,0,255), affichage);
      Exit;
    end;
  end;

  // 4. Verifie si au moins 1 des hexagones est dans le plateau
  if (not dansLePlateau(plateau,coords[0]) and not dansLePlateau(plateau,coords[1])) then 
    begin
    connexionValide:= False;      
    affichageInformation('Au moins 1 des hexagones choisis doit etre dans le plateau', 25, FCouleur(0,0,0,255), affichage);

    Exit;
    end; 
end;




procedure ClicConnexion(plateau : TPlateau; affichage : TAffichage;var coords : TCoords);
begin

  SetLength(coords, 2);
  clicHexagone(plateau, affichage,coords[0]);
  clicHexagone(plateau, affichage,coords[1]);

end;

procedure placementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur);
var
  coords: TCoords;
  i : Integer;
  valide : boolean;
begin
  affichageInformation('Cliquez sur 2 hexagones entre lesquels vous voulez placer la connexion', 25, FCouleur(0,0,0,255), affichage);

  repeat
    ClicConnexion(plateau,affichage,coords);
    valide := connexionValide(coords, plateau, joueur,affichage);
    jouerSonValide(affichage,valide);
  until valide;


  SetLength(plateau.Connexions, Length(plateau.Connexions) + 1);
  plateau.Connexions[length(plateau.Connexions)-1].IdJoueur := joueur.Id;

  setLength(plateau.Connexions[length(plateau.Connexions)-1].Position,2);

  plateau.Connexions[length(plateau.Connexions)-1].Position[0] := coords[0];
  plateau.Connexions[length(plateau.Connexions)-1].Position[1] := coords[1];

  affichageInformation('Connexion placee avec succes !', 25, FCouleur(0,255,0,255), affichage);

  affichageScoreAndClear(joueur, affichage);
  affichagePlateau(plateau,affichage);
  miseAJourRenderer(affichage);
end;


function enContactEleveConnexion( plateau: TPlateau; coords: TCoords; var joueur: TJoueur): Boolean;
var
  i, k, l: Integer;
  // TODO ne marchais pas
  // TU VERIFIAIS DES ELEVES AVEC LES AUTRES ELEVES ET CA NA PAS DE SENS
  // coords est l'eleve
  // plateau.Connexions est les connexions
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
var
  i, j,k: Integer;
  autreCoord, autreCoord2, coord1, coord2, coordRestante: TCoord;
  verif: Boolean;
begin
// TODO NE MARCHE PAS REGARDER POURQUOI VORI FONCTION D'AVANT

  verif := true;

  for i := 0 to High(plateau.Connexions) do
  begin
    if plateau.Connexions[i].IdJoueur = joueur.Id then
    begin
      coord1 := plateau.Connexions[i].Position[0];
      coord2 := plateau.Connexions[i].Position[1];

      if (coords[0].x = coord1.x) and (coords[0].y = coord1.y) then
      begin
        autreCoord := coords[1];
        autreCoord2 := coords[0];
        coordRestante := coord2;
      end
      else if (coords[1].x = coord1.x) and (coords[1].y = coord1.y) then
      begin
        autreCoord := coords[0];
        autreCoord2 := coords[1];
        coordRestante := coord2;
      end
      else if (coords[0].x = coord2.x) and (coords[0].y = coord2.y) then
      begin
        autreCoord := coords[1];
        autreCoord2 := coords[0];
        coordRestante := coord1;
      end
      else if (coords[1].x = coord2.x) and (coords[1].y = coord2.y) then
      begin
        autreCoord := coords[0];
        autreCoord2 := coords[1];
        coordRestante := coord1;
      end;

      if sontAdjacents(autreCoord, coordRestante) then
      begin
        verif := False;

      end;
    end;
  end;
    aucuneConnexionAdjacente := verif;
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
          affichageInformation('Connexion en contact avec une personne dune autre joueur.', 25, FCouleur(0,0,0,255), affichage);

          Exit;
        end;
      end;
    end;
  end;
end;


procedure deplacementSouillard(var plateau : TPlateau;var joueurs : TJoueurs ;var affichage : TAffichage);
var coord : Tcoord;
  i : Integer;
begin
  affichageInformation('Cliquez sur 1 hexagones pour deplacer le souillard.', 25, FCouleur(0,0,0,255), affichage);

  repeat
    clicHexagone(plateau, affichage, coord);
  until (dansLePlateau(plateau,coord));

  plateau.Souillard.Position := coord;
  
  affichagePlateau(plateau,affichage);
  attendre(16);

  affichageInformation('Souillard deplace avec succes !', 25, FCouleur(0,255,0,255), affichage);
end;
function enContactConnexionConnexion( coords1: TCoords; coords2: TCoords): Boolean;
var
  Coord, autreCoord1, autreCoord2: TCoord;
begin
  enContactConnexionConnexion := False;

  if (coords1[0].x = coords2[0].x) and (coords1[0].y = coords2[0].y) then
  begin
    Coord := coords1[0];
    autreCoord1 := coords1[1];
    autreCoord2 := coords2[1];
  end
  else if (coords1[0].x = coords2[1].x) and (coords1[0].y = coords2[1].y) then
  begin
    Coord := coords1[0];
    autreCoord1 := coords1[1];
    autreCoord2 := coords2[0];
  end
  else if (coords1[1].x = coords2[0].x) and (coords1[1].y = coords2[0].y) then
  begin
    Coord := coords1[1];
    autreCoord1 := coords1[0];
    autreCoord2 := coords2[1];
  end
  else if (coords1[1].x = coords2[1].x) and (coords1[1].y = coords2[1].y) then
  begin
    Coord := coords1[1];
    autreCoord1 := coords1[0];
    autreCoord2 := coords2[0];
  end
  else
    Exit;
  if sontAdjacents(autreCoord1, autreCoord2) then
    enContactConnexionConnexion := True;
end;



function CoordsEgales(coords1: TCoords; coords2: TCoords): Boolean;
begin
  CoordsEgales := False;

  if ((coords1[0].x = coords2[0].x) and (coords1[0].y = coords2[0].y) and
      (coords1[1].x = coords2[1].x) and (coords1[1].y = coords2[1].y)) or
     ((coords1[0].x = coords2[1].x) and (coords1[0].y = coords2[1].y) and
      (coords1[1].x = coords2[0].x) and (coords1[1].y = coords2[0].y)) then
  begin
    CoordsEgales := True;
  end;
end;

function enContactConnexions(plateau: TPlateau; coords: TCoords; joueur: TJoueur): Boolean;
var
  i: Integer;
  coord1, coord2, autreCoord, autreCoord2: TCoord;
  connexionTrouvee: Boolean;
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

function resteEleve(affichage : TAffichage;plateau: TPlateau; joueur: TJoueur): Boolean;
var i: Integer;
begin
resteEleve := False;
for i := 0 to High(plateau.Personnes) do
begin
  if (plateau.Personnes[i].IdJoueur = joueur.Id) and (plateau.Personnes[i].estEleve) then
  begin
    placeFauxProfesseur(affichage,plateau, plateau.Personnes[i].position,joueur.Id);
    resteEleve := True;
  end;
end;
miseAJourRenderer(affichage);
end;

procedure placeFauxConnexion(affichage : TAffichage;plateau : TPlateau;coord1 : Tcoord;coord2 : Tcoord; id : Integer);
begin
SetLength(plateau.Connexions, Length(plateau.Connexions) + 1);

with plateau.Connexions[High(plateau.Connexions)] do
  begin
  SetLength(Position, 2);
  Position[0] := coord1;
  Position[1] := coord2;

  IdJoueur := -id-1;
  end;
affichageConnexion(plateau.Connexions[High(plateau.Connexions)], affichage);
end;

function resteEmplacementConnexion(affichage : TAffichage;plateau: TPlateau; joueur: TJoueur): Boolean;
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

      trouver3EmeHexagone(plateau,coords1,coords2,i);


      if(not connexionExisteDeja(plateau, coords1[0],coords1[2]) 
        and (dansLePlateau(plateau,coords1[0]) or dansLePlateau(plateau,coords1[2])))then
        begin
        placeFauxConnexion(affichage,plateau, coords1[0],coords1[2], joueur.Id);
        resteEmplacementConnexion := True;
        end;
      if(not connexionExisteDeja(plateau, coords1[1],coords1[2])
        and (dansLePlateau(plateau,coords1[1]) or dansLePlateau(plateau,coords1[2])))then
        begin
        placeFauxConnexion(affichage,plateau, coords1[1],coords1[2], joueur.Id);
        resteEmplacementConnexion := True;
        end;
      if(not connexionExisteDeja(plateau, coords2[0],coords2[2])
        and (dansLePlateau(plateau,coords2[0]) or dansLePlateau(plateau,coords2[2])))then
        begin
        placeFauxConnexion(affichage,plateau, coords2[0],coords2[2], joueur.Id);
        resteEmplacementConnexion := True;
        end;
      if(not connexionExisteDeja(plateau, coords2[1],coords2[2])
        and (dansLePlateau(plateau,coords2[1]) or dansLePlateau(plateau,coords2[2])))then
        begin
        placeFauxConnexion(affichage,plateau, coords2[1],coords2[2], joueur.Id);
        resteEmplacementConnexion := True;
        end;

    end;
  end;

  // for i:=0 to length(plateau.connexions)-1 do
  //   affichageConnexion(plateau.connexions[i],affichage);

  for i:=0 to length(plateau.personnes)-1 do
        affichagePersonne(plateau.personnes[i],affichage);

  miseAJourRenderer(affichage);
end;

procedure trouver3EmeHexagone(plateau : TPlateau;coords1: TCoords; coords2: TCoords;i : Integer);
var x1,x2,y1,y2: Integer;
  j : Boolean;
begin
j := false;
// diagonale 1
if(plateau.connexions[i].Position[0].x = plateau.connexions[i].Position[1].x)then
  begin
  x1:=-1; y1:=1;
  x2:=1; y2:=0;
  if(plateau.connexions[i].Position[0].y < plateau.connexions[i].Position[1].y)then
    j:=true;
  end
// horizontale
else if(plateau.connexions[i].Position[0].y = plateau.connexions[i].Position[1].y)then
  begin
  x1:=1; y1:=-1;
  x2:=0; y2:=1;
  if(plateau.connexions[i].Position[0].x < plateau.connexions[i].Position[1].x)then
    j:=true;
  end
// diagonale 2
else
  begin
  x1:=1; y1:=0;
  x2:=0; y2:=-1;
  if(plateau.connexions[i].Position[0].x < plateau.connexions[i].Position[1].x)then
    j:=true;
  end;
if(j)then
  begin
  coords1[2] := FCoord(plateau.connexions[i].Position[0].x+x1,plateau.connexions[i].Position[0].y+y1);
  coords2[2] := FCoord(plateau.connexions[i].Position[0].x+x2,plateau.connexions[i].Position[0].y+y2);
  end
else
  begin
  coords1[2] := FCoord(plateau.connexions[i].Position[1].x+x1,plateau.connexions[i].Position[1].y+y1);
  coords2[2] := FCoord(plateau.connexions[i].Position[1].x+x2,plateau.connexions[i].Position[1].y+y2);
  end;
end;


function resteEmplacementEleve(affichage : TAffichage;plateau: TPlateau; joueur: TJoueur): Boolean;
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

    trouver3EmeHexagone(plateau,coords1,coords2,i);

    if(not VerifierAdjacencePersonnes(coords1,plateau))then
      begin
      placeFauxEleve(affichage, plateau, coords1,joueur.Id);
      resteEmplacementEleve := True;
      end;
    if(not VerifierAdjacencePersonnes(coords2,plateau))then
      begin
      placeFauxEleve(affichage, plateau, coords2,joueur.Id);
      resteEmplacementEleve := True;
      end;
    end;
  end;

  miseAJourRenderer(affichage);
end;



procedure placeFauxEleve(affichage : TAffichage;plateau : TPlateau;coords : Tcoords; id : Integer);
begin

SetLength(plateau.Personnes, Length(plateau.Personnes) + 1);
with plateau.Personnes[High(plateau.Personnes)] do
  begin
  SetLength(Position, 3);
  Position[0] := coords[0];
  Position[1] := coords[1];
  Position[2] := coords[2];

  estEleve := True;
  IdJoueur := -id-1;
  end;
affichagePersonne(plateau.Personnes[High(plateau.Personnes )], affichage);
end;

procedure placeFauxProfesseur(affichage : TAffichage;plateau : TPlateau;coords : Tcoords; id : Integer);
begin

SetLength(plateau.Personnes, Length(plateau.Personnes) + 1);
with plateau.Personnes[High(plateau.Personnes)] do
  begin
  SetLength(Position, 3);
  Position[0] := coords[0];
  Position[1] := coords[1];
  Position[2] := coords[2];

  estEleve := False;
  IdJoueur := -id-1;
  end;
affichagePersonne(plateau.Personnes[High(plateau.Personnes )], affichage);
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