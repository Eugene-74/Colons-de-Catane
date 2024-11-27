unit musique;

interface
uses SDL2, SDL2_mixer,types,SysUtils,DateUtils;

procedure demarrerMusique(var affichage :TAffichage);
procedure verificationMusique(var affichage :TAffichage);
procedure arreterMusique(var affichage :TAffichage);
procedure jouerSonValide(valide : Boolean);
procedure jouerSonClic();
procedure jouerSonClicAction();




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
        4*60,
        4*60,
        1*60+23,
        1*60+57,
        4*60,
        4*60,
        1*60+50,
        2*60+3,
        1*60+49,
        2*60+37,
        4*60,
        4*60,
        2*60+7,
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

    Randomize;
    randomIndex := Random(Length(musiques));
    // writeln('Musique: ', musiques[randomIndex]);
    musique := Mix_LoadMUS(musiques[randomIndex]);

    affichage.musiqueActuel.active := true;
    affichage.musiqueActuel.debut := DateTimeToUnix(Now);
    affichage.musiqueActuel.temps := musiquesTemps[randomIndex];
    
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
    if(affichage.musiqueActuel.active) then
        if(DateTimeToUnix(Now) - affichage.musiqueActuel.debut  >= affichage.musiqueActuel.temps) then
        begin
            demarrerMusique(affichage);
        end;
end;

procedure arreterMusique(var affichage : TAffichage);
begin
    Mix_HaltMusic();
    affichage.musiqueActuel.active := False;
    affichage.musiqueActuel.debut := 0;
    affichage.musiqueActuel.temps := 0;

end;



procedure demarrerSon(cheminSon : Pchar);
var
  son: PMix_Chunk;
begin

  if Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0 then
  begin
    WriteLn('Erreur d''initialisation de SDL_mixer: ', Mix_GetError);
    Exit;
  end;

  son := Mix_LoadWAV(cheminSon);

  if son = nil then
  begin
    WriteLn('Erreur de chargement du son: ', Mix_GetError);
    Exit;
  end;

  // Jouer le son sur le premier canal disponible (-1) une seule fois (0)
  if Mix_PlayChannel(-1, son, 0) = -1 then
  begin
    WriteLn('Erreur de lecture du son: ', Mix_GetError);
  end;
end;


procedure jouerSonValide(valide: Boolean);
var
    cheminSon: PChar;
begin

    if valide then
        cheminSon := 'Assets/Sons/valide.mp3'
    else
        cheminSon := 'Assets/Sons/refus.mp3';
    demarrerSon(cheminSon);
end;


procedure jouerSonClic();
begin
    demarrerSon('Assets/Sons/clic.mp3');
end;

procedure jouerSonClicAction();
begin
    demarrerSon('Assets/Sons/clicAction.mp3');
end;



end.