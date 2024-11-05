unit affichageUnit;


interface

uses sdl2, sdl2_image, sdl2_ttf, types, sysutils, TypInfo, traitement, Math;

procedure initialisationSDL(var affichage: TAffichage);
procedure initialisationAffichage(var affichage: TAffichage);
procedure affichageGrille(plat: TPlateau; var affichage: TAffichage);
//procedure testAffichagePlateau(plat: TPlateau);
procedure clicHexagone(var plat: TPlateau; var affichage: TAffichage; var coord: Tcoord);
procedure miseAJourRenderer(var affichage :TAffichage);
procedure affichageTexte(text:String; taille:Integer; coord:Tcoord; var affichage:TAffichage);
procedure affichagePersonne(personne: TPersonne; var affichage: TAffichage);
procedure affichageSouillard(plat: TPlateau; var affichage: TAffichage);
procedure affichageConnexion(connexion : TConnexion; var affichage : TAffichage);
procedure affichageTour(plat: TPlateau; var affichage: TAffichage);

implementation

const
    WINDOW_W = 1920;
    WINDOW_H = 1080;
    tailleHexagone = 220;
    taillePersonne = tailleHexagone div 5;
    tailleSouillard = tailleHexagone div 2;

// Permet de charger la texture de l'image
{Permet de charger la texture de l'image
Préconditions :
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
	
	// Verifie si le chargement a réussi
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

    //TODO Check si tout est bien initialisé
    affichage.fenetre := SDL_CreateWindow('Catan', SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, WINDOW_W, WINDOW_H, SDL_WINDOW_SHOWN);
    affichage.renderer := SDL_CreateRenderer(affichage.fenetre, -1, SDL_RENDERER_ACCELERATED);
end;

{procedure testAffichagePlateau(plat: TPlateau);
var q,r,taille: Integer;
begin
    taille := length(plat.Grille);
    for r:=0 to taille-1 do
    begin
        for q:=0 to taille-1 do
        begin
            write(plat.Grille[q,r].ressource);
            write(plat.Grille[q,r].Numero);
            write(' ');
        end;
        writeln();
    end;
end;}

{Initialise le plateau de jeu
Préconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer}
procedure initialisationTextures(var affichage: TAffichage);
var i: TRessource;
begin
    for i:=Physique to Mathematiques do
    begin
        affichage.texturePlateau.textureRessource[i] := chargerTexture(affichage, GetEnumName(TypeInfo(TRessource), Ord(i)));
    end;
end;

{Initialise l'affichage
Préconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer}
procedure initialisationAffichage(var affichage: TAffichage);
begin
    initialisationSDL(affichage);

    affichage.xGrid := 100;
    affichage.yGrid := 25;

    initialisationTextures(affichage);
end;

{Affiche un hexagone à l'écran
Préconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
    - q,r : les coordonnées de l'hexagone
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichageHexagone(plat: TPlateau; var affichage: TAffichage; q, r: Integer);
var destination_rect: TSDL_RECT;
    texture: PSDL_Texture;
    x,y: Integer;
begin

    texture := affichage.texturePlateau.textureRessource[plat.Grille[q,r].ressource];

    hexaToCard(q,r,tailleHexagone div 2,x,y);
	
	// Définit le carre de destination pour l'affichage de la carte
	destination_rect.x:=affichage.xGrid+x-(tailleHexagone div 2);
	destination_rect.y:=affichage.yGrid+y-(tailleHexagone div 2);
	destination_rect.w:=tailleHexagone;
	destination_rect.h:=tailleHexagone;

	SDL_RenderCopy(affichage.renderer,texture,nil,@destination_rect);
end;

{Affiche le fond de l'écran en blanc
Préconditions :
    - affichage : la structure contenant le renderer}
procedure affichageFond(var affichage: TAffichage);
begin
    SDL_SetRenderDrawColor(affichage.renderer, 255, 255, 255, 255);
    SDL_RenderClear(affichage.renderer);
end;

{Affiche la grille à l'écran
Préconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichageGrille(plat: TPlateau; var affichage: TAffichage);
var q,r,taille: Integer;
    //gridSize: Integer;
begin
    affichageFond(affichage);

    taille := length(plat.Grille);
    //gridSize := taille div 2;

    //and not ((q+r<=gridSize) or (q+r>=gridSize*gridSize))
    for q:=0 to taille-1 do
        for r:=0 to taille-1 do
            if (plat.Grille[q,r].ressource <> Aucune) then
                affichageHexagone(plat,affichage,q,r);
end;

{Renvoie la couleur associé au joueur
Préconditions :
    - joueurId : l'identifiant du joueur
Postconditions :
    - couleur (TSDL_Color) : la couleur associée au joueur}
procedure recupererCouleurJoueur(joueurId: Integer; var couleur: TSDL_Color);
begin
    case joueurId of
        1: begin
            couleur.r := 255; couleur.g := 0; couleur.b := 0;
        end;
        2: begin
            couleur.r := 0; couleur.g := 255; couleur.b := 0;
        end;
        3: begin
            couleur.r := 0; couleur.g := 0; couleur.b := 255;
        end;
        4: begin
        couleur.r := 255; couleur.g := 255; couleur.b := 0;
        end;
    end;
end;

{Crée une texture de couleur
Préconditions :
    - affichage : la structure contenant le renderer
    - r,g,b : les valeurs RGB de la couleur
Postconditions :
    - PSDL_Texture : la texture de couleur}
function creerTextureCouleur(affichage: TAffichage; couleur:TSDL_Color): PSDL_Texture;
var surface : PSDL_Surface;
    texture : PSDL_Texture;
begin
    surface := SDL_CreateRGBSurface(0, 1, 1, 32, 0, 0, 0, 0);
    SDL_FillRect(surface, nil, SDL_MapRGB(surface^.format, couleur.r, couleur.g, couleur.b));

    texture := SDL_CreateTextureFromSurface(affichage.renderer, surface);

    creerTextureCouleur := texture;
end;

{Calcul les coordonnées d'une connexion
Préconditions :
    - connexion : la connexion à calculer
Postconditions :
    - coord (TCoord) : les coordonnées du milieu de la connexion
    - longueur (Real) : la longueur de la connexion
    - angle (Real) : l'angle de la connexion}
procedure calculPosConnexion(connexion: TConnexion; var coord: Tcoord; var longueur: Real; var angle: Real);
var dx,dy: Integer;
    coord2: Tcoord;
begin
    hexaToCard(connexion.Position[0].x,connexion.Position[0].y,tailleHexagone div 2,coord.x,coord.y);
    hexaToCard(connexion.Position[1].x,connexion.Position[1].y,tailleHexagone div 2,coord2.x,coord2.y);

    dx := coord2.x - coord.x;
    dy := coord2.y - coord.y;

    coord.x := (coord.x + coord2.x) div 2;
    coord.y := (coord.y + coord2.y) div 2;

    longueur := tailleHexagone div 2;
    angle := RadToDeg(arctan2(dy,dx)+PI/2);
end;

{Affiche la connexion à l'écran
Préconditions :
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

    SDL_RenderCopyEx(affichage.renderer, colorTexture, nil, @destination_rect, angle, nil, SDL_FLIP_NONE);

    SDL_DestroyTexture(colorTexture);
end;

{Calcul les coordonnées d'une personne
Préconditions :
    - personne : la personne à calculer
Postconditions :
    - TCoord : les coordonnées de la personne}
function calculPosPersonne(personne : TPersonne): Tcoord;
var scoord: Tcoord;
    i: Integer;
    x,y: Integer;
begin
    scoord.x := 0;
    scoord.y := 0;
    
    for i:=0 to length(personne.Position)-1 do
    begin
        hexaToCard(personne.Position[i].x,personne.Position[i].y,tailleHexagone div 2,x,y);
        scoord.x := scoord.x + x;
        scoord.y := scoord.y + y;
    end;

    scoord.x := scoord.x div length(personne.Position);
    scoord.y := scoord.y div length(personne.Position);

    calculPosPersonne := scoord;
end;

{Affiche la personne à l'écran
Préconditions :
    - personne : la personne à afficher
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichagePersonne(personne: TPersonne; var affichage: TAffichage);
var coord: Tcoord;
    destination_rect: TSDL_RECT;
    texture: PSDL_Texture;
    couleur: TSDL_Color;
begin
    coord := calculPosPersonne(personne);
    coord.x := affichage.xGrid + coord.x;
    coord.y := affichage.yGrid + coord.y;

    texture := chargerTexture(affichage, 'person');
    recupererCouleurJoueur(personne.IdJoueur,couleur);
    SDL_SetTextureColorMod(texture, couleur.r, couleur.g, couleur.b);
	
	// Définit le carre de destination pour l'affichage de la carte
	destination_rect.x:=coord.x-(taillePersonne div 2);
	destination_rect.y:=coord.y-(taillePersonne div 2);
	destination_rect.w:=taillePersonne;
	destination_rect.h:=taillePersonne;

	SDL_RenderCopy(affichage.renderer,texture,nil,@destination_rect);
end;

{Affiche le souillard à l'écran
Préconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichageSouillard(plat: TPlateau; var affichage: TAffichage);
var coord: Tcoord;
    destination_rect: TSDL_RECT;
    texture: PSDL_Texture;
    x,y: Integer;
begin
    hexaToCard(plat.Souillard.Position.x,plat.Souillard.Position.y,tailleHexagone div 2,x,y);
    coord.x := affichage.xGrid + x;
    coord.y := affichage.yGrid + y;

    texture := chargerTexture(affichage, 'souillard');
    
    // Définit le carre de destination pour l'affichage de la carte
    destination_rect.x:=coord.x-(tailleSouillard div 2);
    destination_rect.y:=coord.y-(Round(tailleSouillard*1.3) div 2);
    destination_rect.w:=tailleSouillard;
    destination_rect.h:=Round(tailleSouillard*1.3);

    SDL_RenderCopy(affichage.renderer,texture,nil,@destination_rect);
end;

procedure nettoyageAffichage(var affichage: TAffichage);
begin
    //TODO
end;

{Retourne les coordonnées du clic de la souris (système cartésien)
Préconditions :
    - affichage : la structure contenant le renderer
Postconditions :
    - coord (TCoord) : les coordonnées du clic (système cartésien)}
procedure clicCart(var affichage: TAffichage; var coord: Tcoord);
var running : Boolean;
    event: TSDL_Event;
begin
    running := True;

    while running do
    begin
        SDL_Delay(10);
        while SDL_PollEvent(@event) <> 0 do
        begin
            case event.type_ of
                SDL_QUITEV:
                begin
                    halt();
                end;
                SDL_MOUSEBUTTONDOWN:
                begin
                    coord.x := event.button.x-affichage.xGrid;
                    coord.y := event.button.y-affichage.yGrid;
                    running := False;
                    break;
                end;
            end;
        end;
    end;
end;

{Renvoie les coordonnées du clic de la souris (système hexagonal)
Préconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - coord (TCoord): les coordonnées du clic (système hexagonal)}
procedure clicHexagone(var plat: TPlateau; var affichage: TAffichage; var coord: Tcoord);
var running: Boolean;
    q,r: Integer;
begin
    running := True;

    while running do
    begin
        clicCart(affichage,coord);
        cardToHexa(coord.x,coord.y,tailleHexagone div 2,q,r);

      // TODO modifier pour pouvoir poser des routes au bords de la grille
        writeln(q,' ',r);
        if not((q < 0) or (r < 0) or (q-1 >= length(plat.Grille)-1) or (r-1 >= length(plat.Grille)-1)) then
        begin
            running := False;
            coord.x := q;
            coord.y := r;
        end;
        SDL_Delay(10);
    end;
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

{Affiche du texte à l'écran
Préconditions :
    - text : le texte à afficher
    - taille : la taille de la police
    - coord : les coordonnées du texte (système cartésien)
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichageTexte(text:String; taille:Integer; coord:Tcoord; var affichage:TAffichage);
var police:PTTF_Font;
	texteTexture:PSDL_Texture;
	couleur : TSDL_Color;
	textRect : TSDL_Rect;
begin
	// Definit le rectangle de destination pour le texte
	textRect.x := coord.x;
	textRect.y := coord.y;
	textRect.w := 0;
	textRect.h := 0;
	
	if TTF_INIT=-1 then halt;
	
	couleur.r:=0;
	couleur.g:=0;
	couleur.b:=0;
	couleur.a:=255;
	
	police := TTF_OpenFont('Assets/OpenSans-Regular.ttf', taille);
	
	texteTexture := LoadTextureFromText(affichage.renderer,police,text,couleur);
	SDL_QueryTexture(texteTexture,nil,nil,@textRect.w,@textRect.h);
	
	SDL_RenderCopy(affichage.renderer,texteTexture,nil,@textRect);
	
	TTF_CloseFont(police);
	TTF_Quit();
	SDL_DestroyTexture(texteTexture);
end;

{Affiche le tour à l'écran
Préconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichageTour(plat: TPlateau; var affichage: TAffichage);
var i: Integer;
begin
    affichageGrille(plat,affichage);
    affichageSouillard(plat,affichage);

    for i:=0 to length(plat.Connexions)-1 do
        affichageConnexion(plat.Connexions[i],affichage);
    
    for i:=0 to length(plat.Personnes)-1 do
        affichagePersonne(plat.Personnes[i],affichage);

    miseAJourRenderer(affichage);
end;

{Met à jour l'affichage
Préconditions :
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure miseAJourRenderer(var affichage :TAffichage);
begin
    SDL_RenderPresent(affichage.renderer);
end;

end.