unit gestion;

interface
uses Types,affichageUnit,SysUtils,achat;
function chargementPlateau(num : Integer): TPlateau;
procedure initialisationPartie(var joueurs : TJoueurs;var  plateau : TPlateau;var affichage : TAffichage);
procedure partie(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);




implementation

function chargerGrille(num : Integer): TGrille;
var 
  grille: TGrille;
  numeros: array of array of Integer;
  ressources: array of array of TRessource;
  i, j: Integer;
begin
// Tableau static pose des problème

  if(num = 1) then 
    begin
    SetLength(grille, 7, 7);
    SetLength(ressources, 7, 7);
    SetLength(numeros, 7, 7);

    ressources[0] := [Aucune, Aucune, Aucune, Aucune, Aucune, Aucune, Aucune];
    ressources[1] := [Aucune, Aucune, Aucune, Humanites, Mathematiques, Chimie, Aucune];
    ressources[2] := [Aucune, Aucune, Mathematiques, Chimie, Informatique, Physique, Aucune];
    ressources[3] := [Aucune, Humanites, Informatique, Rien, Humanites, Chimie, Aucune];
    ressources[4] := [Aucune, Physique, Mathematiques, Informatique, Physique, Aucune, Aucune];
    ressources[5] := [Aucune, Physique, Humanites, Mathematiques, Aucune, Aucune, Aucune];
    ressources[6] := [Aucune, Aucune, Aucune, Aucune, Aucune, Aucune, Aucune];
    numeros[0] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[1] := [-1, -1, -1, 6, 3, 8, -1];
    numeros[2] := [-1, -1, 2, 9, 11, 4, -1];
    numeros[3] := [-1, 5, 4, -1, 3, 11, -1];
    numeros[4] := [-1, 10, 5, 6, 12, -1, -1];
    numeros[5] := [-1, 8, 10, 9, -1, -1, -1];
    numeros[6] := [-1, -1, -1, -1, -1, -1, -1];
    end
  else if(num = 2) then 
    begin
    SetLength(grille, 5, 5);
    SetLength(ressources, 5, 5);
    SetLength(numeros, 5, 5);

    // ressources[0] := [Aucune, Aucune, Aucune, Aucune, Aucune, Aucune, Aucune];
    ressources[0] := [Aucune, Aucune, Humanites, Mathematiques, Chimie];
    ressources[1] := [Aucune, Mathematiques, Chimie, Informatique, Physique];
    ressources[2] := [Humanites, Informatique, Rien, Humanites, Chimie];
    ressources[3] := [Physique, Mathematiques, Informatique, Physique, Aucune];
    ressources[4] := [Physique, Humanites, Mathematiques, Aucune, Aucune];
    // ressources[6] := [Aucune, Aucune, Aucune, Aucune, Aucune, Aucune, Aucune];
    // numeros[0] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[0] := [-1, -1, 6, 3, 8];
    numeros[1] := [-1, 2, 9, 11, 4];
    numeros[2] := [5, 4, -1, 3, 11];
    numeros[3] := [10, 5, 6, 12, -1];
    numeros[4] := [8, 10, 9, -1, -1];
    // numeros[6] := [-1, -1, -1, -1, -1, -1, -1];
    end
  else 
    begin
    SetLength(grille, 7, 7);
    SetLength(ressources, 7, 7);
    SetLength(numeros, 7, 7);

    ressources[0] := [Physique, Physique, Physique, Physique, Physique, Physique, Physique];
    ressources[1] := [Physique, Physique, Physique, Physique, Physique, Physique, Physique];
    ressources[2] := [Physique, Physique, Physique, Physique, Physique, Physique, Physique];
    ressources[3] := [Physique, Physique, Physique, Physique, Physique, Physique, Physique];
    ressources[4] := [Physique, Physique, Physique, Physique, Physique, Physique, Physique];
    ressources[5] := [Physique, Physique, Physique, Physique, Physique, Physique, Physique];
    ressources[6] := [Physique, Physique, Physique, Physique, Physique, Physique, Physique];
    numeros[0] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[1] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[2] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[3] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[4] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[5] := [-1, -1, -1, -1, -1, -1, -1];
    numeros[6] := [-1, -1, -1, -1, -1, -1, -1];
    end;


  for i := 0 to 6 do
    for j := 0 to 6 do
    begin
      grille[i, j].ressource := ressources[i][j];
      grille[i, j].numero := numeros[i][j];
    end;

  chargerGrille := grille;
end;



function chargementPlateau(num : Integer): TPlateau;
var
  grille: TGrille;
  plat : TPlateau;
begin

  grille := chargerGrille(num);
  if(num = 1) then
    begin
    plat.Grille := grille;
    plat.Souillard.Position.x := 3;
    plat.Souillard.Position.y := 3;
    end
   else if(num = 2) then
    begin
      plat.Grille := grille;
      plat.Souillard.Position.x := 2;
      plat.Souillard.Position.y := 2;
    end;
  

  chargementPlateau := plat;
    
end;

function tirerCarteTutorat(var cartesTutorat : TCartesTutorat):TCarteTutorat;
var carteTutorat : TCarteTutorat;
  i,nbrTotal: Integer;
begin
  carteTutorat.nom := '';
  carteTutorat.description := '';
  carteTutorat.nbr := 0;
  Randomize();

  // TODO penser à verif que il en reste avant d'accepter l'achat 
  nbrTotal := cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr + cartesTutorat.carte3.nbr + cartesTutorat.carte4.nbr + cartesTutorat.carte5.nbr;

  i := Random(nbrTotal) + 1;
  if (i >= 1) and (i <= cartesTutorat.carte1.nbr) then
    begin
    carteTutorat.nom := cartesTutorat.carte1.nom;
    carteTutorat.description := cartesTutorat.carte1.description;
    carteTutorat.nbr := 1;

    cartesTutorat.carte1.nbr := cartesTutorat.carte1.nbr - 1; 
    end
  else if (i > cartesTutorat.carte1.nbr) and (i <= cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr) then
    begin
    carteTutorat.nom := cartesTutorat.carte2.nom;
    carteTutorat.description := cartesTutorat.carte2.description;
    carteTutorat.nbr := 1;

    cartesTutorat.carte2.nbr := cartesTutorat.carte2.nbr - 1; 
    end
  else if (i > cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr) and (i <= cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr + cartesTutorat.carte3.nbr) then
    begin
    carteTutorat.nom := cartesTutorat.carte3.nom;
    carteTutorat.description := cartesTutorat.carte3.description;
    carteTutorat.nbr := 1;

    cartesTutorat.carte3.nbr := cartesTutorat.carte3.nbr - 1;
    end
  else if (i > cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr + cartesTutorat.carte3.nbr) and (i <= cartesTutorat.carte1.nbr + cartesTutorat.carte2.nbr + cartesTutorat.carte3.nbr + cartesTutorat.carte4.nbr) then
    begin
    carteTutorat.nom := cartesTutorat.carte4.nom;
    carteTutorat.description := cartesTutorat.carte4.description;
    carteTutorat.nbr := 1;

    cartesTutorat.carte4.nbr := cartesTutorat.carte4.nbr - 1;
    end
  else
    begin
    carteTutorat.nom := cartesTutorat.carte5.nom;
    carteTutorat.description := cartesTutorat.carte5.description;
    carteTutorat.nbr := 1;

    cartesTutorat.carte5.nbr := cartesTutorat.carte5.nbr - 1;
    end;



  tirerCarteTutorat := carteTutorat;
end;



function intialisationTutorat():TCartesTutorat;
begin

intialisationTutorat := CARTES_TUTORAT;
end;

procedure initialisationPartie(var joueurs : TJoueurs;var plateau : TPlateau;var affichage : TAffichage);
var i,num : integer;
  coord : Tcoord;
  text : string;
  stop : Boolean;
  res : TRessources;
  r : Tressource;
  cartesTutorat : TCartesTutorat;
begin

  cartesTutorat := intialisationTutorat();
  plateau.cartesTutorat := cartesTutorat;

  for r := Aucune to Mathematiques do
    res[r] := 0;
  stop := false;
  SetLength(joueurs,0);
  i:=0;
  repeat
    write('rentrer le nom du joueur '+IntToStr(i+1)+' : (0 pour arêter)');
    readln(text);
    if(text <> '0') then
      begin
      SetLength(joueurs,i+1);
      joueurs[i].Nom:= text;
      joueurs[i].Points :=0;
      joueurs[i].Ressources := res;
      joueurs[i].Id := i;
      
      i := i + 1;
      end
    else 
      begin
        if(i < 2)then
          writeln('Le nombre de joueur doit être de au moins 2')
        else 
          stop := true;
      end;
  until ((i>3) or (stop));


  SetLength(plateau.Connexions, 1);
  SetLength(plateau.Connexions[0].Position, 2);

  initialisationAffichage(affichage);

  num :=1;

  plateau := chargementPlateau(num);
  affichageTour(plateau, joueurs, affichage);
  
  for i:=1 to length(joueurs) do
    begin
    // TODO re mettre apres
    
    // placementEleve(plateau,affichage,joueurs[i-1]);
    // placementConnexion(plateau,affichage,joueurs[i-1]);
    end;

  for i:=length(joueurs) downto 1 do
    begin


    // placementEleve(plateau,affichage,joueurs[i-1]);
    // placementConnexion(plateau,affichage,joueurs[i-1]);
    end;

  SetLength(plateau.Connexions, 1);
  SetLength(plateau.Connexions[0].Position, 2);
  plateau.Connexions[0].Position[0].x := 2;
  plateau.Connexions[0].Position[0].y := 3;
  plateau.Connexions[0].Position[1].x := 3;
  plateau.Connexions[0].Position[1].y := 3;
  plateau.Connexions[0].IdJoueur := 0;

  setLength(plateau.Connexions, 2);
  SetLength(plateau.Connexions[1].Position, 2);
  plateau.Connexions[1].Position[0].x := 3;
  plateau.Connexions[1].Position[0].y := 2;
  plateau.Connexions[1].Position[1].x := 3;
  plateau.Connexions[1].Position[1].y := 3;
  plateau.Connexions[1].IdJoueur := 1;

  affichageTour(plateau,joueurs, affichage);
  

end;


function nombreAleatoire(n : Integer): Integer;
begin
  Randomize;
  nombreAleatoire := Random(n) + 1;
end;

    
procedure deplacementSouillard(var plateau : TPlateau; var affichage : TAffichage);
begin
  writeln('deplacementSouillard activer');
end;


procedure distributionConnaissance(var joueurs : TJoueurs;var plateau : TPlateau;des : integer);
var q,r : integer;
  res : Tressource;
  perso : TPersonne;
  coord,coo : Tcoord;
begin
  for r:=0 to length(plateau.Grille) -1 do
    for q:=0 to length(plateau.Grille)-1 do 
      begin
        if (plateau.Grille[q,r].Numero = des) then 
          begin
            
          res := plateau.Grille[q,r].ressource;
          coord.x := q;
          coord.y := r;
          for perso in plateau.Personnes do 
            begin
              for coo in perso.Position do 
                begin
                if((coo.x = coord.x )and (coo.y = coord.y))then
                  joueurs[perso.IdJoueur].Ressources[res] := joueurs[perso.IdJoueur].Ressources[res] +1 ;
                end;
            end;
          end;
      end;

end;

procedure gestionDes(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);
var
  des,des1, des2: Integer;
begin

  des1 := nombreAleatoire(6);
  des2 := nombreAleatoire(6);
  des := des1 + des2;
  if(des = 7)then
    deplacementSouillard(plateau,affichage)
  else 
    begin
      distributionConnaissance(joueurs,plateau,des);
    end;
  


end;

procedure tour(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);
var valeurBouton : String;
  finTour : boolean;
  ressources1,ressources2 : TRessources;
  i : Integer;
begin
  for i := 0 to length(joueurs)-1 do 
    begin
    // j := joueurs[i];
    finTour := False;
    repeat
      
      clicAction(affichage, valeurBouton);

      writeln(valeurBouton);
      if(valeurBouton = 'achat_connexion')  then
        placementConnexion(plateau,affichage,joueurs[i])
      else if(valeurBouton = 'achat_eleve')  then
        placementEleve(plateau,affichage,joueurs[i])
        // les point ne s'affiche pas
      else if(valeurBouton = 'achat_carte_tutorat')  then
        writeln('achat carte tutorat')
      else if(valeurBouton = 'changement_en_prof')  then
        changementProfesseur(plateau,affichage,joueurs[i])
      else if(valeurBouton = 'echange')  then
        begin
        echangeRessources(joueurs, joueurs[i].Id, joueurs[i].Id,ressources1,ressources2,affichage);
        writeln('echange bis');
        affichageTour(plateau, joueurs, affichage);

        // TODO verifier que l'échange est possible
        end
      else if(valeurBouton = 'fin_tour')  then
        finTour := True;

    until (finTour);   
    writeln(joueurs[i].Nom);
    writeln(joueurs[i].Id);
    writeln(joueurs[i].Points);

     
    writeln('fin fin de tour');
    end;


end;

procedure partie(var joueurs: TJoueurs;var plateau:TPlateau;var affichage:TAffichage);
var gagnant : integer;
  gagner : boolean;
begin
  repeat
    tour(joueurs,plateau,affichage);

    verificationPointsVictoire(plateau,joueurs,gagner,gagnant);
  until (gagner);
  affichageGagnant(joueurs[gagnant],affichage);

end;


procedure utiliserCarte1(var plateau : TPlateau; var affichage : TAffichage;joueur : Tjoueur);
begin
placementConnexion(plateau,affichage,joueur);
placementConnexion(plateau,affichage,joueur);

end;

procedure utiliserCarte2(var plateau : TPlateau;var affichage : TAffichage;joueur : Tjoueur);
begin
affichageTexte('Deplacement du souillard par le joueur '+joueur.nom,0,plateau.Souillard.Position,affichage);
deplacementSouillard(plateau, affichage);

end;

procedure utiliserCarte3(var plateau : TPlateau; joueur : Tjoueur);
// var joueurAVoler : TJoueur;
begin
// VOLER UNE CONNAISSANCE

// choix du joueur

// choix du type de ressources a voler
// ON EST PAS SENCER CONNAITER LES CARTES DES AUTRES
end;

procedure utiliserCarte4(var plateau : TPlateau; joueur : Tjoueur);
begin
// CHOISIR 2 CONNAISSANCE



end;

procedure utiliserCarte5(var joueurs : TJoueurs;joueur : Tjoueur);
var j : Tjoueur;
begin
for j in joueurs do
  if(j.Id = joueur.Id) then
    joueur.Points := joueur.Points + 1;


end;

procedure utiliserCarteTutorat(var plateau : TPlateau;var affichage : TAffichage;var joueurs : TJoueurs; joueur : Tjoueur;nom : String);
begin
  if nom = plateau.cartesTutorat.carte1.nom then
  begin
    writeln('Utilisation de la carte ', plateau.cartesTutorat.carte1.nom);
    utiliserCarte1(plateau,affichage,joueur);

  end
  else if nom = plateau.cartesTutorat.carte2.nom then
  begin
    writeln('Utilisation de la carte ', plateau.cartesTutorat.carte2.nom);
    utiliserCarte2(plateau, affichage, joueur);

  end
  else if nom = plateau.cartesTutorat.carte3.nom then
  begin
    writeln('Utilisation de la carte ', plateau.cartesTutorat.carte3.nom);
    utiliserCarte3(plateau,joueur);

  end
  else if nom = plateau.cartesTutorat.carte4.nom then
  begin
    writeln('Utilisation de la carte ', plateau.cartesTutorat.carte4.nom);
    utiliserCarte4(plateau,joueur);

  end
  else if nom = plateau.cartesTutorat.carte5.nom then
  begin
    writeln('Utilisation de la carte ', plateau.cartesTutorat.carte5.nom);
    utiliserCarte5(joueurs,joueur);

  end
  else
  begin
    writeln('Carte inconnue');
  end;
end;

end.