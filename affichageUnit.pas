unit affichageUnit;

interface

uses sdl2, sdl2_image, sdl2_ttf, types,sysutils,traitement;

procedure initialisationSDL(var affichage: TAffichage);
procedure initialisationAffichagePlateau(var plat: TPlateau; var affichage: TAffichage);
procedure affichageGrille(plat: TPlateau; var affichage: TAffichage);
procedure testAffichagePlateau(plat: TPlateau);

implementation

const
    WINDOW_W = 1920;
    WINDOW_H = 1080;

procedure initialisationSDL(var affichage: TAffichage);
begin
    SDL_Init(SDL_INIT_VIDEO);

    affichage.fenetre := SDL_CreateWindow('Catan', SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, WINDOW_W, WINDOW_H, SDL_WINDOW_SHOWN);
    affichage.renderer := SDL_CreateRenderer(affichage.fenetre, -1, SDL_RENDERER_ACCELERATED);
end;

procedure testAffichagePlateau(plat: TPlateau);
var q,r,taille: Integer;
begin
    taille := length(plat.Grille);
    for q:=0 to taille-1 do
    begin
        for r:=0 to taille-1 do
        begin
            write(plat.Grille[q,r].TypeRessource);
            write(' ');
        end;
        writeln();
    end;
end;

procedure initialisationPlateau(var plat: TPlateau;var affichage: TAffichage);
var grid: TGrille;
    q,r,gridSize: Integer;
begin
    affichage.xGrid := 200;
    affichage.yGrid := 200;

    gridSize := 3;

    setLength(grid, gridSize*2+1,gridSize*2+1);

    for q := 0 to gridSize*2 do
        for r := 0 to gridSize*2 do
            if abs(q+r)<=gridSize*2*2 then
            begin
                if ((q+r<gridSize) or (q+r>gridSize*gridSize)) then
                begin
                    grid[q,r].TypeRessource := Aucune;
                    grid[q,r].Numero := 0;
                end
                else
                begin
                    grid[q,r].TypeRessource := Humanites;
                    grid[q,r].Numero := 1;
                end;
            end;

    plat.Grille := grid;

    testAffichagePlateau(plat);
end;

procedure initialisationAffichagePlateau(var plat: TPlateau; var affichage: TAffichage);
begin
    initialisationSDL(affichage);
    initialisationPlateau(plat,affichage);
end;

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

procedure affichageHexagone(plat: TPlateau; var affichage: TAffichage; q, r: Integer);
var destination_rect: TSDL_RECT;
    texture: PSDL_Texture;
    taille : Integer;
    x,y: Integer;
begin
    taille := 100;
    texture := chargerTexture(affichage.renderer, 'hexagone');

    hexaToCard(q,r,x,y);
	
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
var q,r,taille: Integer;
begin
    affichageFond(affichage);

    taille := length(plat.Grille);
    for q:=0 to taille-1 do
    begin
        for r:=0 to taille-1 do
        begin
            if plat.Grille[q,r].TypeRessource <> Aucune then
                affichageHexagone(plat,affichage,q,r);
        end;
    end;

    SDL_RenderPresent(affichage.renderer);
    SDL_Delay(5000);
end;

end.