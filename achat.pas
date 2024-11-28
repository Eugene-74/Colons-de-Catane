unit achat;

interface

uses
  Types, affichageUnit,traitement,sysutils,musique;

function dansLePlateau(plateau : TPlateau; coord : Tcoord): boolean;
function CoordsEgales(coords1: TCoords; coords2: TCoords): Boolean;
procedure deplacementSouillard(var plateau : TPlateau; var joueurs : TJoueurs ;var affichage : TAffichage);

procedure placementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur);
procedure PlacementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
procedure affichageGagnant(joueur: TJoueur; affichage: TAffichage);
procedure achatElements(var joueur: TJoueur; var plateau: TPlateau; var affichage: TAffichage; choix : Integer);
procedure verificationPointsVictoire(plateau : TPlateau; joueurs: TJoueurs; var gagner: Boolean; var gagnant: Integer;var affichage : TAffichage);


implementation


procedure ChangementProfesseur(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);forward;
procedure ClicConnexion(plateau : TPlateau;affichage : TAffichage;var coords : TCoords);forward;
function connexionValide(coords: TCoords; plateau: TPlateau; joueur: TJoueur;var affichage : TAffichage): Boolean;forward;
function ClicPersonne(affichage: TAffichage; plateau: TPlateau; estEleve: Boolean): TCoords;forward;
function CountPersonnes(personnes: array of TPersonne; estEleve: Boolean; joueur: TJoueur): Integer;forward;
function PersonneValide(plateau: TPlateau; HexagonesCoords: TCoords; estEleve: Boolean; joueurActuel: TJoueur;affichage : TAffichage): Boolean;forward;
function VerifierAdjacencePersonnes(HexagonesCoords: TCoords; plateau: TPlateau): Boolean;forward;
function enContactEleveConnexion( plateau: TPlateau; coords: TCoords; var joueur: TJoueur): Boolean;forward;
function aucuneConnexionAdjacente(coords: TCoords;  plateau: TPlateau; joueur: TJoueur; var affichage : TAffichage): Boolean;forward;
function enContactAutreEleveConnexion(plateau:TPlateau ;coords: TCoords; var joueur:TJoueur; var affichage : TAffichage):Boolean;forward;
function enContactConnexionConnexion(plateau: TPlateau; coords1: TCoords; coords2: TCoords): Boolean;forward;
function resteEleve(plateau:TPlateau; joueur:Tjoueur): Boolean;forward;
function enContactEleveConnexions(plateau: TPlateau; eleve: TPersonne; var joueur: TJoueur): TCoords;forward;
function compterRouteSuite(plateau: TPlateau; joueur: TJoueur): Integer;forward;



procedure clicHexagoneValide(var plateau: TPlateau; var affichage: TAffichage; var coord: Tcoord);
var valide : boolean;
begin
    repeat
        clicHexagone(plateau, affichage, coord);
        valide := dansLePlateau(plateau,coord);
        jouerSonValide(valide);
    until valide;

end;

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
      jouerSonClicAction();

        PlacementEleve(plateau, affichage, joueur);

        joueur.Ressources[Mathematiques] := joueur.Ressources[Mathematiques] - 1;
        joueur.Ressources[Humanites] := joueur.Ressources[Humanites] - 1;
        joueur.Ressources[Chimie] := joueur.Ressources[Chimie] - 1;
        joueur.Ressources[Physique] := joueur.Ressources[Physique] - 1;
      end
      else
        begin
          affichageInformation('Vous n''avez pas les ressources necessaires pour acheter un eleve.', 25, FCouleur(0,0,0,255), affichage);
          jouerSonValide(false);
        end;

    // CONNEXION
    2:
     
      if (joueur.Ressources[Humanites] >= 1) and 
         (joueur.Ressources[Physique] >= 1) then
      begin
      jouerSonClicAction();

        placementConnexion(plateau, affichage, joueur);

        joueur.Ressources[Physique] := joueur.Ressources[Physique] - 1;
        joueur.Ressources[Chimie] := joueur.Ressources[Chimie] - 1;
      end
      else
        begin
          affichageInformation('Vous n''avez pas les ressources necessaires pour acheter une connexion.', 25, FCouleur(0,0,0,255), affichage);
          jouerSonValide(false);
          
        end;
    

    // PROFESSEUR
    3: 
    
      if (joueur.Ressources[Mathematiques] >= 2) and 
         (joueur.Ressources[Physique] >= 1) then
      begin
      jouerSonClicAction();

        changementProfesseur(plateau, affichage, joueur);
      end
      else
        begin
          affichageInformation('Vous n''avez pas les ressources necessaires pour changer un eleve en professeur.', 25, FCouleur(0,0,0,255), affichage);
          jouerSonValide(false);
        end;
    // PROFESSEUR
    4:
    //  verif ressource
    if(plateau.cartesTutorat.carte1.nbr + plateau.cartesTutorat.carte2.nbr + plateau.cartesTutorat.carte3.nbr + plateau.cartesTutorat.carte4.nbr + plateau.cartesTutorat.carte5.nbr >=0 )  then //and a les ressources
    begin
      jouerSonClicAction();

        tirerCarteTutorat(plateau.CartesTutorat, joueur);
    end
    else
    begin
    
      affichageInformation('Impossbile d''acheter une carte de tutorat.', 25, FCouleur(255,0,0,255), affichage);
      jouerSonValide(false);
      
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




procedure placementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
var HexagonesCoords: TCoords;
  valide : Boolean;
begin

  repeat
    HexagonesCoords := ClicPersonne(affichage,plateau,True);
    valide := PersonneValide(plateau, HexagonesCoords, True, joueurActuel,affichage);
    jouerSonValide(valide);
  until valide;

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
      end;
  // ajout d'un point
  joueurActuel.Points:=1+joueurActuel.Points;

  affichageScore(joueurActuel,affichage);
  affichagePersonne(plateau.Personnes[High(plateau.Personnes )], affichage);
  miseAJourRenderer(affichage);

  
  affichageInformation('Eleve place avec succes !', 25, FCouleur(0,255,0,255), affichage);

  
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

  if(joueurActuel.Points > 2 ) then
    // TODO verifier le contact avec une connexion du joueur
    if not enContactEleveConnexion(plateau,HexagonesCoords,joueurActuel) then
    begin
    //  writeln('Eleve non liée avec une connexion');
      exit;
    end;

  //  writeln('placement d''eleve apres le debut de partie');
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

    jouerSonValide(false);
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
  valide : Boolean;
begin
  repeat
    affichageInformation('Cliquez sur 3 hexagones entre lesquels vous voulez placer le professeur', 25, FCouleur(0,0,0,255), affichage);
    HexagonesCoords := ClicPersonne(affichage, plateau, False);
    valide := professeurValide(affichage,plateau,joueurActuel,HexagonesCoords);
  until valide;

  joueurActuel.Points:=1+joueurActuel.Points;
  
  // changer en prof ici
  // plateau.Personnes[i].estEleve := False; // Convertir l'elève en professeur

  affichageScore(joueurActuel,affichage);
  affichagePersonne(plateau.Personnes[i], affichage);
  miseAJourRenderer(affichage);

  affichageInformation('Eleve converti en professeur avec succes !', 25, FCouleur(0,255,0,255), affichage);
end;


function compterRouteSuite(plateau: TPlateau; joueur: TJoueur): Integer;
var
  i, j, k, l: Integer;
  connexionsEleve: TCoords; // Tableau contenant les connexions liées à un élève
  maxRoute, routeActuelle: Integer;
  connexionCourante: TCoords;
  dejaVisite: array of Boolean;

begin
  maxRoute := 0;
  setLength (connexionCourante,2);
  // Initialiser un tableau pour marquer les connexions visitées
  SetLength(dejaVisite, Length(plateau.Connexions));
  for i := 0 to High(dejaVisite) do
    dejaVisite[i] := False;

  // Parcourir les élèves du joueur
  for i := 0 to High(plateau.Personnes) do
  begin
    if plateau.Personnes[i].IdJoueur = joueur.Id then
    begin
      // Récupérer les connexions liées à l'élève
      connexionsEleve := enContactEleveConnexions(plateau, plateau.Personnes[i],joueur);

      // Parcourir chaque connexion liée à l'élève
      for j := 0 to High(connexionsEleve) do
      begin
        routeActuelle := 1; // Initialiser le compteur de la route
        connexionCourante[0]:= connexionsEleve[j];
        connexionCourante[1]:= connexionsEleve[j+1];


        // Parcourir les connexions du joueur pour suivre la chaîne
        while True do
        begin
          // Rechercher une connexion liée à la connexion courante
          l := -1;
          for k := 0 to High(plateau.Connexions) do
          begin
            if (plateau.Connexions[k].IdJoueur = joueur.Id) and
               not dejaVisite[k] and
               enContactConnexionConnexion(plateau, connexionCourante, plateau.Connexions[k].Position) and
               not CoordsEgales(connexionCourante, plateau.Connexions[k].Position) then
            begin
              l := k; // Trouver une connexion liée
              Break;
            end;
          end;

          // Si aucune connexion suivante n'est trouvée, arrêter la chaîne
          if l = -1 then
            Break;

          // Marquer la connexion comme visitée et continuer la chaîne
          dejaVisite[l] := True;
          // TODO NE SURTOUT PAS METTRE ça CA CASSE TOUT CAR CA PASSE UN POINTEUR
          // connexionCourante := plateau.Connexions[l].Position;
          connexionCourante[0] := plateau.Connexions[l].Position[0];
          connexionCourante[1] := plateau.Connexions[l].Position[1];


          Inc(routeActuelle);
        end;

        // Mettre à jour le maximum si une route plus longue est trouvée
        if routeActuelle > maxRoute then
          maxRoute := routeActuelle;
      end;
    end;
  end;

  compterRouteSuite := maxRoute;
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
      affichageInformation('Position de connexion deja occupee.', 25, FCouleur(0,0,0,255), affichage);

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
  // TODO inutile
  // enContactAvecPersonne := enContactEleveConnexion(plateau, coords, joueur);
  // enContactAvecAutreConnexion := not aucuneConnexionAdjacente(coords, plateau, joueur,affichage);

  // 3. Verifie si en contact avec un eleve ou une connexion
  if enContactAutreEleveConnexion(plateau,coords,joueur,affichage) then 
    connexionValide:= False;

    // TODO pose probleme de acces violation au  placement de connexion du deuxieme joeuur apres un placement du premier joueur
  // if(aucuneConnexionAdjacente(coords, plateau, joueur,affichage))then
  //   begin
  //     connexionValide:= False;
  //   Exit;
  //   end;

  // 4. Verifie si au moins 1 des hexagones est dans le plateau
  if (not dansLePlateau(plateau,coords[0]) and not dansLePlateau(plateau,coords[1])) then 
    begin
    connexionValide:= False;      
    affichageInformation('Au moins 1 des hexagones choisis doit etre dans le plateau', 25, FCouleur(0,0,0,255), affichage);

    Exit;
    end; 



  // affichageInformation('La connexion doit etre adjacente a une autre connexion ou en contact avec un eleve ou un professeur.', 25, FCouleur(0,0,0,255), affichage);



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
  // Demande à l'utilisateur de selectionner deux hexagones pour la connexion
  affichageInformation('Cliquez sur 2 hexagones entre lesquels vous voulez placer la connexion', 25, FCouleur(0,0,0,255), affichage);

  repeat
    ClicConnexion(plateau,affichage,coords);
    valide := connexionValide(coords, plateau, joueur,affichage);
    jouerSonValide(valide);
  until valide;


  // Verifie si la connexion est valide avec les hexagones selectionnes
  SetLength(plateau.Connexions, Length(plateau.Connexions) + 1);
  plateau.Connexions[length(plateau.Connexions)-1].IdJoueur := joueur.Id;

  setLength(plateau.Connexions[length(plateau.Connexions)-1].Position,2);

  plateau.Connexions[length(plateau.Connexions)-1].Position[0] := coords[0];
  plateau.Connexions[length(plateau.Connexions)-1].Position[1] := coords[1];

  
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
// TODO NE MARCHE PAS REGARDER POURQUOI VORI FONCTION D'AVANT



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
      end;

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
function enContactConnexionConnexion(plateau: TPlateau; coords1: TCoords; coords2: TCoords): Boolean;
var
  Coord, autreCoord1, autreCoord2: TCoord;
begin
  enContactConnexionConnexion := False;

  // Vérifie si coords1[0] correspond à coords2[0]
  if (coords1[0].x = coords2[0].x) and (coords1[0].y = coords2[0].y) then
  begin
    Coord := coords1[0];
    autreCoord1 := coords1[1];
    autreCoord2 := coords2[1];
  end
  // Vérifie si coords1[0] correspond à coords2[1]
  else if (coords1[0].x = coords2[1].x) and (coords1[0].y = coords2[1].y) then
  begin
    Coord := coords1[0];
    autreCoord1 := coords1[1];
    autreCoord2 := coords2[0];
  end
  // Vérifie si coords1[1] correspond à coords2[0]
  else if (coords1[1].x = coords2[0].x) and (coords1[1].y = coords2[0].y) then
  begin
    Coord := coords1[1];
    autreCoord1 := coords1[0];
    autreCoord2 := coords2[1];
  end
  // Vérifie si coords1[1] correspond à coords2[1]
  else if (coords1[1].x = coords2[1].x) and (coords1[1].y = coords2[1].y) then
  begin
    Coord := coords1[1];
    autreCoord1 := coords1[0];
    autreCoord2 := coords2[0];
  end
  else
    Exit; // Aucune correspondance trouvée

  // Vérifie si les deux autres coordonnées (autreCoord1 et autreCoord2) sont adjacentes
  if sontAdjacents(autreCoord1, autreCoord2) then
    enContactConnexionConnexion := True;
end;


function CoordsEgales(coords1: TCoords; coords2: TCoords): Boolean;
begin
  CoordsEgales := False;

  // Vérification si les deux ensembles de coordonnées sont identiques (dans n'importe quel ordre)
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
  enContactConnexions := False; // Initialisation à False par défaut

  // Parcourir toutes les connexions du plateau
  for i := 0 to High(plateau.Connexions) do
  begin
    // Vérifier si la connexion appartient au joueur
    if plateau.Connexions[i].IdJoueur = joueur.Id then
    begin
      coord1 := plateau.Connexions[i].Position[0];
      coord2 := plateau.Connexions[i].Position[1];

      // Vérifier si l'une des coordonnées correspond à celles du joueur
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
        Continue; // Passer à la connexion suivante si aucune correspondance trouvée

      // Vérifier si `autreCoord` est adjacente à `autreCoord2`
      if sontAdjacents(autreCoord, autreCoord2) then
      begin
        enContactConnexions := True;
        Exit; // Quitter dès qu'une connexion valide est trouvée
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
  SetLength(enContactEleveConnexions, 6); // Initialiser le tableau pour stocker 3 connexions maximum

  // Parcours toutes les connexions du plateau
  for i := 0 to High(plateau.Connexions) do
  begin
    // Vérifie si la connexion est en contact avec l'élève
    if enContactEleveConnexion(plateau, plateau.Connexions[i].Position, joueur) then
    begin
      // Ajoute les coordonnées de la connexion en contact à la liste
      enContactEleveConnexions[connexionsTrouvees] := plateau.Connexions[i].Position[0];
      enContactEleveConnexions[connexionsTrouvees+1] := plateau.Connexions[i].Position[1];

      connexionsTrouvees:=+2;

      // Si 3 connexions sont trouvées, arrête la recherche
      if connexionsTrouvees = 6 then
        Exit;
    end;
  end;

  // Si moins de 3 connexions sont trouvées, ajuste la taille du tableau pour ne pas inclure des indices inutiles
  SetLength(enContactEleveConnexions, connexionsTrouvees);
end;

function resteEleve(plateau: TPlateau; joueur: TJoueur): Boolean;
var
  i: Integer;
begin
  resteEleve := False;
  for i := 0 to High(plateau.Personnes) do
  begin
    if (plateau.Personnes[i].IdJoueur = joueur.Id) and (plateau.Personnes[i].estEleve) then
    begin
      resteEleve := True;
      Exit; 
    end;
  end;
end;




end.
