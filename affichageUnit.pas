unit affichageUnit;


interface

uses sdl2, sdl2_image, sdl2_ttf, types, sysutils, TypInfo, traitement;

procedure initialisationSDL(var affichage: TAffichage);
procedure initialisationAffichage(var plat: TPlateau; var affichage: TAffichage);
procedure affichageGrille(plat: TPlateau; var affichage: TAffichage);
procedure testAffichagePlateau(plat: TPlateau);
procedure clicHexagone(var plat: TPlateau; var affichage: TAffichage);
procedure affichageText(text : string;taille : integer;coord : Tcoord;affichage :TAffichage);
procedure miseAJourRender(affichage :TAffichage);


implementation

const
    WINDOW_W = 1920;
    WINDOW_H = 1080;

// Permet de charger la texture de l'image
function chargerTexture(renderer : PSDL_Renderer;filename : String): PSDL_Texture;
var image : PSDL_Texture;
	chemin : AnsiString;
begin
	// Construit le chemin complet du fichier image
	chemin := 'Assets/' + filename + '.png';

	image := IMG_LoadTexture(renderer, PChar(chemin));
	
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

procedure testAffichagePlateau(plat: TPlateau);
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
end;

function ressourceAleatoire(): TRessource;
begin
    ressourceAleatoire := TRessource(Random(Ord(High(TRessource)))+1);
end;

procedure initialisationPlateau(var plat: TPlateau;var affichage: TAffichage);
var grid: TGrille;
    q,r,gridSize: Integer;
    i: TRessource;
begin
    affichage.xGrid := 500;
    affichage.yGrid := 125;

    // gridSize := 3;

    for i:=Physique to Mathematiques do
    begin
        affichage.texturePlateau.textureRessource[i] := chargerTexture(affichage.renderer, GetEnumName(TypeInfo(TRessource), Ord(i)));
    end;

    testAffichagePlateau(plat);
end;

procedure initialisationAffichage(var plat: TPlateau; var affichage: TAffichage);
begin
    initialisationSDL(affichage);
    initialisationPlateau(plat,affichage);
end;

procedure affichageHexagone(plat: TPlateau; var affichage: TAffichage; q, r: Integer);
var destination_rect: TSDL_RECT;
    texture: PSDL_Texture;
    taille : Integer;
    x,y: Integer;
begin
    taille := 150;

    texture := affichage.texturePlateau.textureRessource[plat.Grille[q,r].ressource];

    hexaToCard(q,r,taille div 2-1,x,y);
	
	// Définit le carre de destination pour l'affichage de la carte
	destination_rect.x:=affichage.xGrid+x;
	destination_rect.y:=affichage.yGrid+y;
	destination_rect.w:=taille;
	destination_rect.h:=taille;

	SDL_RenderCopy(affichage.renderer,texture,nil,@destination_rect);
end;

procedure affichageFond(var affichage: TAffichage);
begin
    SDL_SetRenderDrawColor(affichage.renderer, 255, 255, 255, 255);
    SDL_RenderClear(affichage.renderer);
end;

procedure affichageGrille(plat: TPlateau; var affichage: TAffichage);
var q,r,taille,gridSize: Integer;
begin
    affichageFond(affichage);

    taille := length(plat.Grille);
    gridSize := taille div 2;

    //and not ((q+r<=gridSize) or (q+r>=gridSize*gridSize))
    for q:=0 to taille-1 do
        for r:=0 to taille-1 do
            if (plat.Grille[q,r].ressource <> Aucune) then
                affichageHexagone(plat,affichage,q,r);

    SDL_RenderPresent(affichage.renderer);
end;

procedure nettoyageAffichage(var affichage: TAffichage);
begin
    //TODO
end;

procedure clicHexagone(var plat: TPlateau; var affichage: TAffichage);
var event: TSDL_Event;
    running: Boolean;
    x,y,q,r: Integer;
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
                    running := False;
                end;
                SDL_MOUSEBUTTONDOWN:
                begin
                    x := event.button.x-affichage.xGrid;
                    y := event.button.y-affichage.yGrid;
                    cardToHexa(x,y,150 div 2-1,q,r);
                    writeln(q-1,' ',r-1);
                    if not((q-1 < 0) or (r-1 < 0) or (q-1 >= length(plat.Grille)-1) or (r-1 >= length(plat.Grille)-1)) then
                    begin
                        writeln(plat.Grille[q-1,r-1].ressource);
                    end;
                end;
            end;
        end;
    end;
end;

procedure affichageText(text : string;taille : integer;coord : Tcoord;affichage :TAffichage);
begin
  writeln(text);
end;

procedure miseAJourRender(affichage :TAffichage);
begin
  writeln('miseAJourRender activer')
end;

end.