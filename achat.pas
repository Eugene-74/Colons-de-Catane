unit achat;

interface

uses
  Types, affichageUnit,traitement;

procedure ChangementProfesseur(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
procedure achatElements(var joueur: TJoueur; var plateau: TPlateau; var affichage: TAffichage; choix : Integer);
procedure PlacementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
procedure placementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur);
procedure verificationPointsVictoire(plateau : TPlateau; joueurs: TJoueurs; var gagner: Boolean; var gagnant: Integer);
procedure affichageGagnant(joueur: TJoueur; affichage: TAffichage);
procedure deplacementSouillard(var plateau : TPlateau; var joueurs : TJoueurs ;var affichage : TAffichage);
function ClicConnexion(var plateau : TPlateau; var affichage : TAffichage): TCoords;
function connexionValide(coords: TCoords; plateau: TPlateau; joueur: TJoueur): Boolean;
function ClicPersonne(affichage: TAffichage; plateau: TPlateau; estEleve: Boolean): TCoords;
function CountPersonnes(personnes: array of TPersonne; estEleve: Boolean; joueur: TJoueur): Integer;
function PersonneValide(plateau: TPlateau; HexagonesCoords: TCoords; estEleve: Boolean; joueurActuel: TJoueur): Boolean;
function VerifierAdjacencePersonnes(HexagonesCoords: TCoords; plateau: TPlateau): Boolean;
function enContactEleveConnexion( plateau: TPlateau; coords: TCoords; var joueur: TJoueur): Boolean;
function aucuneConnexionAdjacente(coords: TCoords;  plateau: TPlateau; joueur: TJoueur): Boolean;
function enContactAutreEleveConnexion(plateau:TPlateau ;coords: TCoords; var joueur:TJoueur):Boolean;
function dansLePlateau(plateau : TPlateau; coord : Tcoord): boolean;

implementation

procedure achatElements(var joueur: TJoueur; var plateau: TPlateau; var affichage: TAffichage; choix : Integer);
// var
  // choix: Integer;
begin
  
// TODO changer les write en une valeur donner dans la fonction 
// c'est gestion qui envoie la bonne action a effectuer

  // WriteLn('Choisissez l''élément à acheter : ');
  // WriteLn('1. Élève');
  // WriteLn('2. Connexion');
  // WriteLn('3. Changer un Élève en Professeur');
  // ReadLn(choix);

  case choix of
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
        WriteLn('Vous n''avez pas les ressources nécessaires pour acheter un élève.');
    
    2: 
     
      if (joueur.Ressources[Humanites] >= 1) and 
         (joueur.Ressources[Physique] >= 1) then
      begin
        placementConnexion(plateau, affichage, joueur);

        joueur.Ressources[Physique] := joueur.Ressources[Physique] - 1;
        joueur.Ressources[Chimie] := joueur.Ressources[Chimie] - 1;
      end
      else
        WriteLn('Vous n''avez pas les ressources nécessaires pour acheter une connexion.');
    
    3: 
    
      if (joueur.Ressources[Mathematiques] >= 2) and 
         (joueur.Ressources[Physique] >= 1) then
      begin
        changementProfesseur(plateau, affichage, joueur);
      end
      else
        WriteLn('Vous n''avez pas les ressources nécessaires pour changer un élève en professeur.');
  
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

  // writeln(taille div 2);
  if(coord.x <= taille div 2) then
    begin
    if ((coord.y > taille) or (coord.y <=taille div 2 +1- coord.x)) then 
      dansLePlateau := False;
    // writeln(taille div 2 - coord.x);
    // writeln(taille);
    end;
  
  if(coord.x > taille div 2 +1) then
    begin
    if ((coord.y >  taille - coord.x  + taille div 2 +1) or (coord.y <=0)) then 
      dansLePlateau := False;
    writeln( taille - coord.x  + taille div 2 +1);
    writeln(0);

    end;

end;




procedure placementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
var
 HexagonesCoords: TCoords;
begin
  HexagonesCoords := ClicPersonne(affichage,plateau,True); 

  if PersonneValide(plateau, HexagonesCoords, True, joueurActuel) then
  begin
   
    // TODO MACHE PAS LES HEXAGONES SONT PAS SPECIALEMENT COLLER
    SetLength(plateau.Personnes, Length(plateau.Personnes) + 1);
    with plateau.Personnes[High(plateau.Personnes)] do
    begin
      // Assigner les coordonnées des hexagones sélectionnés à l'élève
      SetLength(Position, 3); 
      Position[0] := HexagonesCoords[0];
      Position[1] := HexagonesCoords[1];
      Position[2] := HexagonesCoords[2];

      estEleve := True;
      IdJoueur := joueurActuel.Id;

      // ajout d'un point
      joueurActuel.Points:=1+joueurActuel.Points;

    end;

    affichagePersonne(plateau.Personnes[High(plateau.Personnes )], affichage);
    miseAJourRenderer(affichage);

    
    WriteLn('Élève placé avec succès !');
  end
  else
  begin
    WriteLn('Placement invalide. Vérifiez les conditions de placement.');
    placementEleve(plateau,  affichage, joueurActuel);
  end;
end;




function PersonneValide(plateau: TPlateau; HexagonesCoords: TCoords; estEleve: Boolean; joueurActuel: TJoueur): Boolean;
var
  i: Integer;
  personneAdjacente: Boolean;
begin
  personneAdjacente := False;
  if not enContact(HexagonesCoords) then
  begin
    PersonneValide := False;
    Exit;
  end;

  if(joueurActuel.Points > 2 ) then
    // TODO verifier le contact avec une connexion du joueur
    writeln('placement d''eleve apres le debut de partie');


  // Vérifie la présence d'une personne adjacente

    if  VerifierAdjacencePersonnes(HexagonesCoords,plateau) then
    begin
        PersonneValide := False; 
    end
    else
        personneAdjacente := True; 
   
  
  // 4. Vérifie si au moins 1 des hexagones est dans le plateau
  if (( not dansLePlateau(plateau,HexagonesCoords[0]) and not dansLePlateau(plateau,HexagonesCoords[1]) and not dansLePlateau(plateau,HexagonesCoords[2]) )
      ) then 
    begin
    PersonneValide:= False;      
    WriteLn('Au moins 1 des hexagones choisis doit etre dans le plateau');
    
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
  if estEleve then
    writeln('Cliquez sur trois hexagones entre lesquels vous voulez placer l''élève')
  else
    writeln('Cliquez sur trois hexagones entre lesquels vous voulez placer le professeur');

  for i := 0 to 2 do
  begin
    clicHexagone(plateau, affichage, HexagonesCoords[i]); 
  end;
  ClicPersonne := HexagonesCoords;
end;

function VerifierAdjacencePersonnes(HexagonesCoords: TCoords; plateau: TPlateau): Boolean;
var
  i, j, k, l, nombreCommuns: Integer;
begin
  VerifierAdjacencePersonnes := False;

  // Vérification des doublons dans HexagonesCoords
  for i := 0 to High(HexagonesCoords) - 1 do
  begin
    for j := i + 1 to High(HexagonesCoords) do
    begin
      if (HexagonesCoords[i].x = HexagonesCoords[j].x) and 
         (HexagonesCoords[i].y = HexagonesCoords[j].y) then
      begin
        Exit(True); // Il y a des coordonnées identiques
      end;
    end;
  end;

  // Vérification de l'adjacence avec les personnes sur le plateau
  for i := 0 to High(plateau.Personnes) do
  begin
    nombreCommuns := 0;

    // Vérifier chaque coordonnée dans HexagonesCoords
    for j := 0 to High(HexagonesCoords) do
    begin
      // Comparer avec les trois positions de la personne
      for k := 0 to 2 do
      begin
        if (HexagonesCoords[j].x = plateau.Personnes[i].Position[k].x) and
           (HexagonesCoords[j].y = plateau.Personnes[i].Position[k].y) then
        begin
          Inc(nombreCommuns);
          Break; // Passer à la coordonnée suivante après un match
        end;
      end;

      // Si on trouve au moins deux coordonnées identiques, on arrête
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
  // Appeler ClicPersonne pour récupérer les hexagones sélectionnés
  HexagonesCoords := ClicPersonne(affichage, plateau, False); 
  // compteur := 0;

  // Vérifie si les hexagones sont adjacents

  if enContact(HexagonesCoords) then
  begin
        writeln('contact');

    estConverti := False;
    // Parcourt les personnes du plateau pour trouver un élève appartenant au joueur actuel
    for i := 0 to length(plateau.Personnes)-1 do
    begin
        writeln('plateau');

      if (plateau.Personnes[i].IdJoueur = joueurActuel.Id) and
         (plateau.Personnes[i].estEleve) then
      begin
        writeln('elev trouver');
        compteur := 0; // Réinitialise le compteur pour cette personne
        // Parcourt les positions de la personne pour vérifier la correspondance avec les hexagones sélectionnés
        for j := 0 to  length(HexagonesCoords)-1 do
        begin
          // Compare chaque position de la personne avec les coordonnées sélectionnées
          for k := 0 to length(HexagonesCoords)-1 do
          begin
            if (plateau.Personnes[i].Position[j].x = HexagonesCoords[k].x) and
               (plateau.Personnes[i].Position[j].y = HexagonesCoords[k].y) then
            begin
              compteur := compteur + 1;
              writeln('compteur',compteur);
              // Break; // Passe à la prochaine position une fois une correspondance trouvée
            end;
          end;
        end;

        // Si toutes les positions de la personne correspondent aux hexagones sélectionnés, effectuer la conversion
        if compteur = 3 then
        begin
          plateau.Personnes[i].estEleve := False; // Convertir l'élève en professeur
          estConverti := True;
          
          // ajout d'un point
          joueurActuel.Points:=1+joueurActuel.Points;


          // affichagePersonne(plateau.Personnes[High(plateau.Personnes )], affichage);
          // miseAJourRenderer(affichage); 

          WriteLn('Élève converti en professeur avec succès !');
          // Break; 
        end;
      end;
      if estConverti then
        // Break;
    end;

  //   if not estConverti then
  //     WriteLn('Aucun élève trouvé à convertir sur les hexagones sélectionnés.');

    affichagePersonne(plateau.Personnes[i], affichage);
    miseAJourRenderer(affichage);
  end
  else
  begin
    WriteLn('Conversion invalide. Les hexagones sélectionnés ne sont pas adjacents.');
  end;
end;


function compterRouteSuite(plateau : TPlateau; joueur : Tjoueur):Integer;
var connexions,connexionsJ : TConnexions;
  connexion : TConnexion;
  i,j,nbr,max : Integer;

begin
connexions := plateau.Connexions;
for connexion in connexions do
  begin
  if (connexion.idJoueur = joueur.id) then
    begin
    SetLength(connexionsJ,length(connexionsJ)+1);
    connexionsJ[length(connexionsJ)] := connexion;
    end;
  end;

for i := 0 to length(connexionsJ) -1 do 
  begin
  for j := i to length(connexionsJ) -1 do 
    begin 
    if ( ((connexionsJ[i].Position[0].x = connexionsJ[j].Position[0].x) and (connexionsJ[i].Position[0].y = connexionsJ[j].Position[0].y)) 
        or ((connexionsJ[i].Position[1].x = connexionsJ[j].Position[1].x) and (connexionsJ[i].Position[1].y = connexionsJ[j].Position[1].y)) ) then
        nbr := nbr +1;
    end;
  if (nbr > max) then
    max := nbr;
  nbr := 0;
  end;

  compterRouteSuite := max;
end;


procedure verificationPointsVictoire(plateau : TPlateau; joueurs: TJoueurs; var gagner: Boolean; var gagnant: Integer);
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

    // TODO erreur acces violation
    // plusGrandeRoute := True;
    // if (compterRouteSuite(plateau,joueur) >= 5) then
    // begin
    // for i := 0 to High(joueurs) do
    //   if(compterRouteSuite(plateau,joueur) < compterRouteSuite(plateau,joueurs[i])) then
    //     plusGrandeRoute := False;
    // if plusGrandeRoute then
    //   points[j] := points[j] + 2;
    // end;


    
    if(joueur.CartesTutorat.carte2.nbr >= 3) then
      for i := 0 to High(joueurs) do
        if(joueur.CartesTutorat.carte1.nbr < joueurs[i].CartesTutorat.carte1.nbr) then
          plusDeplacementSouillard := False;
    if(plusDeplacementSouillard) then
      points[j] := points[j] + 2;
    
    if points[j] >= 10 then
    begin

      gagner := True;
      gagnant := j+1; 
      // writeln(joueur.Nom,'viens de gagner la partie en dépassant les 10 points');
      Break;
    end;

    j := j+1;

  end;


end;


procedure affichageGagnant(joueur: TJoueur; affichage: TAffichage);
begin
  WriteLn('Félicitations, ', joueur.Nom, ' ! Vous avez gagné la partie avec ', joueur.Points, ' points.');
end;




function connexionValide(coords: TCoords; plateau: TPlateau; joueur: TJoueur): Boolean;
var
  i: Integer;
  enContactAvecAutreConnexion, enContactAvecPersonne: Boolean;
begin
  // Initialisation
  connexionValide := True;
  enContactAvecAutreConnexion := False;
  enContactAvecPersonne := False;


  // 1. Vérifie si une connexion existe déjà avec les mêmes coordonnées (indépendamment de l'ordre)
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
      WriteLn('Position de connexion déjà occupée.');
      Exit;
    end;
  end;

  // 2. Vérifie si les deux hexagones sont adjacents
  if not enContact(coords) then
  begin
    connexionValide := False;
    WriteLn('Les deux hexagones ne sont pas adjacents.');
    Exit;
  end;
  enContactAvecAutreConnexion := not aucuneConnexionAdjacente(coords, plateau, joueur);
  enContactAvecPersonne := enContactEleveConnexion(plateau, coords, joueur);

  // 3. Vérifie si en contact avec un eleve ou une connexion
  if enContactAutreEleveConnexion(plateau,coords,joueur) then 
     connexionValide:= False;

  // 4. Vérifie si au moins 1 des hexagones est dans le plateau
  if (not dansLePlateau(plateau,coords[0]) and not dansLePlateau(plateau,coords[1])) then 
    begin
    connexionValide:= False;      
    WriteLn('Au moins 1 des hexagones choisis doit etre dans le plateau');

    Exit;
    end; 



  
if not enContactAvecPersonne then
begin
  if not enContactAvecAutreConnexion then
  begin
    connexionValide := False;
    WriteLn('La connexion doit être adjacente à une autre connexion ou en contact avec un élève ou un professeur.');
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
begin

  // Demande à l'utilisateur de sélectionner deux hexagones pour la connexion
  coords := ClicConnexion(plateau,affichage);

  // Vérifie si la connexion est valide avec les hexagones sélectionnés
  if connexionValide(coords, plateau, joueur) then
    begin

    SetLength(plateau.Connexions, Length(plateau.Connexions) + 1);
    plateau.Connexions[length(plateau.Connexions)-1].IdJoueur := joueur.Id;

    setLength(plateau.Connexions[length(plateau.Connexions)-1].Position,2);

    plateau.Connexions[length(plateau.Connexions)-1].Position[0] := coords[0];
    plateau.Connexions[length(plateau.Connexions)-1].Position[1] := coords[1];

    
    affichageConnexion(plateau.Connexions[length(plateau.Connexions)-1], affichage);
    miseAJourRenderer(affichage);


    WriteLn('Connexion placée avec succès !');
    end
  else
    begin
    WriteLn('Impossible de placer la connexion : vérifiez la position choisie.');
    // Si la connexionn n'est pas valide, on rappelle la fonction
    placementConnexion(plateau,affichage,joueur);
    end;
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
          WriteLn('Connexion en contact avec une personne du joueur.');
          Exit;
        end;
      end;
    end;
  end;
end;
function aucuneConnexionAdjacente(coords: TCoords; plateau: TPlateau; joueur: TJoueur): Boolean;
var
  i, j,k: Integer;
  autreCoord, autreCoord2, coord1, coord2, coordRestante: TCoord;
  verif: Boolean;
begin
  // Initialisation
  aucuneConnexionAdjacente := True;
  verif := true;

  // Parcourir toutes les connexions du plateau pour vérifier les connexions du même joueur
  for i := 0 to High(plateau.Connexions) do
  begin
    if plateau.Connexions[i].IdJoueur = joueur.Id then
    begin
      coord1 := plateau.Connexions[i].Position[0];
      coord2 := plateau.Connexions[i].Position[1];

      // Identifier `autreCoord` et `coordRestante` en fonction des coordonnées
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
        Continue; // Passer à la connexion suivante si aucune correspondance trouvée

      // Vérifier si `autreCoord` est adjacente à `coordRestante` (connexion du même joueur)
      if sontAdjacents(autreCoord, coordRestante) then
      begin
       verif := False;
       
      end;
    end;
  end;

  // Vérifier si `autreCoord2` est utilisé par une connexion d'un joueur différent
  for j := 0 to High(plateau.Connexions) do
  begin
    if plateau.Connexions[j].IdJoueur <> joueur.Id then
    begin
      // Vérifier si `autreCoord2` correspond à une extrémité de la connexion d'un autr<;:e joueur
      if ((autreCoord2.x = plateau.Connexions[j].Position[0].x) and 
          (autreCoord2.y = plateau.Connexions[j].Position[0].y) and
          sontAdjacents(autreCoord, plateau.Connexions[j].Position[1])) or
         ((autreCoord2.x = plateau.Connexions[j].Position[1].x) and 
          (autreCoord2.y = plateau.Connexions[j].Position[1].y) and
          sontAdjacents(autreCoord, plateau.Connexions[j].Position[0])) then
      begin
        verif := True;
        WriteLn('Erreur : autreCoord est utilisé par une connexion d''un autre joueur, et coordRestante est adjacente à cette connexion.');
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

function enContactAutreEleveConnexion(plateau:TPlateau ;coords: TCoords; var joueur:TJoueur):Boolean;
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
          WriteLn('Connexion en contact avec une personne dune autre joueur.');
          Exit;
        end;
      end;
    end;
  end;
end;


procedure deplacementSouillard(var plateau : TPlateau;var joueurs : TJoueurs ;var affichage : TAffichage);
var coord : Tcoord;
begin


  repeat
  clicHexagone(plateau, affichage, coord); 
  until (dansLePlateau(plateau,coord));


  plateau.Souillard.Position := coord;

  affichageTour(plateau,joueurs,affichage);

end;



end.
