unit achat;


interface
uses Types;

procedure placementEleve(var plateau: TPlateau;affichage: TAffichage);
procedure placementConnexion(var plateau: TPlateau;affichage:TAffichage);
procedure verificationPointsVictoire(var joueurs: TJoueurs;gagner : boolean ;gagnant : integer) ;
procedure affichageGagnant(joueur : TJoueur;affichage: TAffichage);
procedure achatElements(joueur : TJoueur;plateau : TPlateau;affichage: TAffichage);

implementation

procedure placementEleve(var plateau: TPlateau;affichage: TAffichage);
begin
  writeln('placementEleve actier');
end;

procedure placementConnexion(var plateau: TPlateau;affichage:TAffichage);
begin
  writeln('placementConnexion actier')
end;

procedure verificationPointsVictoire(var joueurs: TJoueurs;gagner : boolean ;gagnant : integer) ;
begin
  writeln('verificationPointsVictoire actier');
  gagner:=false;
end;

procedure affichageGagnant(joueur : TJoueur;affichage: TAffichage);
begin
  writeln('affichageGagnant');
end;

procedure achatElements(joueur : TJoueur;plateau : TPlateau;affichage: TAffichage);
begin
  writeln('achatElements');
end;

end.