unit affichageUnit;


interface

uses sdl2, sdl2_image, sdl2_ttf, types, sysutils, TypInfo, traitement, Math, musique;

procedure initialisationSDL(var affichage: TAffichage);
procedure initialisationAffichage(var affichage: TAffichage);
procedure affichageGrille(plat: TPlateau; var affichage: TAffichage);
procedure clicHexagone(var plat: TPlateau; var affichage: TAffichage; var coord: Tcoord);
procedure miseAJourRenderer(var affichage :TAffichage);
procedure affichagePersonne(personne: TPersonne; var affichage: TAffichage);
procedure affichageSouillard(plat: TPlateau; var affichage: TAffichage);
procedure affichageConnexion(connexion : TConnexion; var affichage : TAffichage);
procedure affichageDes(de1,de2:Integer; coord: TCoord; var affichage: TAffichage);
procedure echangeRessources(joueurs: TJoueurs; idJoueurActuel:Integer; var idJoueurEchange: Integer; var ressources1, ressources2: TRessources; var affichage: TAffichage);
procedure affichageTour(plat: TPlateau; joueurs: TJoueurs; var affichage: TAffichage);
procedure clicAction(var affichage: TAffichage; var valeurBouton: String);
procedure affichageScore(joueur: TJoueur; var affichage: TAffichage);
procedure affichageInformation(texte: String; taille: Integer; couleur: TSDL_Color; var affichage: TAffichage);
procedure suppressionInformation(var affichage: TAffichage);
procedure suppressionScores(playerId: Integer; var affichage: TAffichage);
procedure attendre(ms: Integer);

implementation

const
    WINDOW_W = 1920;
    WINDOW_H = 1080;
    tailleHexagone = 180;
    tailleEleve = tailleHexagone div 3;
    tailleSouillard = tailleHexagone div 2;

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
	// Construit le chemin complet du fichier image
	chemin := 'Assets/' + filename + '.png';

	image := IMG_LoadTexture(affichage.renderer, PChar(chemin));
	
	// Verifie si le chargement a reussi
	if image = nil then
		writeln('Could not load image : ',IMG_GetError);
	
	chargerTexture := image;
end;

procedure initialisationSDL(var affichage: TAffichage);
begin
    if SDL_Init(SDL_INIT_VIDEO) < 0 then
    begin
        writeln('Erreur lors de l''initialisation de la SDL');
        Halt(1);
    end;

    //TODO Check si tout est bien initialise
    affichage.fenetre := SDL_CreateWindow('Catan', SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, WINDOW_W, WINDOW_H, SDL_WINDOW_SHOWN);
    affichage.renderer := SDL_CreateRenderer(affichage.fenetre, -1, SDL_RENDERER_ACCELERATED);
end;


procedure nettoyageAffichage(var affichage: TAffichage);
begin
    SDL_RenderClear(affichage.renderer);
end;

procedure affichageImage(x,y,w,h: Integer; texture: PSDL_Texture; var affichage: TAffichage);
var destination_rect: TSDL_RECT;
begin
    destination_rect.x:=x;
    destination_rect.y:=y;
    destination_rect.w:=w;
    destination_rect.h:=h;

    if SDL_RenderCopy(affichage.renderer,texture,nil,@destination_rect)<>0 then
        WriteLn('Erreur SDL: ', SDL_GetError());
end;


{Initialise le plateau de jeu
Preconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer}
procedure initialisationTextures(var affichage: TAffichage);
var i: TRessource;
begin
    for i:=Physique to Rien do
    begin
        affichage.texturePlateau.textureRessource[i] := chargerTexture(affichage, 'Ressources/'+GetEnumName(TypeInfo(TRessource), Ord(i)));
        if i <> Rien then
            affichage.texturePlateau.textureIconesRessources[i] := chargerTexture(affichage, 'IconesRessources/'+GetEnumName(TypeInfo(TRessource), Ord(i)));
    end;

    //TODO Clean up
    // affichage.texturePlateau.textureContourHexagone := chargerTexture(affichage, 'bordureCercle');
    // affichage.texturePlateau.textureContourVide := chargerTexture(affichage, 'bordure');
    affichage.texturePlateau.textureContourHexagone := chargerTexture(affichage, 'hexagoneCercle');
    affichage.texturePlateau.textureContourVide := chargerTexture(affichage, 'hexagone');

    affichage.texturePlateau.textureEleve := chargerTexture(affichage, 'eleve');
    affichage.texturePlateau.textureSouillard := chargerTexture(affichage, 'souillard');
    affichage.texturePlateau.textureProfesseur := chargerTexture(affichage, 'professeur');
    affichage.texturePlateau.texturePoint := chargerTexture(affichage, 'point');
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

{Renvoie la couleur associe au joueur
Preconditions :
    - joueurId : l'identifiant du joueur
Postconditions :
    - couleur (TSDL_Color) : la couleur associee au joueur}
procedure recupererCouleurJoueur(joueurId: Integer; var couleur: TSDL_Color);
begin
    case joueurId of
        0: begin
            couleur.r := 255; couleur.g := 0; couleur.b := 0;
        end;
        1: begin
            couleur.r := 0; couleur.g := 255; couleur.b := 0;
        end;
        2: begin
            couleur.r := 0; couleur.g := 0; couleur.b := 255;
        end;
        3: begin
        couleur.r := 255; couleur.g := 255; couleur.b := 0;
        end;
    end;
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
    if SDL_FillRect(surface, nil, SDL_MapRGB(surface^.format, couleur.r, couleur.g, couleur.b)) <> 0 then
        WriteLn('Erreur SDL: ', SDL_GetError());

    texture := SDL_CreateTextureFromSurface(affichage.renderer, surface);

    creerTextureCouleur := texture;
end;

{Calcul les coordonnees d'une connexion
Preconditions :
    - connexion : la connexion à calculer
Postconditions :
    - coord (TCoord) : les coordonnees du milieu de la connexion
    - longueur (Real) : la longueur de la connexion
    - angle (Real) : l'angle de la connexion}
procedure calculPosConnexion(connexion: TConnexion; var coord: Tcoord; var longueur: Real; var angle: Real);
var dx,dy: Integer;
    coord2: Tcoord;
begin
    hexaToCart(connexion.Position[0],coord,tailleHexagone div 2);
    hexaToCart(connexion.Position[1],coord2,tailleHexagone div 2);

    dx := coord2.x - coord.x;
    dy := coord2.y - coord.y;

    coord := FCoord((coord.x + coord2.x) div 2,(coord.y + coord2.y) div 2);

    longueur := tailleHexagone div 2;
    angle := RadToDeg(arctan2(dy,dx)+PI/2);
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
    epaisseur := 6;
    recupererCouleurJoueur(connexion.IdJoueur,couleur);
    calculPosConnexion(connexion,coord,longueur,angle);

    destination_rect.x:=affichage.xGrid + coord.x - Round(epaisseur*abs(Sin(angle)) / 2) - tailleHexagone div 4 + epaisseur div 2;
    destination_rect.y:=affichage.yGrid + coord.y - Round(epaisseur*abs(Cos(angle)) / 2) - epaisseur div 3;
    destination_rect.w:=Round(longueur);
    destination_rect.h:=epaisseur;

    //TODO Voir pour le placement + l'angle de rotation (si besoin faire une condition pour le sens de la rotation)

    colorTexture := creerTextureCouleur(affichage,couleur);

    if SDL_RenderCopyEx(affichage.renderer, colorTexture, nil, @destination_rect, angle, nil, SDL_FLIP_NONE) <> 0 then
        WriteLn('Erreur SDL: ', SDL_GetError());

    SDL_DestroyTexture(colorTexture);
end;

{Calcul les coordonnees d'une personne
Preconditions :
    - personne : la personne à calculer
Postconditions :
    - TCoord : les coordonnees de la personne}
function calculPosPersonne(personne : TPersonne): Tcoord;
var scoord,coord: Tcoord;
    i: Integer;
begin
    scoord := FCoord(0,0);
    
    for i:=0 to length(personne.Position)-1 do
    begin
        hexaToCart(personne.Position[i],coord,tailleHexagone div 2);
        scoord := FCoord(scoord.x + coord.x,scoord.y + coord.y);
    end;

    calculPosPersonne := FCoord(scoord.x div 3,scoord.y div 3);
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

    recupererCouleurJoueur(personne.IdJoueur,couleur);
    SDL_SetTextureColorMod(texture, couleur.r, couleur.g, couleur.b);

    affichageImage(affichage.xGrid + coord.x -(tailleEleve div 2),affichage.yGrid + coord.y -(tailleEleve div 2),tailleEleve,tailleEleve,texture,affichage);
end;

{Retourne les coordonnees du clic de la souris (système cartesien)
Preconditions :
    - affichage : la structure contenant le renderer
Postconditions :
    - coord (TCoord) : les coordonnees du clic (système cartesien)}
procedure clicCart(var affichage: TAffichage; var coord: Tcoord);
var running : Boolean;
    event: TSDL_Event;
begin
    running := True;

    while running do
    begin
        attendre(66);
        while SDL_PollEvent(@event) <> 0 do
        begin
            case event.type_ of
                SDL_QUITEV:
                begin
                    halt();
                end;
                SDL_MOUSEBUTTONDOWN:
                begin
                    coord := FCoord(event.button.x,event.button.y);
                    running := False;
                    break;
                end;
            end;
        end;
    end;
end;

{Renvoie les coordonnees du clic de la souris (système hexagonal)
Preconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - coord (TCoord): les coordonnees du clic (système hexagonal)}
procedure clicHexagone(var plat: TPlateau; var affichage: TAffichage; var coord: Tcoord);
var tempCoord: Tcoord;
begin
    clicCart(affichage,coord);

    cartToHexa(FCoord(coord.x-affichage.xGrid,coord.y-affichage.yGrid),tempCoord,tailleHexagone div 2);
    
    coord := tempCoord;
    jouerSonClic();
    attendre(66);
end;

// Transforme du texte en une texture
function LoadTextureFromText(renderer:PRenderer; police:PTTF_Font; text:String;color:TSDL_Color):PSDL_Texture;
var surface : PSDL_Surface;
	texture : PSDL_Texture;
	text_compa : Ansistring;
begin
	text_compa := text;
	surface := TTF_RenderText_Solid(police,PChar(text_compa),color);
	
	// Cree une surface SDL contenant le texte rendu avec la police specifiee et la couleur donnee
	texture := SDL_CreateTextureFromSurface(renderer,surface);
	
	LoadTextureFromText := texture;
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
	// Definit le rectangle de destination pour le texte
	textRect.x := coord.x;
	textRect.y := coord.y;
	textRect.w := 0;
	textRect.h := 0;
	
	if TTF_INIT=-1 then halt;
	
	police := TTF_OpenFont('Assets/OpenSans-Regular.ttf', taille);
	
	texteTexture := LoadTextureFromText(affichage.renderer,police,text,couleur);
	SDL_QueryTexture(texteTexture,nil,nil,@textRect.w,@textRect.h);
	
	if SDL_RenderCopy(affichage.renderer,texteTexture,nil,@textRect)<>0 then
        WriteLn('Erreur SDL: ', SDL_GetError());
	
	TTF_CloseFont(police);
	TTF_Quit();
	SDL_DestroyTexture(texteTexture);
end;

procedure affichageDe(de,rotation:Integer; coord:TCoord; var affichage: TAffichage);
var destination_rect: TSDL_RECT;
begin
    destination_rect.x:=coord.x;
    destination_rect.y:=coord.y;
    destination_rect.w:=75;
    destination_rect.h:=75;

    SDL_RenderCopyEx(affichage.renderer, chargerTexture(affichage, 'DiceFaces/' + IntToStr(de)), nil, @destination_rect, rotation, nil, SDL_FLIP_NONE);
end;

procedure affichageDetailsHexagone(coordHexa,coordCart: TCoord; plat: TPlateau; var affichage: TAffichage);
var coord: Tcoord;
    texture: PSDL_Texture;
begin
    if (plat.Grille[coordHexa.x,coordHexa.y].ressource = Rien) then
        texture := affichage.texturePlateau.textureContourVide
    else
        texture := affichage.texturePlateau.textureContourHexagone;

    affichageImage(affichage.xGrid+coordCart.x-(Round(tailleHexagone * 1.05) div 2),affichage.yGrid+coordCart.y-(Round(tailleHexagone * 1.05) div 2),Round(tailleHexagone * 1.05),Round(tailleHexagone * 1.05),texture,affichage);

    coord := FCoord(affichage.xGrid+coordCart.x - 40 div 2,affichage.yGrid+coordCart.y - 50 div 2 - 5);
    if plat.Grille[coordHexa.x,coordHexa.y].Numero div 10 >= 1 then
        affichageTexte(IntToStr(plat.Grille[coordHexa.x,coordHexa.y].Numero), 40, coord, FCouleur(0,0,0,255), affichage)
    else if (plat.Grille[coordHexa.x,coordHexa.y].Numero <> -1 )then
        affichageTexte(' ' + IntToStr(plat.Grille[coordHexa.x,coordHexa.y].Numero), 40, coord, FCouleur(0,0,0,255), affichage);
end;

{Affiche un hexagone à l'ecran
Preconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
    - q,r : les coordonnees de l'hexagone
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichageHexagone(plat: TPlateau; var affichage: TAffichage; coordHexa: TCoord);
var coordCart: TCoord;
begin
    hexaToCart(coordHexa,coordCart,tailleHexagone div 2);

    if (plat.Grille[coordHexa.x,coordHexa.y].ressource <> Aucune) then
        affichageImage(affichage.xGrid+coordCart.x-(tailleHexagone div 2),affichage.yGrid+coordCart.y-(tailleHexagone div 2),tailleHexagone,tailleHexagone,affichage.texturePlateau.textureRessource[plat.Grille[coordHexa.x,coordHexa.y].ressource],affichage);
    
    affichageDetailsHexagone(coordHexa,coordCart,plat,affichage);
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
    
    affichageDetailsHexagone(plat.Souillard.Position,coord,plat,affichage);
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
    affichageFond(affichage);

    taille := length(plat.Grille);

    for q:=0 to taille-1 do
        for r:=0 to taille-1 do
            if (plat.Grille[q,r].ressource <> Aucune) then
            begin
                affichageHexagone(plat,affichage,FCoord(q,r));
            end;
end;

procedure affichageDes(de1,de2:Integer; coord: TCoord; var affichage: TAffichage);
begin
    affichageDe(de1,-15,coord,affichage);
    affichageDe(de2,20,FCoord(coord.x+75,coord.y),affichage);
end;

procedure affichageScore(joueur:TJoueur; var affichage: TAffichage);
var coord: Tcoord;
    ressource: TRessource;
begin
    coord := FCoord(25,25+joueur.id*75);

    affichageTexte(joueur.Nom + ': ', 25, coord, FCouleur(0,0,0,255), affichage);

    coord.x := coord.x + 13*(length(joueur.Nom)+2);

    affichageImage(coord.x,coord.y+7,25,25,affichage.texturePlateau.texturePoint,affichage);
    affichageTexte(IntToStr(joueur.Points), 25, FCoord(coord.x+30,coord.y), FCouleur(0,0,0,255), affichage);


    coord.x := 25;
    coord.y := coord.y + 35;

    for ressource := Physique to Mathematiques do
    begin
        affichageImage(coord.x,coord.y,25,25,affichage.texturePlateau.textureIconesRessources[ressource],affichage);

        coord.x := coord.x + 25;

        affichageTexte(' ' + IntToStr(joueur.Ressources[ressource]), 25, FCoord(coord.x,coord.y-5), FCouleur(0,0,0,255), affichage);

        coord.x := coord.x + 40;
    end;
end;

procedure ajouterBoutonTableau(texte: String; valeur: String; coord: Tcoord; w,h:Integer; var boutons: TBoutons);
begin
    setLength(boutons, length(boutons)+1);
    boutons[length(boutons)-1].coord := coord;
    boutons[length(boutons)-1].w := w;
    boutons[length(boutons)-1].h := h;
    boutons[length(boutons)-1].texte := texte;
    boutons[length(boutons)-1].valeur := valeur;
end;

procedure affichageZone(x,y,w,h,epaisseurBord: Integer; var affichage: TAffichage);
var bordure,interieur: TSDL_Rect;
begin
    SDL_SetRenderDrawColor(affichage.renderer, 0, 0, 0, 255);
    bordure.x := x;
    bordure.y := y;
    bordure.w := w;
    bordure.h := h;
    if SDL_RenderFillRect(affichage.renderer, @bordure) <> 0 then
        WriteLn('Erreur SDL: ', SDL_GetError());

    SDL_SetRenderDrawColor(affichage.renderer, 255, 255, 255, 255);
    interieur.x := x+epaisseurBord;
    interieur.y := y+epaisseurBord;
    interieur.w := w-epaisseurBord*2;
    interieur.h := h-epaisseurBord*2;
    if SDL_RenderFillRect(affichage.renderer, @interieur) <> 0 then
        WriteLn('Erreur SDL: ', SDL_GetError());
end;
procedure suppressionScores(playerId: Integer; var affichage: TAffichage);
begin
    affichageZone(25,25+playerId*75,325,65,0,affichage);
end;

procedure affichageBouton(bouton: TBouton; var affichage: TAffichage);
var epaisseurBord: Integer;
begin
    epaisseurBord := 2;

    affichageZone(bouton.coord.x,bouton.coord.y,bouton.w,bouton.h,epaisseurBord,affichage);

    affichageTexte(' '+bouton.texte, 25, bouton.coord, FCouleur(0,0,0,255), affichage);
end;

procedure suppressionInformation(var affichage: TAffichage);
begin
    affichageZone(400,1025,1500,50,0,affichage);
    attendre(66);
end;

procedure affichageInformation(texte: String; taille: Integer; couleur: TSDL_Color; var affichage: TAffichage);
begin
    suppressionInformation(affichage);
    affichageTexte(texte, taille, FCoord(400,1025), couleur, affichage);
    miseAJourRenderer(affichage);
    attendre(66);
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
        running := False;
        writeln('Erreur : Pas de boutons');
    end;

    while running do
    begin
        clicCart(affichage,coord);
        
        for i:=0 to length(boutons)-1 do
        begin
            if (coord.x >= boutons[i].coord.x) and (coord.x <= boutons[i].coord.x + boutons[i].w) and (coord.y >= boutons[i].coord.y) and (coord.y <= boutons[i].coord.y + boutons[i].h) then
            begin
                valeurBouton := boutons[i].valeur;
                running := False;
                break;
            end;
        end;
        
        attendre(66);
    end;
end;

procedure affichageIntegerInput(coord:TCoord; ressource: String; id: String; ressources: TRessources; var affichage: TAffichage; var boutons: TBoutons);
var bouton: TBouton;
begin
    bouton.coord := coord;
    bouton.w := 30;
    bouton.h := 33;

    bouton.coord.x := coord.x + 120;
    bouton.texte := '+';
    affichageBouton(bouton,affichage);
    ajouterBoutonTableau('+', ressource + '_plus_' + id, bouton.coord, 30, 33, boutons);

    bouton.coord.x := coord.x + 155;
    bouton.texte := ' -';
    affichageBouton(bouton,affichage);
    ajouterBoutonTableau('-', ressource + '_moins_' + id, bouton.coord, 30, 33, boutons);

    coord.x := coord.x + 200;
    affichageTexte(ressource + ' : ' + IntToStr(ressources[TRessource(GetEnumValue(TypeInfo(TRessource), ressource))]), 25, coord, FCouleur(0,0,0,255), affichage);
end;

procedure affichageJoueurInput(joueurs: TJoueurs; id: Integer; coord:TCoord; var affichage: TAffichage; var boutons: TBoutons);
var bouton: TBouton;
begin
    bouton.coord := coord;
    bouton.w := 30;
    bouton.h := 33;

    bouton.coord.x := coord.x + 120;
    bouton.texte := '<';
    affichageBouton(bouton,affichage);
    ajouterBoutonTableau('<', 'joueur_precedent', bouton.coord, 30, 33, boutons);

    bouton.coord.x := coord.x + 155;
    bouton.texte := '>';
    affichageBouton(bouton,affichage);
    ajouterBoutonTableau('>', 'joueur_suivant', bouton.coord, 30, 33, boutons);

    coord.x := coord.x + 200;
    affichageTexte(joueurs[id].Nom, 25, coord, FCouleur(0,0,0,255), affichage);
end;

procedure affichageEchangeRessources(joueurs: TJoueurs; idJoueurActuel,idJoueurEchange: Integer; ressources1,ressources2: TRessources;var affichage: TAffichage; var boutons: TBoutons);
var coord: Tcoord;
    bouton: TBouton;
    ressource: TRessource;
begin
    affichageFond(affichage);

    attendre(66);

    coord := FCoord(450,70);
    affichageZone(coord.x,coord.y,1050,930,3,affichage);

    coord := FCoord(890,90);
    affichageTexte('Echange', 35, coord, FCouleur(0,0,0,255), affichage);

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

    bouton.coord := FCoord(900,450);
    bouton.w := 95;
    bouton.h := 45;
    bouton.texte := 'Valider';
    affichageBouton(bouton,affichage);
    ajouterBoutonTableau('Valider', 'valider_echange', bouton.coord, 95, 45, boutons);
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
            idJoueurEchange := (idJoueurEchange - 1 + length(joueurs)) mod length(joueurs)
        else if valeurBouton = 'joueur_suivant' then
            idJoueurEchange := (idJoueurEchange + 1) mod length(joueurs)
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
        //TODO Voir pour pas tout refresh à chaque fois
        nettoyageAffichage(affichage);
        affichageEchangeRessources(joueurs,idJoueurActuel,idJoueurEchange,ressources1,ressources2,affichage,boutons);
        miseAJourRenderer(affichage);

        clicBouton(affichage,boutons,valeurBouton);
    end;
end;

procedure clicAction(var affichage: TAffichage; var valeurBouton: String);
begin
    clicBouton(affichage,affichage.boutonsAction,valeurBouton);
end;

{Affiche le tour à l'ecran
Preconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichageTour(plat: TPlateau; joueurs: TJoueurs; var affichage: TAffichage);
var i: Integer;
begin
    nettoyageAffichage(affichage);

    affichageFond(affichage);

    affichageGrille(plat,affichage);
    
    affichageSouillard(plat,affichage);

    affichageDes(plat.des1,plat.des2,FCoord(50,500),affichage);

    for i:=0 to length(plat.Connexions)-1 do
        affichageConnexion(plat.Connexions[i],affichage);
    
    for i:=0 to length(plat.Personnes)-1 do
        affichagePersonne(plat.Personnes[i],affichage);
    
    for i:=0 to length(affichage.boutonsAction)-1 do
        affichageBouton(affichage.boutonsAction[i],affichage);
    
    for i:=0 to length(joueurs)-1 do
        affichageScore(joueurs[i],affichage);

    miseAJourRenderer(affichage);
end;

{Met à jour l'affichage
Preconditions :
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure miseAJourRenderer(var affichage :TAffichage);
begin
    SDL_RenderPresent(affichage.renderer);
end;

procedure initialisationBoutonsAction(var affichage: TAffichage);
var coord: Tcoord;
begin
    setLength(affichage.boutonsAction, 0);

    coord.x := 25;
    coord.y := WINDOW_H - 370;
    ajouterBoutonTableau('Achat connexion', 'achat_connexion', coord, 270, 50, affichage.boutonsAction);

    coord.y := WINDOW_H - 310;
    ajouterBoutonTableau('Achat eleve', 'achat_eleve', coord, 270, 50, affichage.boutonsAction);

    coord.y := WINDOW_H - 250;
    ajouterBoutonTableau('Achat carte tutorat', 'achat_carte_tutorat', coord, 270, 50, affichage.boutonsAction);

    coord.y := WINDOW_H - 190;
    ajouterBoutonTableau('Changement en prof', 'changement_en_prof', coord, 270, 50, affichage.boutonsAction);

    coord.y := WINDOW_H - 130;
    ajouterBoutonTableau('Echange', 'echange', coord, 270, 50, affichage.boutonsAction);

    coord.y := WINDOW_H - 70;
    ajouterBoutonTableau('Fin de tour', 'fin_tour', coord, 270, 50, affichage.boutonsAction);
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

    affichage.xGrid := 100;
    affichage.yGrid := 100;

    initialisationTextures(affichage);
    initialisationBoutonsAction(affichage);
end;

end.
