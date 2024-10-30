unit traitement;

interface

procedure hexaToCard(q,r,taille:Integer; var x,y:Integer);
procedure cardToHexa(x,y,taille:Integer; var q,r:Integer);
procedure round_hexa(q_f,r_f:Real; var q,r:Integer);

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

end.