unit achat;

interface

uses
  Types, affichageUnit,traitement;

procedure ChangementProfesseur(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
procedure achatElements(var joueur: TJoueur; var plateau: TPlateau; var affichage: TAffichage);
procedure PlacementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
procedure PlacementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
procedure verificationPointsVictoire(var joueurs: TJoueurs; var gagner: Boolean; var gagnant: Integer);
procedure affichageGagnant(joueur: TJoueur; affichage: TAffichage);
function ClicConnexion(var plateau: TPlateau; var affichage: TAffichage): THexagone;
function connexionValide(hex: THexagone; plateau: TPlateau; joueur: TJoueur): Boolean;
function ClicPersonne(var plateau: TPlateau; var affichage: TAffichage; estEleve: Boolean): THexagone;
function CountPersonnes(personnes: array of TPersonne; estEleve: Boolean; joueur: TJoueur): Integer;
function PersonneValide(plateau: TPlateau; hexagoneSelectionne: THexagone; estEleve: Boolean; joueurActuel: TJoueur): Boolean;

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
    1: PlacementEleve(plateau, affichage, joueur);
    2: PlacementConnexion(plateau, affichage, joueur);
    3: ChangementProfesseur(plateau, affichage, joueur);
  else
    WriteLn('Choix invalide.');  // Affiche si le choix n'est pas valide
  end;
end;


procedure PlacementEleve(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
var
  hexagoneSelectionne: THexagone;
begin
  hexagoneSelectionne := ClicPersonne(plateau,affichage,True);

  if PersonneValide(plateau, hexagoneSelectionne, True, joueurActuel) then
  begin
    
    joueurActuel.Ressources[Mathematiques] := joueurActuel.Ressources[Mathematiques] - 1;
    joueurActuel.Ressources[Humanites] := joueurActuel.Ressources[Humanites] - 1;
    joueurActuel.Ressources[Chimie] := joueurActuel.Ressources[Chimie] - 1;
    joueurActuel.Ressources[Physique] := joueurActuel.Ressources[Physique] - 1;

    
    SetLength(plateau.Personnes, Length(plateau.Personnes) + 1);
    with plateau.Personnes[High(plateau.Personnes)] do
    begin
      // Positionner l'élève sur le numéro de l'hexagone sélectionné
      SetLength(Position, 1);
      Position[0].x := 0; // A faire***********************************************************************
      Position[0].y := 0;// 
      
      estEleve := True;
      IdJoueur := joueurActuel.Id;
    end;
    affichageGrille(plateau, affichage);
    WriteLn('Élève placé avec succès !');
  end
  else
  begin
    WriteLn('Placement invalide. Vérifiez les conditions de placement.');
  end;
end;

function PersonneValide(plateau: TPlateau; hexagoneSelectionne: THexagone; estEleve: Boolean; joueurActuel: TJoueur): Boolean;
var
  i: Integer;
  personneAdjacente, ressourcesSuffisantes, Result: Boolean;
begin
  personneAdjacente := False;
  ressourcesSuffisantes := False;

  // Vérifie la présence d'une personne adjacente
  for i := 0 to High(plateau.Personnes) do
  begin
    if enContact(hexagoneSelectionne) then
    begin
      // Vérifie que la personne adjacente n'est pas un élève ou un professeur du même joueur
      if plateau.Personnes[i].IdJoueur = joueurActuel.Id then
      begin
        if plateau.Personnes[i].estEleve = estEleve then
        begin
          Result := False; // Ne peut pas être adjacent à une personne du même type
          Exit;
        end;
      end;
      personneAdjacente := True; // Marque la case comme ayant une personne adjacente
    end;
  end;

  // Vérifie les ressources et la limite d'unités pour l'élève ou le professeur
  if estEleve then
  begin
    // Conditions de ressources et limite pour un élève
    ressourcesSuffisantes := (joueurActuel.Ressources[Mathematiques] >= 1) and
                             (joueurActuel.Ressources[Humanites] >= 1) and
                             (joueurActuel.Ressources[Chimie] >= 1) and
                             (joueurActuel.Ressources[Physique] >= 1) and
                             (CountPersonnes(plateau.Personnes, True, joueurActuel) <= 5);
  end
  else // Cas du professeur
  begin
    // Conditions de ressources et limite pour un professeur
    ressourcesSuffisantes := (joueurActuel.Ressources[Mathematiques] >= 2) and
                             (joueurActuel.Ressources[Physique] >= 1) and
                             (CountPersonnes(plateau.Personnes, False, joueurActuel) <= 3);
  end;


  Result := ressourcesSuffisantes and personneAdjacente;
  PersonneValide:=result
end;


function ClicPersonne(var plateau: TPlateau; var affichage: TAffichage; estEleve: Boolean): THexagone;
var
  hexagoneSelectionne: THexagone;
  coord: TCoord;
begin
  if estEleve then
    writeln('Cliquez sur l''endroit où vous voulez placer l''élève')
  else
    writeln('Cliquez sur l''endroit où vous voulez placer le professeur');

  
  clicHexagone(plateau, affichage, coord);
  
  hexagoneSelectionne := plateau.Grille[affichage.xGrid, affichage.yGrid];
  
 
  ClicPersonne:= hexagoneSelectionne;
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
  hexagoneSelectionne: THexagone;
  i: Integer;
begin
  hexagoneSelectionne := ClicPersonne(plateau, affichage, False); 
  if PersonneValide(plateau, hexagoneSelectionne, False, joueurActuel) then
  
    begin
      joueurActuel.Ressources[Mathematiques] := joueurActuel.Ressources[Mathematiques] - 2;
      joueurActuel.Ressources[Physique] := joueurActuel.Ressources[Physique] - 1;

      // Convertir l'élève en professeur sur le plateau
      for i := 0 to High(plateau.Personnes) do
      begin
        if (plateau.Personnes[i].IdJoueur = joueurActuel.Id) and
           (plateau.Personnes[i].estEleve) and
           (plateau.Personnes[i].Position[0].x =0 )and// ********A faire: recuperer les coordonnée****************************
           (plateau.Personnes[i].Position[0].y = 0) then
        begin
          plateau.Personnes[i].estEleve := False; // Changer l'élève en professeur
          WriteLn('Élève converti en professeur avec succès !');
          Break;
        end;
      end;

     
      affichageGrille(plateau, affichage);
    end
    
  else
    WriteLn('Conversion invalide. Vérifiez les conditions de placement.');
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




function connexionValide(hex: THexagone; plateau: TPlateau; joueur: TJoueur): Boolean;
var
  i: Integer;
  ressourcesSuffisantes, positionDisponible,Result: Boolean;
begin
  ressourcesSuffisantes := (joueur.Ressources[Mathematiques] >= 1) and
                           (joueur.Ressources[Physique] >= 1) and
                           (joueur.Ressources[Chimie] >= 1);

  positionDisponible := True;

  // Vérifie s'il y a des connexions adjacentes dans la zone de l'hexagone sélectionné
  for i := 0 to High(plateau.Connexions) do
  begin
    if enContact(hex) then
    begin
      if plateau.Connexions[i].IdJoueur = joueur.Id then
      begin
        positionDisponible := False; // La connexion ne peut pas être placée ici
        Break;
      end;
    end;
  end;

  // La connexion est valide si les ressources sont suffisantes et la position disponible
  Result := ressourcesSuffisantes and positionDisponible;
  connexionValide:=Result;
end;





function ClicConnexion(var plateau: TPlateau; var affichage: TAffichage): THexagone;
var
  hexagoneSelectionne: THexagone;
  coord: TCoord;
begin
  writeln('Cliquez sur l''endroit où vous voulez placer la connexion');

  clicHexagone(plateau, affichage, coord);

  hexagoneSelectionne := plateau.Grille[affichage.xGrid, affichage.yGrid];

  ClicConnexion := hexagoneSelectionne;
end;


procedure PlacementConnexion(var plateau: TPlateau; var affichage: TAffichage; var joueurActuel: TJoueur);
var
  hexagoneSelectionne: THexagone;
begin
  hexagoneSelectionne := ClicConnexion(plateau, affichage);

  if ConnexionValide( hexagoneSelectionne,plateau, joueurActuel) then
  begin
    joueurActuel.Ressources[Humanites] := joueurActuel.Ressources[Humanites] - 1; 
    joueurActuel.Ressources[Mathematiques] := joueurActuel.Ressources[Mathematiques] - 1; 
    // Ajouter la connexion sur le plateau
    SetLength(plateau.Connexions, Length(plateau.Connexions) + 1);
    with plateau.Connexions[High(plateau.Connexions)] do
    begin
      SetLength(Position, 1); 
      Position[0].x := 0; //A faire**************************************************************************
      Position[0].y := 0;
      IdJoueur := joueurActuel.Id;
    end;

    WriteLn('Connexion placée avec succès !');
  end
  else
  begin
    WriteLn('Placement de la connexion invalide. Vérifiez les conditions.');
  end;
end;

end.


