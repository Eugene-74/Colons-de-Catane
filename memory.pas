program memory;
Uses Crt;
Type 
	carte = record
		visible : Boolean;
		valeur : String;


	end;
	plateau = record
		tableau : Array of Array of carte;
		length : Integer;


	end;
	
	joueur = record
		nom : String;
		score : Integer;
	end;
	
const 
	TAILLE_PLATEAU_FACILE = 4;
	TAILLE_PLATEAU_DIFFICILE = 6;
	
	CASE_FACILE : Array [1..16] of String = ('1','1','2','2','3','3','4','4','5','5','6','6','7','7','8','8');
	CASE_DIFFICILE : Array [1..36] of String = ('1','1','2','2','3','3','4','4','5','5','6','6','7','7','8','8','9','9','10','10','11','11','12','12','13','13','14','14','15','15','16','16','17','17','18','18');



procedure affichage(plat : plateau );
var i,j : Integer;
begin

	for i := 0 to plat.length-1 do 
	begin
		for j := 0 to plat.length-1 do 
		begin;
		if (plat.tableau[i][j].visible) then
			write(plat.tableau[i][j].valeur)
		else 
			write('#');
		end;
		writeln();
	end;
end;

function getNom():String;
begin
	writeln('Quel est votre nom ?');
	readln(getNom);
end;

procedure lireScore();
var fichier : file of joueur;
	j : joueur;
	i : Integer;
begin
	i:= 1;
	assign(fichier, 'save 5 top player.txt');
	reset(fichier);
	while not eof(fichier) do 
	begin
		read(fichier,j); // peut etre readln ...
		write(i);
		write('/ ');
		write(j.nom);
		write(' avec un score de ');
		writeln(j.score);
		i := i +1;
	end;
end;

function getDifficult():boolean;
var val : String; 
	difficile : boolean;
begin
	repeat
	writeln('Quel difficulté voulez vous ? f = facile, d = difficile');
	readln(val);
	difficile := false;
	if(val = 'd')then
		difficile := true;
	until (val = 'f') or (val = 'd');
	getDifficult := difficile ;
end;

function getReprendre():boolean;
var partieDejaEnCours : boolean;
	val : String;
begin
	getReprendre := false;
	partieDejaEnCours := false; // a modifier evidement
	if(partieDejaEnCours) then
	begin
		
		writeln('Voulez vous reprendre la partie commencer ? (o/n) ');
		
		readln(val);
		if(val = 'o') then
			getReprendre := true;
	end;
end;
function chargerPlateau():plateau ;
var plat : plateau;
begin
// charge le tableau ... 
chargerPlateau := plat;
end;

function creePlateau(difficile : boolean): plateau;
var plat : plateau;
	len,i,j,x,max : Integer;
	car : carte;
	
begin
	if(difficile)then
		len := TAILLE_PLATEAU_DIFFICILE
		
	else 
		len := TAILLE_PLATEAU_FACILE;
	plat.length := len;
	setLength(plat.tableau,len,len);
	
	max := len;
	Randomize;
	for i := 0 to len-1 do
		for j := 0 to len-1 do
		begin;
			x := random(max*max);
						// TODO mettre les cases au hasard mais que 2 fois ...
			car.visible := false;
			if(difficile)then
				car.valeur := CASE_DIFFICILE[x]
			else 
				car.valeur := CASE_FACILE[x];
			plat.tableau[i][j]:= car;
		end;
	creePlateau := plat;
end;

function ouvrirPlateau(difficile,reprendrePartie : boolean): plateau;
var plat : plateau;
begin
	if (reprendrePartie) then
		plat := chargerPlateau()
	else 	
		plat := creePlateau(difficile);
		
	ouvrirPlateau:= plat;
	
end;

procedure menu(var difficile : boolean;var plat : plateau);
var val : Integer;
begin
	

	// TODO verif si une partie existe et proposer de la continuer
	
	repeat
		writeln('Que voulez vous faire ? : ');
		writeln('1/ faire une partie');
		writeln('5/ arrêter');
		readln(val);
		
		case val of 
			1 : plat := ouvrirPlateau(getDifficult(),false);

			
			
			
		end;
	until (val > 1) or (val < 5);
end;

procedure interaction(var i,j : Integer;var stop);
begin

readln(i);
readln(j);

i := i -1;
j := j -1;
end;

function verification(plat : plateau; i1,j1,i2,j2 : Integer):boolean;
begin

verification := false;
if(plat.tableau[i1][j1].valeur = plat.tableau[i2][j2].valeur)then
	verification := true;
end;

procedure tour(var plat : plateau ;var stop : boolean);
var i1,j1,i2,j2 : Integer;
begin 
	writeln('nouveau tour');
	interaction(i1,j1,stop);
	plat.tableau[i1][j1].visible := true;
	affichage(plat);
	if(not stop)then

	interaction(i2,j2,stop);
	plat.tableau[i2][j2].visible := true;
	affichage(plat);
	if(not verification(plat,i1,j1,i2,j2))then
	begin
		// TODO laisser un peu de temps ... 
		plat.tableau[i1][j1].visible := false;
		plat.tableau[i2][j2].visible := false;
		affichage(plat);
	end;
	
end ;


var difficile : boolean;
	plat : plateau;
	stop : boolean;

begin
stop := false;
menu(difficile,plat);
affichage(plat);
while not stop do
	tour(plat, stop);

end.
