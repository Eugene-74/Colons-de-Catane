unit traitement;

interface

procedure hexaToCard(q,r:Integer; var x,y:Integer);

implementation

Const TAILLE = 50;

procedure hexaToCard(q,r:Integer; var x,y:Integer);
begin
    x:= Round(TAILLE*(sqrt(3)*q+sqrt(3)/2*r));
    y:= Round(TAILLE*(3/2*r));
end;

procedure cardToHexa(x,y:Integer; var q,r:Integer);
begin
    q:= Round((x*sqrt(3)/3-y/3)/(TAILLE*sqrt(3)/2));
    r:= Round((y*2/3)/TAILLE);
end;

end.