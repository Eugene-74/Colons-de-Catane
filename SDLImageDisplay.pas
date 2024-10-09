program SDLImageDisplay;

uses
  SDL2, SDL2_image;

var
  Window: PSDL_Window;
  Renderer: PSDL_Renderer;
  Texture: PSDL_Texture;
  ImageSurface: PSDL_Surface;
  Event: TSDL_Event;
  Running: Boolean;
  ImageFile: string;

begin
  // Initialisation de SDL et de la sous-bibliothèque SDL Image
  if SDL_Init(SDL_INIT_VIDEO) <> 0 then
  begin
    writeln('Erreur d''initialisation de SDL : ', SDL_GetError);
    exit;
  end;
  
  if IMG_Init(IMG_INIT_PNG) = 0 then
  begin
    writeln('Erreur d''initialisation de SDL Image : ', IMG_GetError);
    SDL_Quit;
    exit;
  end;

  // Création de la fenêtre SDL
  Window := SDL_CreateWindow('Affichage d''une Image en SDL2',
                             SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
                             800, 600, SDL_WINDOW_SHOWN);
  
  if Window = nil then
  begin
    writeln('Erreur de création de la fenêtre : ', SDL_GetError);
    IMG_Quit;
    SDL_Quit;
    exit;
  end;

  // Création du renderer
  Renderer := SDL_CreateRenderer(Window, -1, SDL_RENDERER_ACCELERATED);
  if Renderer = nil then
  begin
    writeln('Erreur de création du renderer : ', SDL_GetError);
    SDL_DestroyWindow(Window);
    IMG_Quit;
    SDL_Quit;
    exit;
  end;

  // Charger l'image
  ImageFile := 'image.png'; // Assurez-vous que 'image.png' existe dans le dossier du projet
  ImageSurface := IMG_Load(PChar(ImageFile));
  if ImageSurface = nil then
  begin
    writeln('Erreur de chargement de l''image : ', IMG_GetError);
    SDL_DestroyRenderer(Renderer);
    SDL_DestroyWindow(Window);
    IMG_Quit;
    SDL_Quit;
    exit;
  end;

  // Créer une texture à partir de l'image
  Texture := SDL_CreateTextureFromSurface(Renderer, ImageSurface);
  SDL_FreeSurface(ImageSurface);

  if Texture = nil then
  begin
    writeln('Erreur de création de la texture : ', SDL_GetError);
    SDL_DestroyRenderer(Renderer);
    SDL_DestroyWindow(Window);
    IMG_Quit;
    SDL_Quit;
    exit;
  end;

  // Boucle principale
  Running := True;
  while Running do
  begin
    // Gérer les événements
    while SDL_PollEvent(@Event) <> 0 do
    begin
      if Event.type_ = SDL_QUITEV then
        Running := False;
    end;

    // Effacer l'écran
    SDL_RenderClear(Renderer);
    
    // Afficher l'image
    SDL_RenderCopy(Renderer, Texture, nil, nil);
    
    // Mettre à jour l'écran
    SDL_RenderPresent(Renderer);
  end;

  // Libérer les ressources
  SDL_DestroyTexture(Texture);
  SDL_DestroyRenderer(Renderer);
  SDL_DestroyWindow(Window);
  IMG_Quit;
  SDL_Quit;
end.
