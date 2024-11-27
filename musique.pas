unit musique;

interface
uses SDL2, SDL2_mixer,types,SysUtils,DateUtils;

procedure demarrerMusique(var affichage :TAffichage);
procedure verificationMusique(var affichage :TAffichage);
procedure arreterMusique(var affichage :TAffichage);
procedure jouerSon(valide : Boolean);


implementation



procedure demarrerMusique(var affichage :TAffichage);
var
    musique: PMix_Music;
    musiques: array[0..23] of PChar = (
        'Assets/Musique/N1 - Jeux.mp3',
        'Assets/Musique/N1 - Jeux (1).mp3',
        'Assets/Musique/N2 - Jeux.mp3',
        'Assets/Musique/N2 - Jeux (1).mp3',
        'Assets/Musique/N3 - Jeux.mp3',
        'Assets/Musique/N3 - Jeux (1).mp3',
        'Assets/Musique/N4 - Jeux.mp3',
        'Assets/Musique/N4 - Jeux (1).mp3',
        'Assets/Musique/N5 - Jeux.mp3',
        'Assets/Musique/N5 - Jeux (1).mp3',
        'Assets/Musique/N6 - Jeux.mp3',
        'Assets/Musique/N6 - Jeux (1).mp3',
        'Assets/Musique/N7 - Jeux.mp3',
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
    musiquesTemps: array[0..23] of Integer = (
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30,
        30


        
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

procedure arreterMusique(var affichage : TAffichage);
begin
    Mix_HaltMusic();
    affichage.musiqueActuel.debut := 0;
    affichage.musiqueActuel.temps := 0;

end;


procedure jouerSon(valide : Boolean);
var
    musique: PMix_Music;
    if(valide)then
        musiques: 'Assets/Musique/N1 - Jeux.mp3'
    else
        musiques: 'Assets/Musique/N1 - Jeux.mp3'

    

begin
    if Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0 then
    begin
        WriteLn('Erreur d''initialisation de SDL_mixer: ', Mix_GetError);
        Exit;
    end;

    musique := Mix_LoadMUS(musiques);

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

end.