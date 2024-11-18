unit affichageUnit;


interface

uses sdl2, sdl2_image, sdl2_ttf, types, sysutils, TypInfo, traitement, Math;

procedure initialisationSDL(var affichage: TAffichage);
procedure initialisationAffichage(var affichage: TAffichage);
procedure affichageGrille(plat: TPlateau; var affichage: TAffichage);
procedure clicHexagone(var plat: TPlateau; var affichage: TAffichage; var coord: Tcoord);
procedure miseAJourRenderer(var affichage :TAffichage);
procedure affichageTexte(text:String; taille:Integer; coord:Tcoord; var affichage:TAffichage);
procedure affichagePersonne(personne: TPersonne; var affichage: TAffichage);
procedure affichageSouillard(plat: TPlateau; var affichage: TAffichage);
procedure affichageConnexion(connexion : TConnexion; var affichage : TAffichage);
procedure affichageDes(de1,de2:Integer; coord: TCoord; var affichage: TAffichage);
procedure echangeRessources(joueurs: TJoueurs; idJoueurActuel:Integer; var idJoueurEchange: Integer; var ressources1, ressources2: TRessources; var affichage: TAffichage);
procedure affichageTour(plat: TPlateau; joueurs: TJoueurs; var affichage: TAffichage);
procedure clicAction(var affichage: TAffichage; var valeurBouton: String);
procedure affichageScore(joueurs: TJoueurs; id: Integer; var affichage: TAffichage);

implementation

const
    WINDOW_W = 1920;
    WINDOW_H = 1080;
    tailleHexagone = 180;
    taillePersonne = tailleHexagone div 5;
    tailleSouillard = tailleHexagone div 2;

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


procedure nettoyageAffichage(var affichage: TAffichage);
begin
    SDL_RenderClear(affichage.renderer);
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

    affichage.texturePlateau.textureContourHexagone := chargerTexture(affichage, 'hexagoneCercle');
    affichage.texturePlateau.textureContourVide := chargerTexture(affichage, 'hexagone');
    affichage.texturePlateau.textureEleve := chargerTexture(affichage, 'person');
    affichage.texturePlateau.textureSouillard := chargerTexture(affichage, 'souillard');
    affichage.texturePlateau.textureProfesseur := chargerTexture(affichage, 'person');
end;

procedure affichageDetailsHexagone(q,r,x,y: Integer; plat: TPlateau; var affichage: TAffichage);
var destination_rect: TSDL_RECT;
    coord: Tcoord;
    texture: PSDL_Texture;
begin
    if (plat.Grille[q,r].ressource = Rien) then
        texture := affichage.texturePlateau.textureContourVide
    else
        texture := affichage.texturePlateau.textureContourHexagone;

    destination_rect.x:=affichage.xGrid+x-(Round(tailleHexagone * 1.05) div 2);
    destination_rect.y:=affichage.yGrid+y-(Round(tailleHexagone * 1.05) div 2);
    destination_rect.w:=Round(tailleHexagone * 1.05);
    destination_rect.h:=Round(tailleHexagone * 1.05);

    if SDL_RenderCopy(affichage.renderer,texture,nil,@destination_rect)<>0 then
        WriteLn('Erreur SDL: ', SDL_GetError());

    coord.x:=affichage.xGrid+x - 40 div 2;
    coord.y:=affichage.yGrid+y - 50 div 2;
    if plat.Grille[q,r].Numero div 10 >= 1 then
        affichageTexte(IntToStr(plat.Grille[q,r].Numero), 40, coord, affichage)
    else if (plat.Grille[q,r].Numero <> -1 )then
        affichageTexte(' ' + IntToStr(plat.Grille[q,r].Numero), 40, coord, affichage);
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
    hexaToCard(q,r,tailleHexagone div 2,x,y);

    if (plat.Grille[q,r].ressource <> Rien) then
    begin
        // Définit le carre de destination pour l'affichage de la carte
        destination_rect.x:=affichage.xGrid+x-(tailleHexagone div 2);
        destination_rect.y:=affichage.yGrid+y-(tailleHexagone div 2);
        destination_rect.w:=tailleHexagone;
        destination_rect.h:=tailleHexagone;

        texture := affichage.texturePlateau.textureRessource[plat.Grille[q,r].ressource];
        if SDL_RenderCopy(affichage.renderer,texture,nil,@destination_rect)<>0 then
            WriteLn('Erreur SDL: ', SDL_GetError());
    end;

    affichageDetailsHexagone(q,r,x,y,plat,affichage);
end;

{Affiche le fond de l'écran en blanc
Préconditions :
    - affichage : la structure contenant le renderer}
procedure affichageFond(var affichage: TAffichage);
begin
    SDL_SetRenderDrawColor(affichage.renderer, 255, 255, 255, 255);
    if SDL_RenderClear(affichage.renderer) <> 0 then
        WriteLn('Erreur SDL: ', SDL_GetError());
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
        // TODO changer pour avoir l'affichage des hexagone "Aucune" en couleur unis pour montrer les bord
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
    if SDL_FillRect(surface, nil, SDL_MapRGB(surface^.format, couleur.r, couleur.g, couleur.b)) <> 0 then
        WriteLn('Erreur SDL: ', SDL_GetError());

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

    if SDL_RenderCopyEx(affichage.renderer, colorTexture, nil, @destination_rect, angle, nil, SDL_FLIP_NONE) <> 0 then
        WriteLn('Erreur SDL: ', SDL_GetError());

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
    scoord := FCoord(0,0);
    
    for i:=0 to length(personne.Position)-1 do
    begin
        hexaToCard(personne.Position[i].x,personne.Position[i].y,tailleHexagone div 2,x,y);
        scoord.x := scoord.x + x;
        scoord.y := scoord.y + y;
    end;

    scoord.x := scoord.x div 3;
    scoord.y := scoord.y div 3;

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

    if personne.estEleve then
        texture := affichage.texturePlateau.textureEleve
    else
        texture := affichage.texturePlateau.textureProfesseur;

    recupererCouleurJoueur(personne.IdJoueur,couleur);
    SDL_SetTextureColorMod(texture, couleur.r, couleur.g, couleur.b);
	
	// Définit le carre de destination pour l'affichage de la carte
	destination_rect.x:=affichage.xGrid + coord.x -(taillePersonne div 2);
	destination_rect.y:=affichage.yGrid + coord.y -(taillePersonne div 2);
	destination_rect.w:=taillePersonne;
	destination_rect.h:=taillePersonne;

	if SDL_RenderCopy(affichage.renderer,texture,nil,@destination_rect) <> 0 then
        WriteLn('Erreur SDL: ', SDL_GetError());
end;

{Affiche le souillard à l'écran
Préconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichageSouillard(plat: TPlateau; var affichage: TAffichage);
var destination_rect: TSDL_RECT;
    texture: PSDL_Texture;
    x,y: Integer;
begin
    hexaToCard(plat.Souillard.Position.x,plat.Souillard.Position.y,tailleHexagone div 2,x,y);

    texture := affichage.texturePlateau.textureSouillard;
    
    // Définit le carre de destination pour l'affichage de la carte
    destination_rect.x:=affichage.xGrid + x-(tailleSouillard div 2);
    destination_rect.y:=affichage.yGrid + y -(Round(tailleSouillard*1.3) div 2);
    destination_rect.w:=tailleSouillard;
    destination_rect.h:=Round(tailleSouillard*1.3);

    if SDL_RenderCopy(affichage.renderer,texture,nil,@destination_rect)<>0 then
        WriteLn('Erreur SDL: ', SDL_GetError());
    
    affichageDetailsHexagone(plat.Souillard.Position.x,plat.Souillard.Position.y,x,y,plat,affichage);
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
        SDL_Delay(66);
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
        cardToHexa(coord.x-affichage.xGrid,coord.y-affichage.yGrid,tailleHexagone div 2,q,r);

        running := False;
        coord := FCoord(q,r);
        
        writeln('Clic : ',coord.x,' ',coord.y);

        SDL_Delay(66);
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
	
	if SDL_RenderCopy(affichage.renderer,texteTexture,nil,@textRect)<>0 then
        WriteLn('Erreur SDL: ', SDL_GetError());
	
	TTF_CloseFont(police);
	TTF_Quit();
	SDL_DestroyTexture(texteTexture);
end;

procedure affichageDe(de,rotation:Integer; coord:Tcoord; var affichage: TAffichage);
var destination_rect: TSDL_RECT;
    texture: PSDL_Texture;
begin
    texture := chargerTexture(affichage, 'DiceFaces/' + IntToStr(de));
    destination_rect.x := coord.x;
    destination_rect.y := coord.y;
    destination_rect.w := 75;
    destination_rect.h := 75;

    if SDL_RenderCopyEx(affichage.renderer, texture, nil, @destination_rect, rotation, nil, SDL_FLIP_NONE) <> 0 then
        WriteLn('Erreur SDL: ', SDL_GetError());
end;

procedure affichageDes(de1,de2:Integer; coord: TCoord; var affichage: TAffichage);
begin
    affichageDe(de1,-15,coord,affichage);
    coord.x := coord.x + 75;
    affichageDe(de2,20,coord,affichage);
end;

procedure affichageScore(joueurs: TJoueurs; id: Integer; var affichage: TAffichage);
var coord: Tcoord;
begin
    coord := FCoord(25,25+id*75);
    affichageTexte(joueurs[id].Nom + ': ' + IntToStr(joueurs[id].Points) + ' points', 25, coord, affichage);
    coord.y := coord.y + 25;
    

    affichageTexte('M: '+IntToStr(joueurs[id].Ressources[Mathematiques])+'  P: '+IntToStr(joueurs[id].Ressources[Physique])+'  C: '+IntToStr(joueurs[id].Ressources[Chimie])+'  I: '+IntToStr(joueurs[id].Ressources[Informatique])+'  H: '+IntToStr(joueurs[id].Ressources[Humanites]), 25, coord, affichage);
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

procedure affichageBouton(bouton: TBouton; var affichage: TAffichage);
var epaisseurBord: Integer;
begin
    epaisseurBord := 2;

    affichageZone(bouton.coord.x,bouton.coord.y,bouton.w,bouton.h,epaisseurBord,affichage);

    affichageTexte(' '+bouton.texte, 25, bouton.coord, affichage);
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
        writeln('Pas de boutons');
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
        
        SDL_Delay(66);
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
    affichageTexte(ressource + ' : ' + IntToStr(ressources[TRessource(GetEnumValue(TypeInfo(TRessource), ressource))]), 25, coord, affichage);
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
    affichageTexte(joueurs[id].Nom, 25, coord, affichage);
end;

procedure affichageEchangeRessources(joueurs: TJoueurs; idJoueurActuel,idJoueurEchange: Integer; ressources1,ressources2: TRessources;var affichage: TAffichage; var boutons: TBoutons);
var coord: Tcoord;
    bouton: TBouton;
    ressource: TRessource;
begin
    affichageFond(affichage);
    miseAJourRenderer(affichage);

    SDL_Delay(66);

    coord := FCoord(450,70);
    affichageZone(coord.x,coord.y,1050,930,3,affichage);

    coord := FCoord(890,90);
    affichageTexte('Echange', 35, coord, affichage);

    coord := FCoord(650,160);
    affichageTexte(joueurs[idJoueurActuel].Nom, 25, coord, affichage);
    
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

{Affiche l'écran d'échange de ressources
Préconditions :
    - joueurs : les joueurs de la partie
    - idJoueurActuel : l'identifiant du joueur actuel
    - idJoueurEchange : l'identifiant du joueur avec qui échanger
    - ressources1 : les ressources à échanger du joueur actuel
    - ressources2 : les ressources à échanger du joueur avec qui échanger
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
    SDL_Delay(66);

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
            //TODO opti la vérif de ressources pour limiter aux ressources possédées en max
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

{Affiche le tour à l'écran
Préconditions :
    - plat : le plateau de jeu
    - affichage : la structure contenant le renderer
Postconditions :
    - affichage : la structure contenant le renderer}
procedure affichageTour(plat: TPlateau; joueurs: TJoueurs; var affichage: TAffichage);
var i: Integer;
  coord : Tcoord;
begin
    nettoyageAffichage(affichage);

    affichageFond(affichage);

    
    affichageGrille(plat,affichage);
    // TODO probleme afficher souillard entre les couches de affichage grille ...
    
    affichageSouillard(plat,affichage);


    
    affichageDes(plat.des1,plat.des2,FCoord(50,500),affichage);

    for i:=0 to length(plat.Connexions)-1 do
        affichageConnexion(plat.Connexions[i],affichage);
    
    for i:=0 to length(plat.Personnes)-1 do
        affichagePersonne(plat.Personnes[i],affichage);
    
    for i:=0 to length(affichage.boutonsAction)-1 do
        affichageBouton(affichage.boutonsAction[i],affichage);
    
    for i:=0 to length(joueurs)-1 do
        affichageScore(joueurs,i,affichage);

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
    affichage.yGrid := 100;

    initialisationTextures(affichage);
    initialisationBoutonsAction(affichage);
end;

end.
