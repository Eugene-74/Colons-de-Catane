unit traitement;

interface

procedure hexaToCard(q,r,taille:Integer; var x,y:Integer);
procedure cardToHexa(x,y,taille:Integer; var q,r:Integer);

implementation

//TODO Refaire l'arrondi
procedure hexaToCard(q,r,taille:Integer; var x,y:Integer);
begin
    x:= Round(taille*(sqrt(3)*q+sqrt(3)/2*r));
    y:= Round(taille*(3/2*r));
end;

procedure cardToHexa(x,y,taille:Integer; var q,r:Integer);
begin
    q:= Round((x*sqrt(3)/3-y/3)/taille);
    r:= Round((y*2/3)/taille);
end;

end.