unit achat;

interface

uses
  Types, affichageUnit,traitement,sysutils;

procedure ChangementProfesseur(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
procedure achatElements(var joueur: TJoueur; var plateau: TPlateau; var affichage: TAffichage; choix : Integer);
procedure PlacementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
procedure placementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur);
procedure verificationPointsVictoire(plateau : TPlateau; joueurs: TJoueurs; var gagner: Boolean; var gagnant: Integer;var affichage : TAffichage);
procedure affichageGagnant(joueur: TJoueur; affichage: TAffichage);
procedure deplacementSouillard(var plateau : TPlateau; var joueurs : TJoueurs ;var affichage : TAffichage);
function ClicConnexion(var plateau : TPlateau; var affichage : TAffichage): TCoords;
function connexionValide(coords: TCoords; plateau: TPlateau; joueur: TJoueur;var affichage : TAffichage): Boolean;
function ClicPersonne(affichage: TAffichage; plateau: TPlateau; estEleve: Boolean): TCoords;
function CountPersonnes(personnes: array of TPersonne; estEleve: Boolean; joueur: TJoueur): Integer;
function PersonneValide(plateau: TPlateau; HexagonesCoords: TCoords; estEleve: Boolean; joueurActuel: TJoueur;affichage : TAffichage): Boolean;
function VerifierAdjacencePersonnes(HexagonesCoords: TCoords; plateau: TPlateau): Boolean;
function enContactEleveConnexion( plateau: TPlateau; coords: TCoords; var joueur: TJoueur): Boolean;
function aucuneConnexionAdjacente(coords: TCoords;  plateau: TPlateau; joueur: TJoueur; var affichage : TAffichage): Boolean;
function enContactAutreEleveConnexion(plateau:TPlateau ;coords: TCoords; var joueur:TJoueur; var affichage : TAffichage):Boolean;
function dansLePlateau(plateau : TPlateau; coord : Tcoord): boolean;

implementation

procedure tirerCarteTutorat(var cartesTutorat : TCartesTutorat;var  joueur : Tjoueur);
var  i,nbrTotal: Integer;
begin
  Randomize();

  // TODO penser à verif que il en reste avant d'accepter l'achat 
  nbrTotal := cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr + cartesTutorat.carte3.nbr + cartesTutorat.carte4.nbr + cartesTutorat.carte5.nbr;

  i := Random(nbrTotal) + 1;
  if (i >= 1) and (i <= cartesTutorat.carte1.nbr) then
    begin
    joueur.cartesTutorat.carte1.nbr := joueur.cartesTutorat.carte1.nbr +1;
    // carteTutorat.nom := cartesTutorat.carte1.nom;
    // carteTutorat.description := cartesTutorat.carte1.description;
    // carteTutorat.nbr := 1;

    cartesTutorat.carte1.nbr := cartesTutorat.carte1.nbr - 1; 
    end
  else if (i > cartesTutorat.carte1.nbr) and (i <= cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr) then
    begin
    joueur.cartesTutorat.carte2.nbr := joueur.cartesTutorat.carte2.nbr +1;

    // carteTutorat.nom := cartesTutorat.carte2.nom;
    // carteTutorat.description := cartesTutorat.carte2.description;
    // carteTutorat.nbr := 1;

    cartesTutorat.carte2.nbr := cartesTutorat.carte2.nbr - 1; 
    end
  else if (i > cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr) and (i <= cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr + cartesTutorat.carte3.nbr) then
    begin
    joueur.cartesTutorat.carte3.nbr := joueur.cartesTutorat.carte3.nbr +1;

    // carteTutorat.nom := cartesTutorat.carte3.nom;
    // carteTutorat.description := cartesTutorat.carte3.description;
    // carteTutorat.nbr := 1;

    cartesTutorat.carte3.nbr := cartesTutorat.carte3.nbr - 1;
    end
  else if (i > cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr + cartesTutorat.carte3.nbr) and (i <= cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr + cartesTutorat.carte3.nbr + cartesTutorat.carte4.nbr) then
    begin
    joueur.cartesTutorat.carte4.nbr := joueur.cartesTutorat.carte4.nbr +1;

    // carteTutorat.nom := cartesTutorat.carte4.nom;
    // carteTutorat.description := cartesTutorat.carte4.description;
    // carteTutorat.nbr := 1;

    cartesTutorat.carte4.nbr := cartesTutorat.carte4.nbr - 1;
    end
  else
    begin
    joueur.cartesTutorat.carte5.nbr := joueur.cartesTutorat.carte5.nbr +1;

    // carteTutorat.nom := cartesTutorat.carte5.nom;
    // carteTutorat.description := cartesTutorat.carte5.description;
    // carteTutorat.nbr := 1;

    cartesTutorat.carte5.nbr := cartesTutorat.carte5.nbr - 1;
    end;

end;

procedure achatElements(var joueur: TJoueur; var plateau: TPlateau; var affichage: TAffichage; choix : Integer);
begin
  
  case choix of
   // ELEVE
    1: 
     
      if (joueur.Ressources[Mathematiques] >= 1) and 
         (joueur.Ressources[Humanites] >= 1) and 
         (joueur.Ressources[Chimie] >= 1) and 
         (joueur.Ressources[Physique] >= 1) then
      begin
        PlacementEleve(plateau, affichage, joueur);

        joueur.Ressources[Mathematiques] := joueur.Ressources[Mathematiques] - 1;
        joueur.Ressources[Humanites] := joueur.Ressources[Humanites] - 1;
        joueur.Ressources[Chimie] := joueur.Ressources[Chimie] - 1;
        joueur.Ressources[Physique] := joueur.Ressources[Physique] - 1;
      end
      else
        affichageInformation('Vous n''avez pas les ressources necessaires pour acheter un eleve.', 25, FCouleur(0,0,0,255), affichage);

    // CONNEXION
    2: 
     
      if (joueur.Ressources[Humanites] >= 1) and 
         (joueur.Ressources[Physique] >= 1) then
      begin
        placementConnexion(plateau, affichage, joueur);

        joueur.Ressources[Physique] := joueur.Ressources[Physique] - 1;
        joueur.Ressources[Chimie] := joueur.Ressources[Chimie] - 1;
      end
      else
        affichageInformation('Vous n''avez pas les ressources necessaires pour acheter une connexion.', 25, FCouleur(0,0,0,255), affichage);
    
    // PROFESSEUR
    3: 
    
      if (joueur.Ressources[Mathematiques] >= 2) and 
         (joueur.Ressources[Physique] >= 1) then
      begin
        changementProfesseur(plateau, affichage, joueur);
      end
      else
        affichageInformation('Vous n''avez pas les ressources necessaires pour changer un eleve en professeur.', 25, FCouleur(0,0,0,255), affichage);
    // PROFESSEUR
    4:
    //  verif ressource
    if(plateau.cartesTutorat.carte1.nbr + plateau.cartesTutorat.carte2.nbr + plateau.cartesTutorat.carte3.nbr + plateau.cartesTutorat.carte4.nbr + plateau.cartesTutorat.carte5.nbr >=0 )  then //and a les ressources
    begin
        tirerCarteTutorat(plateau.CartesTutorat, joueur);
    end
    else 
        affichageInformation('Impossbile d''acheter une carte de tutorat.', 25, FCouleur(255,0,0,255), affichage);
  else
    WriteLn('Choix invalide.');  // Affiche si le choix n'est pas valide
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




procedure placementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
var
 HexagonesCoords: TCoords;
begin
  
  affichageInformation('Cliquez sur 3 hexagones entre lesquels vous voulez placer l''eleve', 25, FCouleur(0,0,0,255), affichage);

  repeat
    HexagonesCoords := ClicPersonne(affichage,plateau,True); 
  until PersonneValide(plateau, HexagonesCoords, True, joueurActuel,affichage);

  SetLength(plateau.Personnes, Length(plateau.Personnes) + 1);
  with plateau.Personnes[High(plateau.Personnes)] do
  begin
    // Assigner les coordonnees des hexagones selectionnes à l'elève
    SetLength(Position, 3); 
    Position[0] := HexagonesCoords[0];
    Position[1] := HexagonesCoords[1];
    Position[2] := HexagonesCoords[2];

    estEleve := True;
    IdJoueur := joueurActuel.Id;

    // ajout d'un point
    joueurActuel.Points:=1+joueurActuel.Points;

    affichageScore(joueurActuel,affichage);
    affichagePersonne(plateau.Personnes[High(plateau.Personnes )], affichage);
    miseAJourRenderer(affichage);

    
    affichageInformation('Eleve place avec succes !', 25, FCouleur(0,255,0,255), affichage);

    
  end;
end;




function PersonneValide(plateau: TPlateau; HexagonesCoords: TCoords; estEleve: Boolean; joueurActuel: TJoueur;affichage : TAffichage): Boolean;
var
  personneAdjacente: Boolean;
begin
  personneAdjacente := False;
  if not enContact(HexagonesCoords) then
  begin
    PersonneValide := False;
    affichageInformation('Les 3 hexagonnes doivent etre adjacents.', 25, FCouleur(255,0,0,255), affichage);

    Exit;
  end;

  if(joueurActuel.Points > 2 ) then
    // TODO verifier le contact avec une connexion du joueur
    if not enContactEleveConnexion(plateau,HexagonesCoords,joueurActuel) then
    begin
     writeln('Eleve non liee avec une connexion');
     
      affichageInformation('erreur.', 25, FCouleur(255,0,0,255), affichage);

      exit;
    end;

   writeln('placement d''eleve apres le debut de partie');
  // Verifie la presence d'une personne adjacente

    if  VerifierAdjacencePersonnes(HexagonesCoords,plateau) then
    begin
        PersonneValide := False; 
      affichageInformation('Il y a deja un autre eleve/professeur trop proche.', 25, FCouleur(255,0,0,255), affichage);

    end
    else
        personneAdjacente := True; 
   
  
  // 4. Verifie si au moins 1 des hexagones est dans le plateau
  if (( not dansLePlateau(plateau,HexagonesCoords[0]) and not dansLePlateau(plateau,HexagonesCoords[1]) and not dansLePlateau(plateau,HexagonesCoords[2]) )
      ) then 
    begin
    PersonneValide:= False;      

    affichageInformation('Au moins 1 des hexagones choisis doit etre dans le plateau', 25, FCouleur(0,0,0,255), affichage);

    
    Exit;
    end; 

  PersonneValide := personneAdjacente;

end;


function ClicPersonne(affichage: TAffichage; plateau: TPlateau; estEleve: Boolean): TCoords;
var
  i: Integer;
  HexagonesCoords: TCoords;
 
begin
  SetLength(HexagonesCoords,3);
  
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

  // Verification des doublons dans HexagonesCoords
  for i := 0 to High(HexagonesCoords) - 1 do
  begin
    for j := i + 1 to High(HexagonesCoords) do
    begin
      if (HexagonesCoords[i].x = HexagonesCoords[j].x) and 
         (HexagonesCoords[i].y = HexagonesCoords[j].y) then
      begin
        Exit(True); // Il y a des coordonnees identiques
      end;
    end;
  end;

  // Verification de l'adjacence avec les personnes sur le plateau
  for i := 0 to High(plateau.Personnes) do
  begin
    nombreCommuns := 0;

    // Verifier chaque coordonnee dans HexagonesCoords
    for j := 0 to High(HexagonesCoords) do
    begin
      // Comparer avec les trois positions de la personne
      for k := 0 to 2 do
      begin
        if (HexagonesCoords[j].x = plateau.Personnes[i].Position[k].x) and
           (HexagonesCoords[j].y = plateau.Personnes[i].Position[k].y) then
        begin
          Inc(nombreCommuns);
          Break; // Passer à la coordonnee suivante après un match
        end;
      end;

      // Si on trouve au moins deux coordonnees identiques, on arrête
      if nombreCommuns >= 2 then
      begin
        VerifierAdjacencePersonnes := True;
        Exit;
      end;
    end;
  end;
end;





function CountPersonnes(personnes: array of TPersonne; estEleve: Boolean; joueur: TJoueur): Integer;
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

procedure ChangementProfesseur(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
var
  HexagonesCoords: TCoords;
  i, j, k, compteur: Integer;
  estConverti: Boolean;
  begin
  // Appeler ClicPersonne pour recuperer les hexagones selectionnes
  affichageInformation('Cliquez sur 3 hexagones entre lesquels vous voulez placer le professeur', 25, FCouleur(0,0,0,255), affichage);

  HexagonesCoords := ClicPersonne(affichage, plateau, False); 
  // compteur := 0;

  // Verifie si les hexagones sont adjacents

  if enContact(HexagonesCoords) then
  begin
    estConverti := False;
    // Parcourt les personnes du plateau pour trouver un elève appartenant au joueur actuel
    for i := 0 to length(plateau.Personnes)-1 do
    begin
      if (plateau.Personnes[i].IdJoueur = joueurActuel.Id) and
         (plateau.Personnes[i].estEleve) then
      begin
        compteur := 0; // Reinitialise le compteur pour cette personne
        // Parcourt les positions de la personne pour verifier la correspondance avec les hexagones selectionnes
        for j := 0 to  length(HexagonesCoords)-1 do
        begin
          // Compare chaque position de la personne avec les coordonnees selectionnees
          for k := 0 to length(HexagonesCoords)-1 do
          begin
            if (plateau.Personnes[i].Position[j].x = HexagonesCoords[k].x) and
               (plateau.Personnes[i].Position[j].y = HexagonesCoords[k].y) then
            begin
              compteur := compteur + 1;
            end;
          end;
        end;

        // Si toutes les positions de la personne correspondent aux hexagones selectionnes, effectuer la conversion
        if compteur = 3 then
        begin
          plateau.Personnes[i].estEleve := False; // Convertir l'elève en professeur
          estConverti := True;
          
          // ajout d'un point
          joueurActuel.Points:=1+joueurActuel.Points;
          

          affichageInformation('Eleve converti en professeur avec succes !', 25, FCouleur(0,255,0,255), affichage);

        end;
      end;
      if estConverti then
    end;
    
    affichageScore(joueurActuel,affichage);
    affichagePersonne(plateau.Personnes[i], affichage);
    miseAJourRenderer(affichage);
  end
  else
  begin
    affichageInformation('Conversion invalide. Les hexagones selectionnes ne sont pas adjacents.', 25, FCouleur(0,0,0,255), affichage);

  end;
end;


function compterRouteSuite(plateau : TPlateau; joueur : Tjoueur):Integer;
begin
  compterRouteSuite := 0;
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
    if (compterRouteSuite(plateau,joueur) >= 5) then
    begin
    for i := 0 to High(joueurs) do
      if(compterRouteSuite(plateau,joueur) < compterRouteSuite(plateau,joueurs[i])) then
        plusGrandeRoute := False;
    if plusGrandeRoute then
      points[j] := points[j] + 2;
    end;
    
    if(joueur.CartesTutorat.carte2.utilisee >= 3) then
      for i := 0 to High(joueurs) do
        if(joueur.CartesTutorat.carte1.utilisee < joueurs[i].CartesTutorat.carte1.utilisee) then
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




function connexionValide(coords: TCoords; plateau: TPlateau; joueur: TJoueur;var affichage :TAffichage): Boolean;
var
  i: Integer;
  enContactAvecAutreConnexion, enContactAvecPersonne: Boolean;
begin
  // Initialisation
  connexionValide := True;
  enContactAvecAutreConnexion := False;
  enContactAvecPersonne := False;


  // 1. Verifie si une connexion existe dejà avec les mêmes coordonnees (independamment de l'ordre)
  for i := 0 to High(plateau.Connexions) do
  begin
    if (((plateau.Connexions[i].Position[0].x = coords[0].x) and 
         (plateau.Connexions[i].Position[0].y = coords[0].y) and 
         (plateau.Connexions[i].Position[1].x = coords[1].x) and 
         (plateau.Connexions[i].Position[1].y = coords[1].y)) 
        or 
        ((plateau.Connexions[i].Position[0].x = coords[1].x) and 
         (plateau.Connexions[i].Position[0].y = coords[1].y) and 
         (plateau.Connexions[i].Position[1].x = coords[0].x) and 
         (plateau.Connexions[i].Position[1].y = coords[0].y))) then
    begin
      connexionValide := False;
      affichageInformation('Position de connexion dja occupee.', 25, FCouleur(0,0,0,255), affichage);

      Exit;
    end;
  end;

  // 2. Verifie si les deux hexagones sont adjacents
  if not enContact(coords) then
  begin
    connexionValide := False;
    affichageInformation('Les deux hexagones ne sont pas adjacents.', 25, FCouleur(0,0,0,255), affichage);

    Exit;
  end;
  enContactAvecAutreConnexion := not aucuneConnexionAdjacente(coords, plateau, joueur,affichage);
  enContactAvecPersonne := enContactEleveConnexion(plateau, coords, joueur);

  // 3. Verifie si en contact avec un eleve ou une connexion
  if enContactAutreEleveConnexion(plateau,coords,joueur,affichage) then 
     connexionValide:= False;

  // 4. Verifie si au moins 1 des hexagones est dans le plateau
  if (not dansLePlateau(plateau,coords[0]) and not dansLePlateau(plateau,coords[1])) then 
    begin
    connexionValide:= False;      
    affichageInformation('Au moins 1 des hexagones choisis doit etre dans le plateau', 25, FCouleur(0,0,0,255), affichage);

    Exit;
    end; 



  
if not enContactAvecPersonne then
begin
  if not enContactAvecAutreConnexion then
  begin
    connexionValide := False;
    affichageInformation('La connexion doit etre adjacente a une autre connexion ou en contact avec un eleve ou un professeur.', 25, FCouleur(0,0,0,255), affichage);
    Exit;
  end;
end
else
begin
  connexionValide := True;
end;


end;




function ClicConnexion(var plateau : TPlateau; var affichage : TAffichage): TCoords;
var
  coords: TCoords;
begin

  SetLength(coords, 2);
  clicHexagone(plateau, affichage,coords[0]);
  clicHexagone(plateau, affichage,coords[1]);

  ClicConnexion := coords;
end;

procedure placementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur);
var
  coords: TCoords;
  i : Integer;
begin
  // Demande à l'utilisateur de selectionner deux hexagones pour la connexion
  affichageInformation('Cliquez sur 2 hexagones entre lesquels vous voulez placer la connexion', 25, FCouleur(0,0,0,255), affichage);

  repeat
  coords := ClicConnexion(plateau,affichage);

  until connexionValide(coords, plateau, joueur,affichage);


  // Verifie si la connexion est valide avec les hexagones selectionnes
  SetLength(plateau.Connexions, Length(plateau.Connexions) + 1);
  plateau.Connexions[length(plateau.Connexions)-1].IdJoueur := joueur.Id;

  setLength(plateau.Connexions[length(plateau.Connexions)-1].Position,2);

  plateau.Connexions[length(plateau.Connexions)-1].Position[0] := coords[0];
  plateau.Connexions[length(plateau.Connexions)-1].Position[1] := coords[1];

// TODO mieux afficher eleve sur connexion
  
  affichageConnexion(plateau.Connexions[length(plateau.Connexions)-1], affichage);

  for i:=0 to length(plateau.Personnes)-1 do
      affichagePersonne(plateau.Personnes[i],affichage);
  miseAJourRenderer(affichage);


  affichageInformation('Connexion placee avec succes !', 25, FCouleur(0,255,0,255), affichage);

end;
function enContactEleveConnexion( plateau: TPlateau; coords: TCoords; var joueur: TJoueur): Boolean;
var
  i, k, l: Integer;
begin
  enContactEleveConnexion := False;
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
          enContactEleveConnexion := True;
          Exit;
        end;
      end;
    end;
  end;
end;
function aucuneConnexionAdjacente(coords: TCoords; plateau: TPlateau; joueur: TJoueur; var affichage : TAffichage): Boolean;
var
  i, j,k: Integer;
  autreCoord, autreCoord2, coord1, coord2, coordRestante: TCoord;
  verif: Boolean;
begin
  // Initialisation
  aucuneConnexionAdjacente := True;
  verif := true;

  // Parcourir toutes les connexions du plateau pour verifier les connexions du même joueur
  for i := 0 to High(plateau.Connexions) do
  begin
    if plateau.Connexions[i].IdJoueur = joueur.Id then
    begin
      coord1 := plateau.Connexions[i].Position[0];
      coord2 := plateau.Connexions[i].Position[1];

      // Identifier `autreCoord` et `coordRestante` en fonction des coordonnees
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
      end
      else
        Continue; // Passer à la connexion suivante si aucune correspondance trouvee

      // Verifier si `autreCoord` est adjacente à `coordRestante` (connexion du même joueur)
      if sontAdjacents(autreCoord, coordRestante) then
      begin
       verif := False;
       
      end;
    end;
  end;

  // Verifier si `autreCoord2` est utilise par une connexion d'un joueur different
  for j := 0 to High(plateau.Connexions) do
  begin
    if plateau.Connexions[j].IdJoueur <> joueur.Id then
    begin
      // Verifier si `autreCoord2` correspond à une extremite de la connexion d'un autr<;:e joueur
      if ((autreCoord2.x = plateau.Connexions[j].Position[0].x) and 
          (autreCoord2.y = plateau.Connexions[j].Position[0].y) and
          sontAdjacents(autreCoord, plateau.Connexions[j].Position[1])) or
         ((autreCoord2.x = plateau.Connexions[j].Position[1].x) and 
          (autreCoord2.y = plateau.Connexions[j].Position[1].y) and
          sontAdjacents(autreCoord, plateau.Connexions[j].Position[0])) then
      begin
        verif := True;
        affichageInformation('Erreur : autreCoord est utilise par une connexion d''un autre joueur, et coordRestante est adjacente à cette connexion.', 25, FCouleur(0,0,0,255), affichage);
        
        Break;
      end;
    end;
  end;
  for k:=0 to High(plateau.Personnes)-1 do
  Begin
    if plateau.Personnes[k].IdJoueur <> joueur.Id then 
    begin
      if (coords[0].x = plateau.Personnes[i].Position[k].x) and
           (coords[0].y = plateau.Personnes[i].Position[k].y) then
           verif:=True;
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
begin
  affichageInformation('Cliquez sur 1 hexagones pour deplacer le souillard.', 25, FCouleur(0,0,0,255), affichage);

  repeat
  clicHexagone(plateau, affichage, coord); 
  until (dansLePlateau(plateau,coord));

  plateau.Souillard.Position := coord;

  affichageInformation('Eleve deplace avec succes !', 25, FCouleur(0,255,0,255), affichage);


  affichageTour(plateau,joueurs,affichage);

end;



end.
