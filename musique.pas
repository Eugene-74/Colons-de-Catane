unit musique;

interface
uses SDL2, SDL2_mixer,types,SysUtils,DateUtils;

procedure demarrerMusique(var affichage :TAffichage);
procedure verificationMusique(var affichage :TAffichage);

implementation



procedure demarrerMusique(var affichage :TAffichage);
var
    musique: PMix_Music;
    musiques: array[0..2] of PChar = (
        'Assets/Musique/1.mp3',
        'Assets/Musique/2.mp3',
        'Assets/Musique/3.mp3'
    );
    musiquesTemps: array[0..2] of Integer = (
        4*60,
        4*60,
        1*60+57
        
    );
    

    randomIndex: Integer;
begin
    if Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0 then
    begin
        WriteLn('Erreur d''initialisation de SDL_mixer: ', Mix_GetError);
        Exit;
    end;

    Randomize;
    randomIndex := Random(Length(musiques));
    // writeln('Musique: ', musiques[randomIndex]);
    musique := Mix_LoadMUS(musiques[randomIndex]);

    affichage.musiqueActuel.debut := DateTimeToUnix(Now);
    affichage.musiqueActuel.temps := musiquesTemps[randomIndex];
    
    if musique = nil then
    begin
        WriteLn('Erreur de chargement de la musique: ', Mix_GetError);
        Exit;
    end;

    if Mix_PlayMusic(musique, -1) = -1 then
    begin
        WriteLn('Erreur de lecture de la musique: ', Mix_GetError);
        Exit;
    end;
end;

procedure verificationMusique(var affichage :TAffichage);
begin
    if(DateTimeToUnix(Now) - affichage.musiqueActuel.debut  >= affichage.musiqueActuel.temps) then
    begin
        demarrerMusique(affichage);
    end;
end;


end.