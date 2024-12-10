unit musique;

interface
uses SDL2, SDL2_mixer,types,SysUtils,DateUtils,TypInfo;

procedure demarrerMusique(var affichage :TAffichage);
procedure verificationMusique(var affichage :TAffichage);
procedure arreterMusique(var affichage :TAffichage);
procedure jouerSonValide(affichage :TAffichage;valide : Boolean);
procedure jouerSonClic(affichage :TAffichage);
procedure jouerSonFinDeTour(affichage :TAffichage);

procedure initisationMusique(var affichage : TAffichage);



implementation

procedure initisationMusique(var affichage : TAffichage);
var  son: PMix_Chunk;
    i : TSon;
begin

if Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0 then
    begin
    WriteLn('Erreur d''initialisation de SDL_mixer: ', Mix_GetError);
    Exit;
    end;

for i:= sonClicHexagone to sonInvalide do
    begin
        
    son := Mix_LoadWAV(PChar('Assets/Sons/' + GetEnumName(TypeInfo(TSon), Ord(i)) + '.mp3'));

    if son = nil then
        begin
        WriteLn('Erreur de chargement du son: ', Mix_GetError);
        Exit;
        end;
    affichage.sons[i] := son;

    end;

end;


procedure demarrerMusique(var affichage :TAffichage);
var
    musique: PMix_Music;
    musiques: array[0..15] of PChar = (
        'Assets/Musique/N1 - Jeux.mp3',
        'Assets/Musique/N1 - Jeux (1).mp3',
        'Assets/Musique/N3 - Jeux.mp3',
        'Assets/Musique/N3 - Jeux (1).mp3',
        'Assets/Musique/N6 - Jeux.mp3',
        'Assets/Musique/N7 - Jeux (1).mp3',
        'Assets/Musique/N8 - Jeux.mp3',
        'Assets/Musique/N8 - Jeux (1).mp3',
        'Assets/Musique/N9 - Jeux.mp3',
        'Assets/Musique/N9 - Jeux (1).mp3',
        'Assets/Musique/N10 - Jeux.mp3',
        'Assets/Musique/N10 - Jeux (1).mp3',
        'Assets/Musique/N11 - Jeux (1).mp3',
        'Assets/Musique/N11 - Jeux (2).mp3',
        'Assets/Musique/N12 - Jeux (1).mp3',
        'Assets/Musique/N12 - Jeux (2).mp3'


    );
    musiquesTemps: array[0..15] of Integer = (
        4*60,
        4*60,
        4*60,
        4*60,
        4*60,
        4*60,
        2*60+47,
        4*60,
        3*60+47,
        2*60+10,
        4*60,
        4*60,
        3*60+56,
        9,
        4*60,
        2*60+57
    );
    

    randomIndex: Integer;
begin
    if Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0 then
    begin
        WriteLn('Erreur d''initialisation de SDL_mixer: ', Mix_GetError);
        Exit;
    end;

    randomIndex := Random(Length(musiques));
    musique := Mix_LoadMUS(musiques[randomIndex]);

    if affichage.musiqueActuelle.musique <> nil then
    begin
      Mix_FreeMusic(affichage.musiqueActuelle.musique);
      affichage.musiqueActuelle.musique := nil;
    end;
    
    affichage.musiqueActuelle.musique := musique;
    affichage.musiqueActuelle.active := true;
    affichage.musiqueActuelle.debut := DateTimeToUnix(Now);
    affichage.musiqueActuelle.temps := musiquesTemps[randomIndex];
    
    if musique = nil then
    begin
        WriteLn('Erreur de chargement de la musique: ', Mix_GetError);
        Exit;
    end;

    if Mix_PlayMusic(musique, 0) = -1 then
    begin
        WriteLn('Erreur de lecture de la musique: ', Mix_GetError);
        Exit;
    end;
end;

procedure verificationMusique(var affichage :TAffichage);
begin
    if(affichage.musiqueActuelle.active) then
        if(DateTimeToUnix(Now) - affichage.musiqueActuelle.debut  >= affichage.musiqueActuelle.temps) then
        begin
            demarrerMusique(affichage);
        end;
end;

procedure arreterMusique(var affichage : TAffichage);
begin
    if(affichage.musiqueActuelle.active) then
    begin
        
    Mix_HaltMusic();
    affichage.musiqueActuelle.active := False;
    affichage.musiqueActuelle.debut := 0;
    affichage.musiqueActuelle.temps := 0;
    end;

end;



procedure demarrerSon(affichage : TAffichage;son : TSon);
var pSon: PMix_Chunk;
begin
    pSon := affichage.sons[son];
    // Jouer le son sur le premier canal disponible (-1) une seule fois (0)
    Mix_VolumeChunk(pSon, MIX_MAX_VOLUME div 10); // Réduire le volume à 10%
    if Mix_PlayChannel(-1, pSon, 0) = -1 then
    begin
        WriteLn('Erreur de lecture du son: ', Mix_GetError);
    end;
end;


procedure jouerSonValide(affichage :TAffichage;valide: Boolean);
var
    son: TSon;
begin

    if valide then
        son := sonValide
    else
        son := sonInvalide;
    demarrerSon(affichage,son);
end;


procedure jouerSonClic(affichage :TAffichage);
begin
    demarrerSon(affichage,sonClicHexagone);
end;



procedure jouerSonFinDeTour(affichage :TAffichage);
begin
    demarrerSon(affichage,sonFinDeTour);
end;



end.