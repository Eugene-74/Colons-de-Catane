unit achat;

interface

uses
  Types, affichageUnit,traitement;

procedure ChangementProfesseur(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
procedure achatElements(var joueur: TJoueur; var plateau: TPlateau; var affichage: TAffichage);
procedure PlacementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
procedure PlacementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur);
procedure verificationPointsVictoire(var joueurs: TJoueurs; var gagner: Boolean; var gagnant: Integer);
procedure affichageGagnant(joueur: TJoueur; affichage: TAffichage);
function ClicConnexion(): THexagones;
function connexionValide(hexagonesSelectionnes: THexagones; plateau: TPlateau; joueur: TJoueur): Boolean;
function ClicPersonne(estEleve: Boolean): THexagones;
function CountPersonnes(personnes: array of TPersonne; estEleve: Boolean; joueur: TJoueur): Integer;
function PersonneValide(plateau: TPlateau; hexagonesSelectionnes: THexagones; estEleve: Boolean; joueurActuel: TJoueur): Boolean;

implementation

procedure achatElements(var joueur: TJoueur; var plateau: TPlateau; var affichage: TAffichage);
var
  choix: Integer;
begin
  WriteLn('Choisissez l''élément à acheter : ');
  WriteLn('1. Élève');
  WriteLn('2. Connexion');
  WriteLn('3. Changer un Élève en Professeur');
  ReadLn(choix);

  case choix of
    1: placementEleve(plateau, affichage, joueur);
    2: placementConnexion(plateau, affichage, joueur);
    3: changementProfesseur(plateau, affichage, joueur);
  else
    WriteLn('Choix invalide.');  // Affiche si le choix n'est pas valide
  end;
end;


procedure placementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
var
  hexagonesSelectionnes: THexagones;
begin
  // hexagonesSelectionnes := ClicPersonne(True); 

  // if PersonneValide(plateau, hexagonesSelectionnes, True, joueurActuel) then
  // begin
  //   // Déduction des ressources

    // TODO deplacer dans verificationRessouce / achatElement
    // joueurActuel.Ressources[Mathematiques] := joueurActuel.Ressources[Mathematiques] - 1;
    // joueurActuel.Ressources[Humanites] := joueurActuel.Ressources[Humanites] - 1;
    // joueurActuel.Ressources[Chimie] := joueurActuel.Ressources[Chimie] - 1;
    // joueurActuel.Ressources[Physique] := joueurActuel.Ressources[Physique] - 1;

    
    // SetLength(plateau.Personnes, Length(plateau.Personnes) + 1);
    // with plateau.Personnes[High(plateau.Personnes)] do
    // begin
    //   // Assigner les coordonnées des hexagones sélectionnés à l'élève
    //   SetLength(Position, 3); 
    //   Position[0] := hexagonesSelectionnes.Positions[0]; 
    //   Position[1] := hexagonesSelectionnes.Positions[1]; 
    //   Position[2] := hexagonesSelectionnes.Positions[2]; 

    //   estEleve := True;
    //   IdJoueur := joueurActuel.Id; 
    // end;

    // affichageGrille(plateau, affichage); 
    WriteLn('Élève placé avec succès !');
  // end
  // else
  // begin
  //   WriteLn('Placement invalide. Vérifiez les conditions de placement.');
  // end;
end;


function PersonneValide(plateau: TPlateau; hexagonesSelectionnes: THexagones; estEleve: Boolean; joueurActuel: TJoueur): Boolean;
var
  i: Integer;
  personneAdjacente: Boolean;
  ressourcesSuffisantes: Boolean;
begin
  personneAdjacente := False;
  ressourcesSuffisantes := False;
  if not enContact(hexagonesSelectionnes.Positions) then
  begin
    PersonneValide := False;
    Exit;
  end;

  // Vérifie la présence d'une personne adjacente
  for i := 0 to High(plateau.Personnes) do
  begin
    if sontAdjacentes(hexagonesSelectionnes.Positions[0], plateau.Personnes[i].Position[i]) or
       sontAdjacentes(hexagonesSelectionnes.Positions[1], plateau.Personnes[i].Position[i]) or
       sontAdjacentes(hexagonesSelectionnes.Positions[2], plateau.Personnes[i].Position[i]) then
    begin
  
      if (plateau.Personnes[i].estEleve) or (not plateau.Personnes[i].estEleve and not estEleve) then
      begin
        PersonneValide := False; // Ne peut pas être adjacent à un élève ou à un professeur
        Exit;
      end;
      personneAdjacente := True; // Marque la case comme ayant une personne adjacente
    end;
  end;
  if estEleve then
  begin
    // Conditions de ressources et limite pour un élève
    ressourcesSuffisantes := (joueurActuel.Ressources[Mathematiques] >= 1) and
                             (joueurActuel.Ressources[Humanites] >= 1) and
                             (joueurActuel.Ressources[Chimie] >= 1) and
                             (joueurActuel.Ressources[Physique] >= 1) and
                             (CountPersonnes(plateau.Personnes, True, joueurActuel) < 5);
  end
  else // Cas du professeur
  begin
    // Conditions de ressources et limite pour un professeur
    ressourcesSuffisantes := (joueurActuel.Ressources[Mathematiques] >= 2) and
                             (joueurActuel.Ressources[Physique] >= 1) and
                             (CountPersonnes(plateau.Personnes, False, joueurActuel) < 3);
  end;
  PersonneValide := ressourcesSuffisantes and personneAdjacente;

end;


function ClicPersonne(estEleve: Boolean): THexagones;
var
  i: Integer;
  coord: TCoord;
  selections: THexagones;
  plateau: TPlateau;
  affichage: TAffichage; 
begin
  
  if estEleve then
    writeln('Cliquez sur trois hexagones entre lesquels vous voulez placer l''élève')
  else
    writeln('Cliquez sur troistrois hexagones entre lesquels vous voulez placer le professeur');

  selections.Taille := 3;
  SetLength(selections.Positions, selections.Taille);

  for i := 0 to selections.Taille - 1 do
  begin
    clicHexagone(plateau, affichage, coord); 
    selections.Positions[i] := coord; 
  end;
  SetLength(selections.hexagones, selections.Taille);
  for i := 0 to selections.Taille - 1 do
  begin
    selections.hexagones[i].Numero := i;// A faire donnée le numero de l'hexagone coorespondant****************
  end;
  ClicPersonne := selections;
end;



function CountPersonnes(personnes: array of TPersonne; estEleve: Boolean; joueur: TJoueur): Integer;
var
  i,Result: Integer;

begin
  Result := 0; 
  for i := 0 to High(personnes) do
  begin
    if (personnes[i].estEleve = estEleve) and (personnes[i].IdJoueur = joueur.Id) then
      Inc(Result); 
  end;
  CountPersonnes:= Result;
end;

procedure ChangementProfesseur(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
var
  hexagonesSelectionnes: THexagones;
  i, j: Integer;
  estConverti: Boolean;
begin
  // Appeler ClicPersonne pour récupérer les hexagones sélectionnés
  hexagonesSelectionnes := ClicPersonne(False); 

  // Vérifie si les hexagones sont adjacents
  if enContact(hexagonesSelectionnes.Positions) then
  begin
    estConverti := False;
    // Convertir l'élève en professeur sur le plateau
    for i := 0 to High(plateau.Personnes) do
    begin
      if (plateau.Personnes[i].IdJoueur = joueurActuel.Id) and
         (plateau.Personnes[i].estEleve) then
      begin
      
        for j := 0 to High(hexagonesSelectionnes.Positions) do
        begin
          // Vérifie si les coordonnées de l'élève correspondent à l'un des hexagones sélectionnés
           if (plateau.Personnes[i].Position[0].x = hexagonesSelectionnes.Positions[j].x) and
             (plateau.Personnes[i].Position[0].y = hexagonesSelectionnes.Positions[j].y) or
             (plateau.Personnes[i].Position[1].x = hexagonesSelectionnes.Positions[j].x) and
             (plateau.Personnes[i].Position[1].y = hexagonesSelectionnes.Positions[j].y) or
             (plateau.Personnes[i].Position[2].x = hexagonesSelectionnes.Positions[j].x) and
             (plateau.Personnes[i].Position[2].y = hexagonesSelectionnes.Positions[j].y) then
          begin
            // Déduction des ressources nécessaires pour la conversion
            joueurActuel.Ressources[Mathematiques] := joueurActuel.Ressources[Mathematiques] - 2;
            joueurActuel.Ressources[Physique] := joueurActuel.Ressources[Physique] - 1;
            plateau.Personnes[i].estEleve := False; // Changer l'élève en professeur
            estConverti := True;
            WriteLn('Élève converti en professeur avec succès !');
            Break; // Sortir de la boucle des hexagones
          end;
        end;
        if estConverti then
          Break; // Sortir de la boucle des élèves si conversion réussie
      end;
    end;

    if not estConverti then
      WriteLn('Aucun élève trouvé à convertir sur les hexagones sélectionnés.');

    affichageGrille(plateau, affichage); // Met à jour l'affichage de la grille
  end
  else
    WriteLn('Conversion invalide. Les hexagones sélectionnés ne sont pas adjacents.');
end;


procedure verificationPointsVictoire(var joueurs: TJoueurs; var gagner: Boolean; var gagnant: Integer);
var
  i: Integer;
begin
  gagner := False; 
  gagnant := -1;    

  
  for i := 0 to High(joueurs) do
  begin
    if joueurs[i].Points > 10 then
    begin
      gagner := True;       
      gagnant := joueurs[i].Id; 
      Break;
    end;
  end;
end;


procedure affichageGagnant(joueur: TJoueur; affichage: TAffichage);
begin
  WriteLn('Félicitations, ', joueur.Nom, ' ! Vous avez gagné la partie avec ', joueur.Points, ' points.');
   
end;




function connexionValide(hexagonesSelectionnes: THexagones; plateau: TPlateau; joueur: TJoueur): Boolean;
var
  i, j: Integer;
  ressourcesSuffisantes, positionDisponible: Boolean;
begin
  // Vérifie si le joueur a suffisamment de ressources pour acheter une connexion
  ressourcesSuffisantes := (joueur.Ressources[Mathematiques] >= 1) and
                           (joueur.Ressources[Physique] >= 1) and
                           (joueur.Ressources[Chimie] >= 1);

  positionDisponible := True;

  // Parcourt les connexions pour vérifier si l'une des positions de hexagonesSelectionnes est déjà occupée
  for i := 0 to High(plateau.Connexions) do
  begin
    for j := 0 to High(hexagonesSelectionnes.Positions) do
    begin
      if ((plateau.Connexions[i].Position[0].x = hexagonesSelectionnes.Positions[j].x) and
          (plateau.Connexions[i].Position[0].y = hexagonesSelectionnes.Positions[j].y)) or
         ((plateau.Connexions[i].Position[1].x = hexagonesSelectionnes.Positions[j].x) and
          (plateau.Connexions[i].Position[1].y = hexagonesSelectionnes.Positions[j].y)) then
      begin
        positionDisponible := False; 
        Break;
      end;
    end;
    if not positionDisponible then
      Break; 
  end;

 connexionValide := ressourcesSuffisantes and positionDisponible;
end;


function ClicConnexion(): THexagones;
var
  i: Integer;
  coord: TCoord;
  selections: THexagones;
  // TODO mettre dans la signature
  plateau: TPlateau;
  affichage: TAffichage;
begin
  writeln('Cliquez sur deux hexagones entre lesquels vous voulez placer la connexion');

  selections.Taille := 2;
  SetLength(selections.Positions, selections.Taille);
  for i := 0 to selections.Taille - 1 do
  begin
    clicHexagone(plateau, affichage,coord); 
    selections.Positions[i] := coord;
  end;
  // SetLength(selections.hexagones, selections.Taille);
  // for i := 0 to selections.Taille - 1 do
  // begin
  //   selections.hexagones[i] := 0;
  // end;
  // A faire recuperer le numero de l'hexagone si necessaire****************************************************************

  ClicConnexion := selections;
end;


// TODO il faut renvoyer un tempPlateau et pas modifier l'ancien
procedure placementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur);
var
  hexagonesSelectionnes: THexagones;
  i: Integer;
begin

  // // Demande à l'utilisateur de sélectionner deux hexagones pour la connexion
  // hexagonesSelectionnes := ClicConnexion();

  // // Vérifie si la connexion est valide avec les hexagones sélectionnés
  // if connexionValide(hexagonesSelectionnes, plateau, joueur) then
  // begin
  //   // Ajoute la connexion au plateau
  //   SetLength(plateau.Connexions, Length(plateau.Connexions) + 1);
  //   plateau.Connexions[High(plateau.Connexions)].IdJoueur := joueur.Id;

  //   // Enregistre les positions des hexagones pour la connexion
  //   for i := 0 to High(hexagonesSelectionnes.Positions) do
  //   begin
  //     plateau.Connexions[High(plateau.Connexions)].Position[i] := hexagonesSelectionnes.Positions[i];
  //   end;

  //   // Déduit les ressources nécessaires au joueur

    // TODO deplacer dans verificationRessouce / achatElement
    // joueur.Ressources[Mathematiques] := joueur.Ressources[Mathematiques] - 1;
    // joueur.Ressources[Physique] := joueur.Ressources[Physique] - 1;
    // joueur.Ressources[Chimie] := joueur.Ressources[Chimie] - 1;

    WriteLn('Connexion placée avec succès !');
  // end
  // else
  // begin
  //   WriteLn('Impossible de placer la connexion : vérifiez les ressources ou la position choisie.');
  // end;
  //TODO ne pas reafficher tout l'affichage de 0 mais afficher que la nouvelle connexion
    // affichageGrille(plateau, affichage);
end;


end.


