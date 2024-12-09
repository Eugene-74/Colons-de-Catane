unit affichageUnit;


interface

uses sdl2, sdl2_image, sdl2_ttf, types, sysutils, TypInfo, traitement, Math, musique;

procedure initialisationAffichage(var affichage: TAffichage);
procedure recupererNomsJoueurs(var stringTab: TStringTab; var affichage: TAffichage);
procedure affichageGrille(plat: TPlateau; var affichage: TAffichage);
procedure affichagePlateau(plat: TPlateau; var affichage: TAffichage);
procedure clicHexagone(var affichage: TAffichage; var coord: Tcoord);
procedure miseAJourRenderer(var affichage :TAffichage);
procedure affichagePersonne(personne: TPersonne; var affichage: TAffichage);
procedure affichageSouillard(plat: TPlateau; var affichage: TAffichage);
procedure affichageConnexion(connexion : TConnexion; var affichage : TAffichage);
procedure echangeRessources(joueurs: TJoueurs; idJoueurActuel:Integer; var idJoueurEchange: Integer; var ressources1, ressources2: TRessources; var affichage: TAffichage);
procedure selectionRessource(var affichage: TAffichage; var ressource: TRessource;text: String;joueurs : Tjoueurs);
procedure selectionDepouiller(var ressource: TRessource; idJoueurActuel:Integer; var idJoueurAVoler: Integer; joueurs: TJoueurs; var affichage: TAffichage;text: String);
procedure affichageTour(plat: TPlateau; joueurs: TJoueurs; idJoueurActuel: Integer; var affichage: TAffichage);
procedure clicAction(var affichage: TAffichage; var valeurBouton: String);
procedure affichageInformation(texte: String; taille: Integer; couleur: TSDL_Color; var affichage: TAffichage);
procedure affichageJoueurActuel(joueurs: TJoueurs; idJoueurActuel: Integer; var affichage: TAffichage);
procedure suppressionInformation(var affichage: TAffichage);
procedure attendre(ms: Integer);
procedure affichageScoreAndClear(joueur:TJoueur; var affichage: TAffichage);
procedure affichageCartesTutoratAndRender(joueur: TJoueur; var affichage: TAffichage);
procedure affichageCartesTutorat(joueur: TJoueur; var affichage: TAffichage);
procedure affichageDes(de1,de2:Integer; var affichage: TAffichage);
procedure affichageHexagone(plat: TPlateau; var affichage: TAffichage; coordHexa: TCoord; preview : Boolean);
procedure affichageFond(var affichage: TAffichage);
procedure affichageDetailsHexagone(coordHexa,coordCart: TCoord; plat: TPlateau; var affichage: TAffichage;preview : Boolean);
procedure affichageRegles(var affichage: TAffichage);
procedure suppresionAffichage(var affichage: TAffichage);
procedure affichageGagnant(var affichage: TAffichage; text: String);

implementation

procedure affichageTexteAvecSautsDeLigne(text: String; taille: Integer; coord: TCoord; couleur: TSDL_Color; var affichage: TAffichage; maxWidth: Integer);forward;
function tailleTexte(texte: AnsiString; taille: Integer): Tcoord;forward; 
procedure affichageScore(joueur: TJoueur; var affichage: TAffichage);forward;
procedure affichageCarteTutorat(carteTutorat: TCarteTutorat; idCarte: Integer; coord: TCoord; var affichage: TAffichage);forward;
procedure suppressionScore(playerId: Integer; var affichage: TAffichage);forward;

procedure attendre(ms: Integer);
begin
    SDL_Delay(ms);
end;

{Permet de charger la texture de l'image
Preconditions :
    - affichage : la structure contenant le renderer
    - filename : le nom du fichier image (sans l'extension, de type .png)
Postconditions :
    - PSDL_Texture : la texture de l'image}
function chargerTexture(affichage : TAffichage;filename : String): PSDL_Texture;
var image : PSDL_Texture;
	chemin : AnsiString;
begin
	chemin := 'Assets/' + filename + '.png'; // Construit le chemin complet du fichier image
	image := IMG_LoadTexture(affichage.renderer, PChar(chemin));
	if image = nil then writeln('Could not load image : ',IMG_GetError) // Verifie si le chargement a reussi
	else chargerTexture := image;
end;

procedure initialisationSDL(var affichage: TAffichage);
begin
    if SDL_Init(SDL_INIT_VIDEO) < 0 then
    begin
        writeln('Erreur lors de l''initialisation de la SDL');
        HALT;
    end;
    //TODO Check si tout est bien initialise
    affichage.fenetre := SDL_CreateWindow('Catan', SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, WINDOW_W, WINDOW_H, SDL_WINDOW_BORDERLESS);
    affichage.renderer := SDL_CreateRenderer(affichage.fenetre, -1, SDL_RENDERER_ACCELERATED);
end;

procedure nettoyageAffichage(var affichage: TAffichage);
begin
    SDL_RenderClear(affichage.renderer);
end;

procedure affichageImage(x,y,w,h: Integer; texture: PSDL_Texture; var affichage: TAffichage);
var destination_rect: TSDL_RECT;
begin
    destination_rect := FRect(x,y,w,h);
    if SDL_RenderCopy(affichage.renderer,texture,nil,@destination_rect)<>0 then WriteLn('Erreur SDL: ', SDL_GetError());
end;

{Initialise le plateau de jeu
Preconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer}
procedure initialisationTextures(var affichage: TAffichage);
var j: Integer;
    i: TRessource;
begin
    for i:=Physique to Rien do
    begin
        affichage.texturePlateau.textureRessource[i] := chargerTexture(affichage, 'Ressources/'+GetEnumName(TypeInfo(TRessource), Ord(i)));
        if i <> Rien then
            affichage.texturePlateau.textureIconesRessources[i] := chargerTexture(affichage, 'IconesRessources/'+GetEnumName(TypeInfo(TRessource), Ord(i)));
    end;

    for j := 1 to 5 do
        affichage.texturePlateau.textureIconesCartesTutorat[j] := chargerTexture(affichage, 'IconesCartesTutorat/'+IntToStr(j));
    
    affichage.texturePlateau.textureValider := chargerTexture(affichage, 'valider');
    affichage.texturePlateau.textureQuitter := chargerTexture(affichage, 'croix');
    affichage.texturePlateau.texturesMusique[0] := chargerTexture(affichage, 'IconesMusique/demarrer');
    affichage.texturePlateau.texturesMusique[1] := chargerTexture(affichage, 'IconesMusique/arreter');
    affichage.texturePlateau.texturesFleches[0] := chargerTexture(affichage, 'gauche');
    affichage.texturePlateau.texturesFleches[1] := chargerTexture(affichage, 'droite');
    affichage.texturePlateau.texturesSignes[0] := chargerTexture(affichage, 'plus');
    affichage.texturePlateau.texturesSignes[1] := chargerTexture(affichage, 'moins');

    affichage.texturePlateau.textureContourHexagone := chargerTexture(affichage, 'hexagoneCercle');
    affichage.texturePlateau.textureContourVide := chargerTexture(affichage, 'hexagone');

    affichage.texturePlateau.textureEleve := chargerTexture(affichage, 'eleve');
    affichage.texturePlateau.textureSouillard := chargerTexture(affichage, 'souillard');
    affichage.texturePlateau.textureProfesseur := chargerTexture(affichage, 'professeur');
    affichage.texturePlateau.texturePoint := chargerTexture(affichage, 'point');

    affichage.texturePlateau.texturePreview := chargerTexture(affichage, 'preview');

    for j := 1 to 6 do
        affichage.texturePlateau.textureDes[j] := chargerTexture(affichage, 'DiceFaces/' + IntToStr(j));
end;

{Affiche le fond de l'ecran en blanc
Preconditions :
    - affichage : la structure contenant le renderer}
procedure affichageFond(var affichage: TAffichage);
begin
    SDL_SetRenderDrawColor(affichage.renderer, 255, 255, 255, 255);
    if SDL_RenderClear(affichage.renderer) <> 0 then
        WriteLn('Erreur SDL: ', SDL_GetError());
end;

{Cree une texture de couleur
Preconditions :
    - affichage : la structure contenant le renderer
    - r,g,b : les valeurs RGB de la couleur
Postconditions :
    - PSDL_Texture : la texture de couleur}
function creerTextureCouleur(affichage: TAffichage; couleur:TSDL_Color): PSDL_Texture;
var surface : PSDL_Surface;
    texture : PSDL_Texture;
begin
    surface := SDL_CreateRGBSurface(0, 1, 1, 32, 0, 0, 0, 0);
    if SDL_FillRect(surface, nil, SDL_MapRGB(surface^.format, couleur.r, couleur.g, couleur.b)) <> 0 then WriteLn('Erreur SDL: ', SDL_GetError());

    texture := SDL_CreateTextureFromSurface(affichage.renderer, surface);
    creerTextureCouleur := texture;
end;

{Affiche la connexion à l'ecran
Preconditions :
    - connexion : la connexion à afficher
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichageConnexion(connexion : TConnexion; var affichage : TAffichage);
var couleur: TSDL_Color;
    coord: TCoord;
    epaisseur: Integer;
    destination_rect: TSDL_RECT;
    longueur,angle: Real;
    colorTexture: PSDL_Texture;
begin
    epaisseur := 4;
    couleur := recupererCouleurJoueur(connexion.IdJoueur);
    calculPosConnexion(connexion,coord,longueur,angle);

    destination_rect.x:=affichage.xGrid+coord.x-Round(epaisseur*abs(Sin(angle))/2)-tailleHexagone div 4+epaisseur div 2;
    destination_rect.y:=affichage.yGrid+coord.y-Round(epaisseur*abs(Cos(angle))/2)-epaisseur div 3;
    destination_rect.w:=Round(longueur);
    destination_rect.h:=epaisseur;
    colorTexture := creerTextureCouleur(affichage,couleur);

    if SDL_RenderCopyEx(affichage.renderer, colorTexture, nil, @destination_rect, angle, nil, SDL_FLIP_NONE) <> 0 then WriteLn('Erreur SDL: ', SDL_GetError());
    
    SDL_DestroyTexture(colorTexture);
end;

{Affiche la personne à l'ecran
Preconditions :
    - personne : la personne à afficher
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichagePersonne(personne: TPersonne; var affichage: TAffichage);
var coord: Tcoord;
    texture: PSDL_Texture;
    couleur: TSDL_Color;
begin
    coord := calculPosPersonne(personne);

    if personne.estEleve then
        texture := affichage.texturePlateau.textureEleve
    else
        texture := affichage.texturePlateau.textureProfesseur;

    couleur := recupererCouleurJoueur(personne.IdJoueur);

    SDL_SetTextureColorMod(texture, couleur.r, couleur.g, couleur.b);

    affichageImage(affichage.xGrid + coord.x -(tailleEleve div 2),affichage.yGrid + coord.y -(tailleEleve div 2),tailleEleve,tailleEleve,texture,affichage);
end;

procedure affichageImageBouton(bouton: TBouton; var affichage: TAffichage);
begin
    if bouton.texte='valider' then
        affichageImage(bouton.coord.x,bouton.coord.y,bouton.w,bouton.h,affichage.texturePlateau.textureValider,affichage)
    else if bouton.texte='croix' then
        affichageImage(bouton.coord.x,bouton.coord.y,bouton.w,bouton.h,affichage.texturePlateau.textureQuitter,affichage)
    else if bouton.texte='/IconesMusique/demarrer' then
        affichageImage(bouton.coord.x,bouton.coord.y,bouton.w,bouton.h,affichage.texturePlateau.texturesMusique[0],affichage)
    else if bouton.texte='/IconesMusique/arreter' then
        affichageImage(bouton.coord.x,bouton.coord.y,bouton.w,bouton.h,affichage.texturePlateau.texturesMusique[1],affichage)
    else if bouton.texte='gauche' then
        affichageImage(bouton.coord.x,bouton.coord.y,bouton.w,bouton.h,affichage.texturePlateau.texturesFleches[0],affichage)
    else if bouton.texte='droite' then
        affichageImage(bouton.coord.x,bouton.coord.y,bouton.w,bouton.h,affichage.texturePlateau.texturesFleches[1],affichage)
    else if bouton.texte='plus' then
        affichageImage(bouton.coord.x,bouton.coord.y,bouton.w,bouton.h,affichage.texturePlateau.texturesSignes[0],affichage)
    else if bouton.texte='moins' then
        affichageImage(bouton.coord.x,bouton.coord.y,bouton.w,bouton.h,affichage.texturePlateau.texturesSignes[1],affichage)
end;

{Retourne les coordonnees du clic de la souris (système cartesien)
Preconditions :
    - affichage : la structure contenant le renderer
Postconditions :
    - coord (TCoord) : les coordonnees du clic (système cartesien)}
procedure clicCart(var affichage: TAffichage; var coord: Tcoord);
var running : Boolean;
    event: TSDL_Event;
    bouton: TBouton;
    buttonClicked: Boolean;
begin
    running := True;
    while running do
    begin
        attendre(16);
        while SDL_PollEvent(@event) <> 0 do
            case event.type_ of
                SDL_QUITEV: HALT;
                SDL_MOUSEBUTTONDOWN:
                begin
                    coord := FCoord(event.button.x,event.button.y);
                    buttonClicked := False;
                    for bouton in affichage.boutonsSysteme do
                    begin
                        if not ((coord.x >= bouton.coord.x) and (coord.x <= bouton.coord.x + bouton.w) and (coord.y >= bouton.coord.y) and (coord.y <= bouton.coord.y + bouton.h)) then
                            continue;
                        buttonClicked := True;
                        if bouton.valeur = 'musique_play' then demarrerMusique(affichage)
                        else if bouton.valeur = 'musique_stop' then arreterMusique(affichage)
                        else if bouton.valeur = 'quitter' then HALT;
                    end;
                    if not buttonClicked then
                    begin
                        running := False;
                    end;
                end;
            end;
    end;
end;

procedure affichageRegles(var affichage: TAffichage);
var bouton: TBouton;
    coord: TCoord;
    running: Boolean;
begin
    affichageFond(affichage);
    attendre(66);
    
    affichageImage(0,0,WINDOW_W,WINDOW_H,chargerTexture(affichage,'reglesImage'),affichage);
    bouton := FBouton((WINDOW_W - 160) div 2,WINDOW_H - 75,160,50,'valider','valider');
    affichageImageBouton(bouton,affichage);

    miseAJourRenderer(affichage);
    running := True;
    while running do
    begin
        attendre(16);
        clicCart(affichage,coord);
        if (coord.x >= bouton.coord.x) and (coord.x <= bouton.coord.x + bouton.w) and (coord.y >= bouton.coord.y) and (coord.y <= bouton.coord.y + bouton.h) then
            running := False;
    end;
end;

{Renvoie les coordonnees du clic de la souris (système hexagonal)
Preconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - coord (TCoord): les coordonnees du clic (système hexagonal)}
procedure clicHexagone(var affichage: TAffichage; var coord: Tcoord);
var tempCoord: Tcoord;
begin
    clicCart(affichage,coord);
    cartToHexa(FCoord(coord.x-affichage.xGrid,coord.y-affichage.yGrid),tempCoord,tailleHexagone div 2);
    coord := tempCoord;

    jouerSonClic(affichage);
    attendre(66);
end;

// Transforme du texte en une texture
function LoadTextureFromText(renderer:PRenderer; police:PTTF_Font; text:String;color:TSDL_Color):PSDL_Texture;
var surface : PSDL_Surface;
	texture : PSDL_Texture;
	text_compa : Ansistring;
begin
	text_compa := text;
	surface := TTF_RenderUTF8_Blended(police,PChar(text_compa),color);
	texture := SDL_CreateTextureFromSurface(renderer,surface); // Cree une surface SDL contenant le texte rendu avec la police specifiee et la couleur donnee
	LoadTextureFromText := texture;
    SDL_FreeSurface(surface);
end;

{Affiche du texte à l'ecran
Preconditions :
    - text : le texte à afficher
    - taille : la taille de la police
    - coord : les coordonnees du texte (système cartesien)
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichageTexte(text:String; taille:Integer; coord:TCoord; couleur: TSDL_Color; var affichage:TAffichage);
var police:PTTF_Font;
	texteTexture: PSDL_Texture;
	textRect : TSDL_Rect;
begin
    textRect := FRect(coord.x,coord.y,0,0);
	
	if TTF_INIT=-1 then HALT;
	
	police := TTF_OpenFont('Assets/OpenSans-Regular.ttf', taille);
	texteTexture := LoadTextureFromText(affichage.renderer,police,text,couleur);
	SDL_QueryTexture(texteTexture,nil,nil,@textRect.w,@textRect.h);
	
	if SDL_RenderCopy(affichage.renderer,texteTexture,nil,@textRect)<>0 then WriteLn('Erreur SDL: ', SDL_GetError());
	
	TTF_CloseFont(police);
	TTF_Quit();
	SDL_DestroyTexture(texteTexture);
end;

procedure affichageDe(de,rotation:Integer; coord:TCoord; var affichage: TAffichage);
var destination_rect: TSDL_RECT;
begin
    destination_rect := FRect(coord.x,coord.y,75,75);
    
    SDL_RenderCopyEx(affichage.renderer, affichage.texturePlateau.textureDes[de], nil, @destination_rect, rotation, nil, SDL_FLIP_NONE);
end;

procedure affichageDetailsHexagone(coordHexa,coordCart: TCoord; plat: TPlateau; var affichage: TAffichage;preview : Boolean);
var coord,tailleT : Tcoord;
    texture: PSDL_Texture;
begin
    if (plat.Grille[coordHexa.x,coordHexa.y].ressource = Rien) then
        texture := affichage.texturePlateau.textureContourVide
    else
        texture := affichage.texturePlateau.textureContourHexagone;

    affichageImage(affichage.xGrid+coordCart.x-(Round(tailleHexagone * 1.05) div 2),affichage.yGrid+coordCart.y-(Round(tailleHexagone * 1.05) div 2),Round(tailleHexagone * 1.05),Round(tailleHexagone * 1.05),texture,affichage);



    if(plat.Grille[coordHexa.x,coordHexa.y].Numero <> -1) then
    begin
      tailleT := tailleTexte(IntToStr(plat.Grille[coordHexa.x,coordHexa.y].Numero), 40);
      coord := FCoord(affichage.xGrid+coordCart.x - tailleT.x div 2,affichage.yGrid+coordCart.y - 50 div 2 -2);
      affichageTexte(IntToStr(plat.Grille[coordHexa.x,coordHexa.y].Numero), 40, coord, FCouleur(0,0,0,255), affichage)
    end;
end;

{Affiche un hexagone à l'ecran
Preconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
    - q,r : les coordonnees de l'hexagone
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichageHexagone(plat: TPlateau; var affichage: TAffichage; coordHexa: TCoord; preview : Boolean);
var coordCart: TCoord;
begin
    hexaToCart(coordHexa,coordCart,tailleHexagone div 2);

    if(not preview) then
    begin
      if (plat.Grille[coordHexa.x,coordHexa.y].ressource <> Aucune) then
        affichageImage(affichage.xGrid+coordCart.x-(tailleHexagone div 2),affichage.yGrid+coordCart.y-(tailleHexagone div 2),tailleHexagone,tailleHexagone,affichage.texturePlateau.textureRessource[plat.Grille[coordHexa.x,coordHexa.y].ressource],affichage);
      affichageDetailsHexagone(coordHexa,coordCart,plat,affichage,false);
    end
    else
      affichageImage(affichage.xGrid+coordCart.x-(tailleHexagone div 2),affichage.yGrid+coordCart.y-(tailleHexagone div 2),tailleHexagone,tailleHexagone,affichage.texturePlateau.texturePreview,affichage);
end;

{Affiche le souillard à l'ecran
Preconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichageSouillard(plat: TPlateau; var affichage: TAffichage);
var coord: TCoord;
begin
    hexaToCart(plat.Souillard.Position,coord,tailleHexagone div 2);
    
    affichageImage(affichage.xGrid+coord.x-(tailleSouillard div 2),affichage.yGrid+coord.y-(Round(tailleSouillard*1.3) div 2),tailleSouillard,Round(tailleSouillard*1.3),affichage.texturePlateau.textureSouillard,affichage);
    affichageDetailsHexagone(plat.Souillard.Position,coord,plat,affichage,false);
end;

{Affiche la grille à l'ecran
Preconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichageGrille(plat: TPlateau; var affichage: TAffichage);
var q,r,taille: Integer;
begin
    // affichageFond(affichage);

    taille := length(plat.Grille);
    for q:=0 to taille-1 do
        for r:=0 to taille-1 do
            if (plat.Grille[q,r].ressource <> Aucune) then
                affichageHexagone(plat,affichage,FCoord(q,r),false);
end;

procedure affichageDes(de1,de2:Integer; var affichage: TAffichage);
begin
    affichageDe(de1,-15,POSITION_DES,affichage);
    affichageDe(de2,20,FCoord(POSITION_DES.x+75,POSITION_DES.y),affichage);
end;

procedure affichageScore(joueur:TJoueur; var affichage: TAffichage);
var coord: Tcoord;
    ressource: TRessource;
begin
    coord := FCoord(25,25+joueur.id*75);
    
    affichageTexte(joueur.Nom + ': ', 25, coord,  recupererCouleurJoueur(joueur.Id), affichage);

    coord.x := coord.x + 13*(length(joueur.Nom)+2);
    affichageImage(coord.x,coord.y+7,25,25,affichage.texturePlateau.texturePoint,affichage);
    affichageTexte(IntToStr(joueur.Points), 25, FCoord(coord.x+30,coord.y), FCouleur(0,0,0,255), affichage);

    coord := FCoord(25,coord.y+35);
    for ressource := Physique to Mathematiques do
    begin
        affichageImage(coord.x,coord.y,25,25,affichage.texturePlateau.textureIconesRessources[ressource],affichage);
        coord.x := coord.x + 25;
        affichageTexte(' ' + IntToStr(joueur.Ressources[ressource]), 25, FCoord(coord.x,coord.y-5), FCouleur(0,0,0,255), affichage);
        coord.x := coord.x + 40;
    end;
end;

procedure affichageScoreAndClear(joueur:TJoueur; var affichage: TAffichage);
begin
    suppressionScore(joueur.id,affichage);
    affichageScore(joueur,affichage);
end;

procedure affichageZone(x,y,w,h,epaisseurBord: Integer; var affichage: TAffichage);
var destination_rect: TSDL_Rect;
begin
    SDL_SetRenderDrawColor(affichage.renderer, 0, 0, 0, 255);
    destination_rect := FRect(x,y,w,h);
    if SDL_RenderFillRect(affichage.renderer, @destination_rect) <> 0 then
        WriteLn('Erreur SDL: ', SDL_GetError());

    SDL_SetRenderDrawColor(affichage.renderer, 255, 255, 255, 255);
    destination_rect := FRect(x+epaisseurBord,y+epaisseurBord,w-epaisseurBord*2,h-epaisseurBord*2);
    if SDL_RenderFillRect(affichage.renderer, @destination_rect) <> 0 then
        WriteLn('Erreur SDL: ', SDL_GetError());
end;

procedure affichageCarteTutorat(carteTutorat: TCarteTutorat; idCarte: Integer; coord: TCoord; var affichage: TAffichage);
begin
    affichageZone(coord.x,coord.y,180,270,2,affichage);
    affichageImage(coord.x+40,coord.y+10,100,100,affichage.texturePlateau.textureIconesCartesTutorat[idCarte+1],affichage);

    affichageZone(coord.x+150,coord.y-10,40,40,2,affichage);
    affichageTexte(IntToStr(carteTutorat.nbr), 15, FCoord(coord.x+160,coord.y-10), FCouleur(0,200,0,255), affichage);
    affichageTexte(IntToStr(carteTutorat.utilisee), 15, FCoord(coord.x+160,coord.y+5), FCouleur(200,0,0,255), affichage);

    affichageTexte(carteTutorat.nom, 20, FCoord(coord.x +10,coord.y+110), FCouleur(0,0,0,255), affichage);

    affichageTexteAvecSautsDeLigne(carteTutorat.description, 14, FCoord(coord.x+10,coord.y+150), FCouleur(0,0,0,255), affichage, 165);
end;

procedure affichageTexteAvecSautsDeLigne(text: String; taille: Integer; coord: TCoord; couleur: TSDL_Color; var affichage: TAffichage; maxWidth: Integer);
var
  police: PTTF_Font;
  words: array of String;
  line, currentLine: AnsiString;
  i, textWidth, textHeight: Integer;
  wordCount: Integer;
begin
  if TTF_Init() = -1 then
  begin
    writeln('Erreur lors de l''initialisation de SDL_ttf : ', TTF_GetError);
    exit;
  end;

  police := TTF_OpenFont('Assets/OpenSans-Regular.ttf', taille);
  if police = nil then
  begin
    writeln('Erreur lors de l''ouverture de la police : ', TTF_GetError);
    TTF_Quit();
    exit;
  end;

  // Split the text into words
  wordCount := 0;
  for i := 1 to Length(text) do
    if text[i] = ' ' then
      Inc(wordCount);
  SetLength(words, wordCount + 1);

  wordCount := 0;
  line := '';
  for i := 1 to Length(text) do
  begin
    if text[i] = ' ' then
    begin
      words[wordCount] := line;
      Inc(wordCount);
      line := '';
    end
    else
      line := line + text[i];
  end;
  words[wordCount] := line;

  currentLine := '';
  for i := 0 to High(words) do
  begin
    if currentLine = '' then
      currentLine := words[i]
    else
      currentLine := currentLine + ' ' + words[i];

    TTF_SizeUTF8(police, PChar(currentLine), @textWidth, @textHeight);

    if textWidth > maxWidth then
    begin
      currentLine := StringReplace(currentLine, ' ' + words[i], '', []);
      affichageTexte(currentLine, taille, coord, couleur, affichage);
      coord.y := coord.y + textHeight;
      currentLine := words[i];
    end;
  end;

  if currentLine <> '' then
  begin
    affichageTexte(currentLine, taille, coord, couleur, affichage);
  end;

  TTF_CloseFont(police);
  TTF_Quit();
end;

procedure affichageCartesTutorat(joueur: TJoueur; var affichage: TAffichage);
var bouton: TBouton;
begin
    bouton := FBouton(WINDOW_W-500,25,180,270,'',CARTES_TUTORAT[0].nom);
    ajouterBoutonTableau(bouton,affichage.boutonsAction);
    affichageCarteTutorat(joueur.CartesTutorat[0],0,FCoord(WINDOW_W-500,25),affichage);
    
    bouton.coord := FCoord(WINDOW_W-300,25);
    bouton.valeur := CARTES_TUTORAT[1].nom;
    ajouterBoutonTableau(bouton,affichage.boutonsAction);
    affichageCarteTutorat(joueur.CartesTutorat[1],1,FCoord(WINDOW_W-300,25),affichage);

    bouton.coord := FCoord(WINDOW_W-500,310);
    bouton.valeur := CARTES_TUTORAT[2].nom;
    ajouterBoutonTableau(bouton,affichage.boutonsAction);
    affichageCarteTutorat(joueur.CartesTutorat[2],2,FCoord(WINDOW_W-500,310),affichage);

    bouton.coord := FCoord(WINDOW_W-300,310);
    bouton.valeur := CARTES_TUTORAT[3].nom;
    ajouterBoutonTableau(bouton,affichage.boutonsAction);
    affichageCarteTutorat(joueur.CartesTutorat[3],3,FCoord(WINDOW_W-300,310),affichage);

    bouton.coord := FCoord(WINDOW_W-500,595);
    bouton.valeur := CARTES_TUTORAT[4].nom;
    ajouterBoutonTableau(bouton,affichage.boutonsAction);
    affichageCarteTutorat(joueur.CartesTutorat[4],4,FCoord(WINDOW_W-500,595),affichage);
end;

procedure affichageCartesTutoratAndRender(joueur: TJoueur; var affichage: TAffichage);
begin
    affichageCartesTutorat(joueur,affichage);
    miseAJourRenderer(affichage);
end;

procedure suppressionScore(playerId: Integer; var affichage: TAffichage);
begin
    affichageZone(25,25+playerId*75,320,65,0,affichage);
end;

procedure affichageBouton(bouton: TBouton; var affichage: TAffichage);
begin
    affichageZone(bouton.coord.x,bouton.coord.y,bouton.w,bouton.h,2,affichage);
    affichageTexte(' '+bouton.texte, 25, bouton.coord, FCouleur(0,0,0,255), affichage);
end;

procedure initialisationBoutonsSysteme(var affichage: TAffichage);
var bouton: TBouton;
begin
    setLength(affichage.boutonsSysteme, 0);
    bouton := FBouton(WINDOW_W-150,WINDOW_H-75,50,50,'/IconesMusique/demarrer','musique_play');
    ajouterBoutonTableau(bouton,affichage.boutonsSysteme);

    bouton := FBouton(WINDOW_W-75,WINDOW_H-75,50,50,'/IconesMusique/arreter','musique_stop');
    ajouterBoutonTableau(bouton,affichage.boutonsSysteme);

    bouton := FBouton(WINDOW_W-75,20,50,50,'croix','quitter');
    ajouterBoutonTableau(bouton,affichage.boutonsSysteme);
end;

procedure suppressionInformation(var affichage: TAffichage);
begin
    affichageZone(350,WINDOW_H-55,1500,50,0,affichage);
    attendre(66);
end;

procedure affichageInformation(texte: String; taille: Integer; couleur: TSDL_Color; var affichage: TAffichage);
begin
    attendre(50);
    suppressionInformation(affichage);
    affichageTexte(texte, taille-5, FCoord(350,WINDOW_H-55), couleur, affichage);
    miseAJourRenderer(affichage);
    attendre(50);
end;


procedure affichageJoueurActuel(joueurs: TJoueurs; idJoueurActuel: Integer; var affichage: TAffichage);
begin
    affichageZone(25,350,300,40,0,affichage);
    affichageTexte('Tour de : ' + joueurs[idJoueurActuel].Nom, 25, FCoord(25,350), recupererCouleurJoueur(idJoueurActuel), affichage);
end;

procedure clicBouton(var affichage: TAffichage; var boutons: TBoutons; var valeurBouton: String);
var running: Boolean;
    i: Integer;
    coord: Tcoord;
begin
    running := True;
    valeurBouton := '';

    if length(boutons) = 0 then
    begin
        writeln('Erreur : Pas de boutons');
        exit;
    end;

    while running do
    begin
        clicCart(affichage,coord);
        for i:=0 to length(boutons)-1 do
            if (coord.x >= boutons[i].coord.x) and (coord.x <= boutons[i].coord.x + boutons[i].w) and (coord.y >= boutons[i].coord.y) and (coord.y <= boutons[i].coord.y + boutons[i].h) then
            begin
                valeurBouton := boutons[i].valeur;
                running := False;
                break;
            end;
    end;
end;

procedure affichageIntegerInput(coord:TCoord; ressource: String; id: String; ressources: TRessources; var affichage: TAffichage; var boutons: TBoutons);
var bouton: TBouton;
begin
    bouton := FBouton(coord.x + 120,coord.y,30,30,'plus',ressource + '_plus_' + id);
    affichageImageBouton(bouton,affichage);
    ajouterBoutonTableau(bouton, boutons);

    bouton := FBouton(coord.x + 155,coord.y,30,30,'moins',ressource + '_moins_' + id);
    affichageImageBouton(bouton,affichage);
    ajouterBoutonTableau(bouton, boutons);

    coord.x := coord.x + 200;
    affichageTexte(ressource + ' : ' + IntToStr(ressources[TRessource(GetEnumValue(TypeInfo(TRessource), ressource))]), 25, coord, FCouleur(0,0,0,255), affichage);
end;

procedure affichageJoueurInput(joueurs: TJoueurs; id: Integer; coord:TCoord; var affichage: TAffichage; var boutons: TBoutons);
var bouton: TBouton;
begin
    if(length(joueurs) > 2) then
    begin
        bouton := FBouton(coord.x + 120,coord.y,30,30,'gauche','joueur_precedent');
        affichageImageBouton(bouton,affichage);
        ajouterBoutonTableau(bouton, boutons);

        bouton := FBouton(coord.x + 155,coord.y,30,30,'droite','joueur_suivant');
        affichageImageBouton(bouton,affichage);
        ajouterBoutonTableau(bouton, boutons);
    end;

    coord.x := coord.x + 200;
    affichageTexte(joueurs[id].Nom, 25, coord, FCouleur(0,0,0,255), affichage);
end;

procedure affichageEchangeRessources(joueurs: TJoueurs; idJoueurActuel,idJoueurEchange: Integer; ressources1,ressources2: TRessources;var affichage: TAffichage; var boutons: TBoutons);
var coord: Tcoord;
    bouton: TBouton;
    ressource: TRessource;
    i: Integer;
begin
    affichageFond(affichage);
    attendre(66);

    coord := FCoord(450,50);
    affichageZone(coord.x,coord.y,1050,900,3,affichage);
    for i:=0 to length(joueurs)-1 do
        affichageScore(joueurs[i],affichage);

    affichageTexte('Echange', 35, FCoord(890,90), FCouleur(0,0,0,255), affichage);

    coord := FCoord(650,160);
    affichageTexte(joueurs[idJoueurActuel].Nom, 25, coord, FCouleur(0,0,0,255), affichage);
    
    coord.x := 450;
    for ressource := Physique to Mathematiques do
    begin
        coord.y := coord.y + 35;
        affichageIntegerInput(coord,GetEnumName(TypeInfo(TRessource), Ord(ressource)),'1',ressources1,affichage,boutons);
    end;

    coord := FCoord(950,160);
    affichageJoueurInput(joueurs,idJoueurEchange,coord,affichage,boutons);

    for ressource := Physique to Mathematiques do
    begin
        coord.y := coord.y + 35;
        affichageIntegerInput(coord,GetEnumName(TypeInfo(TRessource), Ord(ressource)),'2',ressources2,affichage,boutons);
    end;

    bouton := FBouton(895,450,160,50,'valider','valider_echange');
    affichageImageBouton(bouton,affichage);
    ajouterBoutonTableau(bouton, boutons);
end;

{Affiche l'ecran d'echange de ressources
Preconditions :
    - joueurs : les joueurs de la partie
    - idJoueurActuel : l'identifiant du joueur actuel
    - idJoueurEchange : l'identifiant du joueur avec qui echanger
    - ressources1 : les ressources à echanger du joueur actuel
    - ressources2 : les ressources à echanger du joueur avec qui echanger
    - affichage : la structure contenant le renderer}
procedure echangeRessources(joueurs: TJoueurs; idJoueurActuel:Integer; var idJoueurEchange: Integer; var ressources1, ressources2: TRessources; var affichage: TAffichage);
var boutons: Array of TBouton;
    valeurBouton: String;
    valeurBoutonSplit: TStringTab;
    ressource: TRessource;
begin
    for ressource := Physique to Mathematiques do
    begin
        ressources1[ressource] := 0;
        ressources2[ressource] := 0;
    end;

    nettoyageAffichage(affichage);
    attendre(66);

    affichageEchangeRessources(joueurs,idJoueurActuel,idJoueurEchange,ressources1,ressources2,affichage,boutons);
    miseAJourRenderer(affichage);

    clicBouton(affichage,boutons,valeurBouton);
    while valeurBouton <> 'valider_echange' do
    begin
        if valeurBouton = 'joueur_precedent' then
            idJoueurEchange := (idJoueurEchange - 1 + length(joueurs) - 1 * Ord(((idJoueurEchange-1+length(joueurs)) mod length(joueurs))=idJoueurActuel)) mod length(joueurs)
        else if valeurBouton = 'joueur_suivant' then
            idJoueurEchange := (idJoueurEchange + 1 + 1 * Ord(((idJoueurEchange + 1) mod length(joueurs))=idJoueurActuel)) mod length(joueurs)
        else
        begin
            //TODO opti la verif de ressources pour limiter aux ressources possedees en max
            valeurBoutonSplit := splitValeur(valeurBouton);

            ressource := TRessource(GetEnumValue(TypeInfo(TRessource), valeurBoutonSplit[0]));

            if valeurBoutonSplit[1] = 'plus' then
            begin
                if valeurBoutonSplit[2] = '1' then
                    ressources1[ressource] := ressources1[ressource] + 1
                else
                    ressources2[ressource] := ressources2[ressource] + 1;
            end
            else
            begin
                if valeurBoutonSplit[2] = '1' then
                    ressources1[ressource] := max(0,ressources1[ressource] - 1)
                else
                    ressources2[ressource] := max(0,ressources2[ressource] - 1);
            end;
        end;
        nettoyageAffichage(affichage);
        affichageEchangeRessources(joueurs,idJoueurActuel,idJoueurEchange,ressources1,ressources2,affichage,boutons);
        miseAJourRenderer(affichage);

        clicBouton(affichage,boutons,valeurBouton);
    end;
end;

function tailleTexte(texte: AnsiString; taille: Integer): Tcoord;
var textWidth,textHeight : Integer;
  font: PTTF_Font;
begin
  if TTF_Init() = -1 then
  begin
    writeln('Erreur lors de l''initialisation de SDL_ttf : ', TTF_GetError);
    exit;
  end;
  font := TTF_OpenFont('Assets/OpenSans-Regular.ttf', taille);
  if font = nil then
  begin
      writeln('Erreur lors de l''ouverture de la police : ', TTF_GetError);
      exit;
  end;
  TTF_SizeUTF8(font, PChar(texte), @textWidth, @textHeight);
  TTF_CloseFont(font);

  tailleTexte := FCoord(textWidth,textHeight);
end;

procedure affichageSelectionRessource(var boutonValider: TBouton; var affichage: TAffichage; var grille: TGrille; text : String; ressourceSelectionnee: TRessource);
var ressource: TRessource;
    coord,coordCart: Tcoord;
    i,j: Integer;
    tailleT: TCoord;
begin
    attendre(66);

    tailleT := tailleTexte(text,25);
    coord := FCoord(450,50);
    affichageZone(coord.x,coord.y,1050,900,3,affichage);
    affichageTexte('Sélection de ressource', 35, FCoord(800, 90), FCouleur(0,0,0,255), affichage);
    affichageTexte(text, 25,  FCoord(975-(tailleT.x div 2), 130), FCouleur(0,0,0,255), affichage);

    coord := FCoord(850,300);
    SetLength(Grille,3,2);
    i := 0;
    j := 0;
    for ressource := Physique to Rien do
    begin
        hexaToCart(FCoord(i,j),coordCart,tailleHexagone div 2);
        if ressource <> Rien then
        begin
            affichageImage(coord.x+coordCart.x-(tailleHexagone div 2),coord.y+coordCart.y-(tailleHexagone div 2),tailleHexagone,tailleHexagone,affichage.texturePlateau.textureRessource[ressource],affichage);
            if ressource = ressourceSelectionnee then
                affichageImage(coord.x+coordCart.x-(tailleHexagone div 2),coord.y+coordCart.y-(tailleHexagone div 2),tailleHexagone,tailleHexagone,affichage.texturePlateau.texturePreview,affichage);
        end;
        grille[i,j].ressource := ressource;
        Inc(i);
        if i > 2 then
        begin
            i := 0;
            Inc(j);
        end;
    end;

    boutonValider := FBouton(895,850,160,50,'valider','Valider');
    affichageImageBouton(boutonValider,affichage);
end;

procedure selectionRessource(var affichage: TAffichage; var ressource: TRessource; text: String; joueurs: TJoueurs);
var coord,coordHexa: Tcoord;
    grille: TGrille;
    valider: Boolean;
    boutonValider: TBouton;
    i: Integer;
begin
    nettoyageAffichage(affichage);
    affichageFond(affichage);
    attendre(66);
    ressource := Rien;
    affichageSelectionRessource(boutonValider,affichage,grille,text,ressource);
    for i := 0 to length(joueurs)-1 do
      affichageScore(joueurs[i], affichage);
    
    miseAJourRenderer(affichage);

    valider := False;
    while not valider do
    begin
        clicCart(affichage,coord);
        cartToHexa(FCoord(coord.x-850,coord.y-300),coordHexa,tailleHexagone div 2);
        if (coordHexa.x >= 0) and (coordHexa.x <= 2) and (coordHexa.y >= 0) and (coordHexa.y <= 1) then
        begin
            ressource := grille[coordHexa.x,coordHexa.y].ressource;
            affichageSelectionRessource(boutonValider,affichage,grille,text,ressource);
            miseAJourRenderer(affichage);
        end;
        if (boutonValider.coord.x <= coord.x) and (coord.x <= boutonValider.coord.x + boutonValider.w) and (boutonValider.coord.y <= coord.y) and (coord.y <= boutonValider.coord.y + boutonValider.h) and (ressource <> Rien) then
            valider := True;
    end;
end;

procedure selectionDepouiller(var ressource: TRessource; idJoueurActuel:Integer; var idJoueurAVoler: Integer; joueurs: TJoueurs; var affichage: TAffichage;text: String);
var boutonValider: TBouton;
    grille: TGrille;
    valider: Boolean;
    coord,coordHexa: Tcoord;
    boutons: TBoutons;
    valeurBouton: String;
    i: Integer;
begin
    nettoyageAffichage(affichage);
    affichageFond(affichage);
    attendre(66);
    for i := 0 to length(joueurs)-1 do
      affichageScore(joueurs[i], affichage);
    ressource := Rien;
    affichageSelectionRessource(boutonValider,affichage,grille,text,ressource);
    affichageJoueurInput(joueurs,idJoueurAVoler,FCoord(800,600),affichage,boutons);
    miseAJourRenderer(affichage);

    valider := False;
    while not valider do
    begin
        clicCart(affichage,coord);

        cartToHexa(FCoord(coord.x-850,coord.y-300),coordHexa,tailleHexagone div 2);
        if (coordHexa.x >= 0) and (coordHexa.x <= 2) and (coordHexa.y >= 0) and (coordHexa.y <= 1) then
        begin
            ressource := grille[coordHexa.x,coordHexa.y].ressource;
            affichageSelectionRessource(boutonValider,affichage,grille,text,ressource);
            affichageJoueurInput(joueurs,idJoueurAVoler,FCoord(800,600),affichage,boutons);
            miseAJourRenderer(affichage);
        end
        else if (boutonValider.coord.x <= coord.x) and (coord.x <= boutonValider.coord.x + boutonValider.w) and (boutonValider.coord.y <= coord.y) and (coord.y <= boutonValider.coord.y + boutonValider.h) and (ressource <> Rien) then
            valider := True
        else
        begin
            for i:=0 to length(boutons)-1 do
                if (coord.x >= boutons[i].coord.x) and (coord.x <= boutons[i].coord.x + boutons[i].w) and (coord.y >= boutons[i].coord.y) and (coord.y <= boutons[i].coord.y + boutons[i].h) then
                begin
                    valeurBouton := boutons[i].valeur;
                    break;
                end;
            if valeurBouton = 'joueur_precedent' then
                idJoueurAVoler := (idJoueurAVoler - 1 + length(joueurs) - 1 * Ord(((idJoueurAVoler-1+length(joueurs)) mod length(joueurs))=idJoueurActuel)) mod length(joueurs)
            else if valeurBouton = 'joueur_suivant' then
                idJoueurAVoler := (idJoueurAVoler + 1 + 1 * Ord(((idJoueurAVoler + 1) mod length(joueurs))=idJoueurActuel)) mod length(joueurs);
            
            affichageZone(900,600,300,40,0,affichage);
            affichageJoueurInput(joueurs,idJoueurAVoler,FCoord(800,600),affichage,boutons);
            attendre(16);
            miseAJourRenderer(affichage);
        end;
    end;
end;

procedure clicAction(var affichage: TAffichage; var valeurBouton: String);
begin
    clicBouton(affichage,affichage.boutonsAction,valeurBouton);
end;

procedure affichagePlateau(plat: TPlateau; var affichage: TAffichage);
var i: Integer;
begin
    affichageGrille(plat,affichage);
    affichageSouillard(plat,affichage);
    for i:=0 to length(plat.Connexions)-1 do
        affichageConnexion(plat.Connexions[i],affichage);
    for i:=0 to length(plat.Personnes)-1 do
        affichagePersonne(plat.Personnes[i],affichage);
end;

{Affiche le tour à l'ecran
Preconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichageTour(plat: TPlateau; joueurs: TJoueurs; idJoueurActuel: Integer; var affichage: TAffichage);
var i: Integer;
begin
    nettoyageAffichage(affichage);

    affichageFond(affichage);
    affichageDes(plat.des1,plat.des2,affichage);
    affichagePlateau(plat,affichage);
    
    for i:=0 to length(affichage.boutonsAction)-1 do
        affichageBouton(affichage.boutonsAction[i],affichage);
    
    for i:=0 to length(joueurs)-1 do
        affichageScore(joueurs[i],affichage);
    
    affichageCartesTutorat(joueurs[idJoueurActuel],affichage);

    affichageJoueurActuel(joueurs,idJoueurActuel,affichage);
    miseAJourRenderer(affichage);
    attendre(66);
end;

procedure affichageNomJoueurInput(nomActuel:String; bouton: TBouton; tailleTexte: Integer; var affichage: TAffichage);
begin
    affichageZone(bouton.coord.x,bouton.coord.y,bouton.w,bouton.h,3,affichage);
    affichageTexte('Nom du joueur : ', tailleTexte, FCoord(bouton.coord.x-210,bouton.coord.y+5), FCouleur(0,0,0,255), affichage);

    if nomActuel = '' then
        nomActuel := ' ';
    affichageTexte(nomActuel, tailleTexte, FCoord(bouton.coord.x+5,bouton.coord.y+5), FCouleur(0,0,0,255), affichage);
end;

procedure recupererNomsJoueurs(var stringTab: TStringTab; var affichage: TAffichage);
var nom,valeurBouton: String;
    i: Integer;
    boutons: TBoutons;
    bouton: TBouton;
    running,ecritureNom: Boolean;
    event: TSDL_Event;
    tailleT: Tcoord;
begin

    tailleT := tailleTexte('Entrez les noms des joueurs',35);
    affichageTexte('Entrez les noms des joueurs', 35, FCoord((WINDOW_W - tailleT.x) div 2 ,70), FCouleur(0,0,0,255), affichage);

    setlength(stringTab,4);
    for i:=0 to length(stringTab)-1 do
    begin
        if stringTab[i] <> '' then
            bouton.texte := stringTab[i]

        else
        begin
            stringTab[i] := '';
            bouton.texte := 'Veuillez entrer le nom du joueur ' + IntToStr(i+1);
        end;
        bouton := FBouton(450,130+55*i,1050,50,bouton.texte,IntToStr(i));
        affichageNomJoueurInput(bouton.texte,bouton,25,affichage);
        ajouterBoutonTableau(bouton,boutons);
    end;

    bouton := FBouton(WINDOW_W div 2 - 80,WINDOW_H-200,160,50,'valider','valider');
    affichageImageBouton(bouton,affichage);
    ajouterBoutonTableau(bouton,boutons);

    miseAJourRenderer(affichage);

    running := True;
    nom := '';
    valeurBouton := '-1';
    while running do
    begin
        if valeurBouton <> '-1' then
            affichageNomJoueurInput(nom,boutons[StrToInt(valeurBouton)],25,affichage);
        
        clicBouton(affichage,boutons,valeurBouton);
        if valeurBouton = 'valider' then break;

        nom := '';
        affichageNomJoueurInput(nom+'_',boutons[StrToInt(valeurBouton)],25,affichage);

        SDL_StartTextInput();
        ecritureNom := True;
        while ecritureNom do
        begin
            miseAJourRenderer(affichage);
            attendre(32);
            while SDL_PollEvent(@event) <> 0 do
            begin
                if not ecritureNom then
                begin
                    continue;
                end;
                case event.type_ of
                    SDL_QUITEV: HALT;
                    SDL_KEYDOWN:
                    begin;
                        if (event.key.keysym.sym = SDLK_BACKSPACE) and (length(nom) > 0) then
                        begin
                            Delete(nom,length(nom),1);
                            stringTab[StrToInt(valeurBouton)] := nom;
                            affichageNomJoueurInput(nom+'_',boutons[StrToInt(valeurBouton)],25,affichage);
                        end
                        else if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_TAB) then
                        begin
                            if StrToInt(valeurBouton) < length(boutons)-2 then
                            begin
                                affichageNomJoueurInput(nom,boutons[StrToInt(valeurBouton)],25,affichage);
                                valeurBouton := IntToStr(StrToInt(valeurBouton)+1);
                                nom := '';
                                affichageNomJoueurInput(nom,boutons[StrToInt(valeurBouton)],25,affichage);
                            end
                            else
                            begin
                                running := False;
                                ecritureNom := False;
                            end;
                        end;
                    end;
                    SDL_TEXTINPUT:
                        if length(nom) < 10 then
                        begin
                            nom := nom + event.text.text;
                            stringTab[StrToInt(valeurBouton)] := nom;
                            affichageNomJoueurInput(nom+'_',boutons[StrToInt(valeurBouton)],25,affichage);
                        end;
                    SDL_MOUSEBUTTONDOWN:
                    begin
                        ecritureNom := False;
                        for i:=0 to length(boutons)-2 do
                            if (event.button.x >= boutons[i].coord.x) and (event.button.x <= boutons[i].coord.x + boutons[i].w) and (event.button.y >= boutons[i].coord.y) and (event.button.y <= boutons[i].coord.y + boutons[i].h) then
                            begin
                                ecritureNom := True;
                                affichageNomJoueurInput(nom,boutons[StrToInt(valeurBouton)],25,affichage);
                                valeurBouton := boutons[i].valeur;
                                nom := '';
                                affichageNomJoueurInput(nom+'_',boutons[StrToInt(valeurBouton)],25,affichage);
                            end;
                        attendre(16);
                        if ecritureNom = false then
                        begin
                            affichageNomJoueurInput(nom,boutons[StrToInt(valeurBouton)],25,affichage);
                            miseAJourRenderer(affichage);
                            valeurBouton := '-1';
                        end;
                    end;
                end;
            end;
        end;
        SDL_StopTextInput();
    end;
end;

procedure affichageGagnant(var affichage: TAffichage; text: String);
begin
    attendre(66);
    affichageFond(affichage);
    affichageTexteAvecSautsDeLigne(text, 50, FCoord(100,300), FCouleur(0,0,0,255), affichage, 1600);
    miseAJourRenderer(affichage);
    attendre(3000);
end;

{Met à jour l'affichage
Preconditions :
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure miseAJourRenderer(var affichage :TAffichage);
var i: Integer;
begin
    attendre(16);
    verificationMusique(affichage);
    for i:=0 to length(affichage.boutonsSysteme)-1 do
        affichageImageBouton(affichage.boutonsSysteme[i],affichage);
    SDL_RenderPresent(affichage.renderer);
end;

procedure initialisationBoutonsAction(var affichage: TAffichage);
var bouton: TBouton;
begin
    setLength(affichage.boutonsAction, 0);
    
    bouton := FBouton(25,WINDOW_H - 370,270,50,'Achat connexion','achat_connexion');
    ajouterBoutonTableau(bouton, affichage.boutonsAction);

    bouton := FBouton(25,WINDOW_H - 310,270,50,'Achat élève','achat_eleve');
    ajouterBoutonTableau(bouton, affichage.boutonsAction);

    bouton := FBouton(25,WINDOW_H - 250,270,50,'Changement en prof','changement_en_prof');
    ajouterBoutonTableau(bouton, affichage.boutonsAction);

    bouton := FBouton(25,WINDOW_H - 190,270,50,'Achat carte tutorat','achat_carte_tutorat');
    ajouterBoutonTableau(bouton, affichage.boutonsAction);

    bouton := FBouton(25,WINDOW_H - 130,270,50,'Échange ressources','echange');
    ajouterBoutonTableau(bouton, affichage.boutonsAction);

    bouton := FBouton(25,WINDOW_H - 70,270,50,'Fin du tour','fin_tour');
    ajouterBoutonTableau(bouton, affichage.boutonsAction);
end;

{Initialise l'affichage
Preconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer}
procedure initialisationAffichage(var affichage: TAffichage);
begin
    initialisationSDL(affichage);

    affichage.xGrid := 150;
    affichage.yGrid := 150;

    initialisationTextures(affichage);
    initialisationBoutonsAction(affichage);
    initialisationBoutonsSysteme(affichage);
end;

procedure suppresionAffichage(var affichage: TAffichage);
var texture: PSDL_Texture;
begin
    for texture in affichage.texturePlateau.textureRessource do
        SDL_DestroyTexture(texture);
    for texture in affichage.texturePlateau.textureIconesRessources do
        SDL_DestroyTexture(texture);
    for texture in affichage.texturePlateau.textureIconesCartesTutorat do
        SDL_DestroyTexture(texture);
    for texture in affichage.texturePlateau.textureDes do
        SDL_DestroyTexture(texture);
    SDL_DestroyTexture(affichage.texturePlateau.textureContourHexagone);
    SDL_DestroyTexture(affichage.texturePlateau.textureContourVide);
    SDL_DestroyTexture(affichage.texturePlateau.textureEleve);
    SDL_DestroyTexture(affichage.texturePlateau.textureSouillard);
    SDL_DestroyTexture(affichage.texturePlateau.textureProfesseur);
    SDL_DestroyTexture(affichage.texturePlateau.texturePoint);
    SDL_DestroyTexture(affichage.texturePlateau.texturePreview);
    SDL_DestroyTexture(affichage.texturePlateau.textureValider);
    SDL_DestroyTexture(affichage.texturePlateau.textureQuitter);
    SDL_DestroyTexture(affichage.texturePlateau.texturesMusique[0]);
    SDL_DestroyTexture(affichage.texturePlateau.texturesMusique[1]);
    SDL_DestroyTexture(affichage.texturePlateau.texturesFleches[0]);
    SDL_DestroyTexture(affichage.texturePlateau.texturesFleches[1]);
    SDL_DestroyTexture(affichage.texturePlateau.texturesSignes[0]);
    SDL_DestroyTexture(affichage.texturePlateau.texturesSignes[1]);

    SDL_DestroyRenderer(affichage.renderer);
    SDL_DestroyWindow(affichage.fenetre);
    SDL_Quit();
end;

end.
