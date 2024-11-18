unit traitement;

interface

uses Types,SDL2;

procedure hexaToCard(q,r,taille:Integer; var x,y:Integer);
procedure cardToHexa(x,y,taille:Integer; var q,r:Integer);
procedure round_hexa(q_f,r_f:Real; var q,r:Integer);
function enContact(hexagones: TCoords): Boolean;
function sontAdjacents(coord1, coord2: TCoord): Boolean;
function splitValeur(texte: String): TStringTab;
function FCoord(x, y: Integer): TCoord;
function FCouleur(r, g, b, a: Integer): TSDL_Color;

implementation

procedure round_hexa(q_f,r_f:Real; var q,r:Integer);
var s:Integer;
    s_f,dq,dr,ds:Real;
begin
    s_f:= -q_f-r_f;
    q:= Round(q_f);
    r:= Round(r_f);
    s:= Round(s_f);

    dq := Abs(q-q_f);
    dr := Abs(r-r_f);
    ds := Abs(s-s_f);

    if (dq > dr) and (dq > ds) then
        q := -r-s
    else if (dr > ds) then
        r := -q-s;
end;

procedure hexaToCard(q,r,taille:Integer; var x,y:Integer);
begin
    x:= Round(taille*(sqrt(3)*q+sqrt(3)/2*r));
    y:= Round(taille*((3/2)*r));
end;

procedure cardToHexa(x,y,taille:Integer; var q,r:Integer);
var q_f,r_f:Real;
begin
    q_f := (x*sqrt(3)/3-y/3)/taille;
    r_f := (y*2/3)/taille;
    round_hexa(q_f,r_f,q,r);
end;

function sontAdjacents(coord1, coord2: TCoord): Boolean;
var dq, dr: Integer;
begin
    dq := coord1.x - coord2.x;
    dr := coord1.y - coord2.y;

    sontAdjacents := ((Abs(dq) = 1) and (dr = 0)) or ((Abs(dr) = 1) and (dq = 0)) or ((dq = -1) and (dr = 1)) or ((dq = 1) and (dr = -1));
end;

function enContact(hexagones: TCoords): Boolean;
var i,j: Integer;
begin
    enContact := True;
    for i := 0 to length(hexagones) - 1 do
    begin
        for j := i + 1 to length(hexagones) - 1 do
        begin
            if not sontAdjacents(hexagones[i], hexagones[j]) then
            begin
                enContact := False;
            end;
        end;
    end;
end;

function splitValeur(texte: String): TStringTab;
var i : Integer;
    tab: TStringTab;
begin
    i := 1;
    setLength(tab, 1);
    tab[length(tab)] := '';
    while i <= Length(texte) do
    begin
        if texte[i] = '_' then
        begin
            setLength(tab, length(tab)+1);
            tab[length(tab)] := '';
        end
        else
        begin
            tab[length(tab)-1] := tab[length(tab)-1] + texte[i];
        end;
        i := i + 1;
    end;
    splitValeur := tab;
end;

function FCoord(x, y: Integer): TCoord;
begin
    FCoord.x := x;
    FCoord.y := y;
end;

function FCouleur(r, g, b, a: Integer): TSDL_Color;
begin
    FCouleur.r := r;
    FCouleur.g := g;
    FCouleur.b := b;
    FCouleur.a := a;
end;

end.