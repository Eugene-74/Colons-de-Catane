unit achat;

interface

uses
  Types, affichageUnit,traitement;

procedure ChangementProfesseur(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur;retraitRessources:Boolean);
procedure achatElements(var joueur: TJoueur; var plateau: TPlateau; var affichage: TAffichage);
procedure PlacementEleve(plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur;retraitRessources:Boolean);
procedure placementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur;retraitRessources:Boolean);
procedure verificationPointsVictoire(plateau : TPlateau; joueurs: TJoueurs; var gagner: Boolean; var gagnant: Integer);
procedure affichageGagnant(joueur: TJoueur; affichage: TAffichage);
function ClicConnexion(var affichage: TAffichage; plateau: TPlateau): TCoords;
function connexionValide(hexagonesSelectionnes: TCoords; plateau: TPlateau; joueur: TJoueur): Boolean;
function ClicPersonne(affichage: TAffichage; plateau: TPlateau; estEleve: Boolean): TCoords;
function CountPersonnes(personnes: array of TPersonne; estEleve: Boolean; joueur: TJoueur): Integer;
function PersonneValide(plateau: TPlateau; HexagonesCoords: TCoords; estEleve: Boolean; joueurActuel: TJoueur): Boolean;
function VerifierAdjacencePersonnes(HexagonesCoords: TCoords; plateau: TPlateau): Boolean;

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
    1: 
     
      if (joueur.Ressources[Mathematiques] >= 1) and 
         (joueur.Ressources[Humanites] >= 1) and 
         (joueur.Ressources[Chimie] >= 1) and 
         (joueur.Ressources[Physique] >= 1) then
      begin
        placementEleve(plateau, affichage, joueur,True);
      end
      else
        WriteLn('Vous n''avez pas les ressources nécessaires pour acheter un élève.');
    
    2: 
     
      if (joueur.Ressources[Humanites] >= 1) and 
         (joueur.Ressources[Physique] >= 1) then
      begin
        placementConnexion(plateau, affichage, joueur,True);
      end
      else
        WriteLn('Vous n''avez pas les ressources nécessaires pour acheter une connexion.');
    
    3: 
    
      if (joueur.Ressources[Mathematiques] >= 2) and 
         (joueur.Ressources[Physique] >= 1) then
      begin
        changementProfesseur(plateau, affichage, joueur,True);
      end
      else
        WriteLn('Vous n''avez pas les ressources nécessaires pour changer un élève en professeur.');
  
  else
    WriteLn('Choix invalide.');  // Affiche si le choix n'est pas valide
  end;
end;



procedure placementEleve( plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur;retraitRessources:Boolean);
var
 HexagonesCoords: TCoords;
begin
  HexagonesCoords := ClicPersonne(affichage,plateau,True); 

  if PersonneValide(plateau, HexagonesCoords, True, joueurActuel) then
  begin
   
    
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

    affichageGrille(plateau, affichage); 
    if retraitRessources then
    begin
        joueurActuel.Ressources[Mathematiques] := joueurActuel.Ressources[Mathematiques] - 1;
        joueurActuel.Ressources[Humanites] := joueurActuel.Ressources[Humanites] - 1;
        joueurActuel.Ressources[Chimie] := joueurActuel.Ressources[Chimie] - 1;
        joueurActuel.Ressources[Physique] := joueurActuel.Ressources[Physique] - 1;
    end;
    WriteLn('Élève placé avec succès !');
  end
  else
  begin
    WriteLn('Placement invalide. Vérifiez les conditions de placement.');
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

  // Vérifie la présence d'une personne adjacente

    if  VerifierAdjacencePersonnes(HexagonesCoords,plateau) then
    begin
        PersonneValide := False; 
    end
    else
        personneAdjacente := True; 
   
  
 
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
  i, j, k, nombreAdjacents: Integer;
begin
   VerifierAdjacencePersonnes:= False;
  for i := 0 to High(plateau.Personnes-1) do
  begin
    nombreAdjacents := 0;
    for j := 0 to High(HexagonesCoords)-1 do
    begin
      for k := 0 to 2 do
      begin
        if sontAdjacentes(HexagonesCoords[j], plateau.Personnes[i].Position[k]) then
        begin
          Inc(nombreAdjacents);  
          Break;
        end;
      end;
      if nombreAdjacents >= 2 then
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

procedure ChangementProfesseur(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur;retraitRessources:Boolean);
var
  HexagonesCoords: TCoords;
  i, j, k, compteur: Integer;
  estConverti: Boolean;
begin
  // Appeler ClicPersonne pour récupérer les hexagones sélectionnés
  HexagonesCoords := ClicPersonne(affichage, plateau, False); 
  compteur := 0;

  // Vérifie si les hexagones sont adjacents
  if enContact(HexagonesCoords) then
  begin
    estConverti := False;
    // Parcourt les personnes du plateau pour trouver un élève appartenant au joueur actuel
    for i := 0 to High(plateau.Personnes)-1 do
    begin
      if (plateau.Personnes[i].IdJoueur = joueurActuel.Id) and
         (plateau.Personnes[i].estEleve) then
      begin
        compteur := 0; // Réinitialise le compteur pour cette personne
        // Parcourt les positions de la personne pour vérifier la correspondance avec les hexagones sélectionnés
        for j := 0 to  High(HexagonesCoords)-1 do
        begin
          // Compare chaque position de la personne avec les coordonnées sélectionnées
          for k := 0 to High(HexagonesCoords)-1 do
          begin
            if (plateau.Personnes[i].Position[j].x = HexagonesCoords[k].x) and
               (plateau.Personnes[i].Position[j].y = HexagonesCoords[k].y) then
            begin
              compteur := compteur + 1;
              Break; // Passe à la prochaine position une fois une correspondance trouvée
            end;
          end;
        end;

        // Si toutes les positions de la personne correspondent aux hexagones sélectionnés, effectuer la conversion
        if compteur = 3 then
        begin
          if(retraitRessources) then
          begin
            joueurActuel.Ressources[Mathematiques] := joueurActuel.Ressources[Mathematiques] - 2;
            joueurActuel.Ressources[Physique] := joueurActuel.Ressources[Physique] - 1;
          end;
          plateau.Personnes[i].estEleve := False; // Convertir l'élève en professeur
          estConverti := True;
          WriteLn('Élève converti en professeur avec succès !');
          Break; 
        end;
      end;
      if estConverti then
        Break;
    end;

  //   if not estConverti then
  //     WriteLn('Aucun élève trouvé à convertir sur les hexagones sélectionnés.');

    affichageGrille(plateau, affichage);
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


procedure verificationPointsVictoire(plateau : TPlateau;joueurs: TJoueurs; var gagner: Boolean; var gagnant: Integer);
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
    j := j+1;

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
    
    if points[j] > 10 then
    begin
      gagner := True;       
      gagnant := j+1; 
      Break;
    end;
  end;


end;


procedure affichageGagnant(joueur: TJoueur; affichage: TAffichage);
begin
  WriteLn('Félicitations, ', joueur.Nom, ' ! Vous avez gagné la partie avec ', joueur.Points, ' points.');
   
end;




function connexionValide(hexagonesSelectionnes: TCoords; plateau: TPlateau; joueur: TJoueur): Boolean;
var
  i, j: Integer;
  positionDisponible: Boolean;
begin


  positionDisponible := True;

  // Parcourt les connexions pour vérifier si l'une des positions de hexagonesSelectionnes est déjà occupée
  for i := 0 to High(plateau.Connexions) do
  begin
    for j := 0 to High(hexagonesSelectionnes.Positions) do
    begin
      if ((plateau.Connexions[i].Position[0].x = hexagonesSelectionnes[j].x) and
          (plateau.Connexions[i].Position[0].y = hexagonesSelectionnes[j].y)) or
         ((plateau.Connexions[i].Position[1].x = hexagonesSelectionnes[j].x) and
          (plateau.Connexions[i].Position[1].y = hexagonesSelectionnes[j].y)) then
      begin
      
      // connespond à un return (pour fonction)
      connexionValide := False;
      exit;
      end; 
    end;
    if not positionDisponible then
      Break; 
  end;

  connexionValide :=positionDisponible;
end;

function ClicConnexion(var affichage: TAffichage; plateau: TPlateau): TCoords;
var
  i: Integer;
  selections: TCoords;
begin
  writeln('Cliquez sur deux hexagones entre lesquels vous voulez placer la connexion');
  SetLength(selections, 2); 

  for i := 0 to 1 do
  begin
    clicHexagone(plateau, affichage, selections[i]);
  end;

  ClicConnexion := selections;
end;

procedure placementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueur: TJoueur;retraitRessources:Boolean);
var
  hexagonesSelectionnes: TCoords;
  i: Integer;
begin
  hexagonesSelectionnes := ClicConnexion(affichage, plateau);

  if connexionValide(hexagonesSelectionnes, plateau, joueur) then
  begin
    // Agrandit le tableau des connexions pour ajouter une nouvelle entrée
    SetLength(plateau.Connexions,1);
    plateau.Connexions[0].IdJoueur := joueur.Id;

    // Définit la taille du tableau Position pour la nouvelle connexion et enregistre les positions
    SetLength(plateau.Connexions[0].Position, 2);
    for i := 0 to Length(hexagonesSelectionnes) - 1 do
    begin
      plateau.Connexions[0].Position[i] := hexagonesSelectionnes[i];
    end;
    if retraitRessources then
    begin
      joueur.Ressources[Mathematiques] := joueur.Ressources[Mathematiques] - 1;
      joueur.Ressources[Physique] := joueur.Ressources[Physique] - 1;
      joueur.Ressources[Chimie] := joueur.Ressources[Chimie] - 1;
    end;

    WriteLn('Connexion placée avec succès !');
  end
  else
  begin
    WriteLn('Impossible de placer la connexion : vérifiez les ressources ou la position choisie.');
  end;

  // Affiche seulement la nouvelle connexion dans la grille pour éviter une réinitialisation complète
  affichageGrille(plateau, affichage);
end;



end.