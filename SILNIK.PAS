unit Silnik;
interface
uses Crt;
type
     tab = array[1..5,1..5] of char;
     tab_pol = array[1..25] of byte;
var
   X,O: char;
   gra: tab;
   zajete_pola,i,j,tpoldlugosc,nmax: byte;
   nr_wiersza,nr_kolumny: byte;
   tpol: tab_pol;
function Wyg(wsk_linii: tab; znak_wyg: char): boolean;
function MiniMax(tablica_gry: tab; znak_gracza: char; ilosc_zajetych_pol: byte; alfa, beta: integer;
glebokosc: longint; var zatrzymanie: boolean): integer;
function Nr_Wezla(w,k: byte): byte;
function RuchKomputera(tab_gry: tab; liczba_pol: byte): byte;
function Wspolrzedne(nr_pola: byte; var wsp_y,wsp_x: byte): boolean;
implementation
function Wyg(wsk_linii: tab; znak_wyg: char): boolean;
var
  r,c,z: byte;
begin
     wyg := false; nr_wiersza := 0; nr_kolumny := 0;

     for r := 1 to nmax do
        begin z := 0;
             for c := 1 to nmax do
                if wsk_linii[r,c] = znak_wyg then
                  z := z + 1;
             if z = nmax then begin wyg := true; nr_wiersza := r; { wiersz } break end;
        end;

     for c := 1 to nmax do
        begin z := 0;
             for r := 1 to nmax do
                if wsk_linii[r,c] = znak_wyg then
                  z := z + 1;
             if z = nmax then begin wyg := true; nr_kolumny := c; { kolumna } break end;
        end;

     z := 0;
     for r := 1 to nmax do
        if wsk_linii[r,r] = znak_wyg then z := z + 1;

     if z = nmax then begin wyg := true; nr_wiersza := r; nr_kolumny := r { przekatna nr. 1 } end;

     z := 0;
     for r := 1 to nmax do
        if wsk_linii[r,(nmax+1)-r] = znak_wyg then z := z + 1;

     if z = nmax then begin wyg := true; nr_wiersza := r; nr_kolumny := (nmax+1) - r { przekatna nr. 2 } end
end;
function MiniMax(tablica_gry: tab; znak_gracza: char; ilosc_zajetych_pol: byte; alfa, beta: integer;
glebokosc: longint; var zatrzymanie: boolean): integer;
var
   m,mmx: integer;
   fi,fj: byte;
begin
     if Wyg(tablica_gry,X) = true then MiniMax := 1
      else
          if Wyg(tablica_gry,O) = true then MiniMax := -1
          else
              if (ilosc_zajetych_pol = nmax*nmax) or (glebokosc = 5) then
                MiniMax := 0
              else
                  if zatrzymanie = false then
                  begin
                       if znak_gracza = X then znak_gracza := O else znak_gracza := X;
                       if znak_gracza = X then mmx := -10 else mmx := 10;
                       for fi := 1 to nmax do
                          begin
                          for fj := 1 to nmax do
                             if tablica_gry[fi,fj] = ' ' then
                               begin
                                    tablica_gry[fi,fj] := znak_gracza;
                                    if glebokosc = 5 then zatrzymanie := true;
                                    m := MiniMax(tablica_gry,znak_gracza,ilosc_zajetych_pol+1,alfa,beta,glebokosc+1,zatrzymanie);
                                    tablica_gry[fi,fj] := ' ';
                                    if znak_gracza = X then
                                      begin
                                           if mmx < m then
                                             begin
                                                  mmx := m;
                                                  alfa := m
                                             end
                                      end
                                    else
                                        if m < mmx then
                                          begin
                                               mmx := m;
                                               beta := m
                                          end;

                             if glebokosc = 0 then zatrzymanie := false;

                             if beta <= alfa then
                               break;
                       if (zatrzymanie = true) and (glebokosc > 0) then break
                               end;
                       if beta <= alfa then
                         break;
                         if (zatrzymanie = true) and (glebokosc > 0) then break
                      end;
                       MiniMax := mmx
                  end
end;
function Nr_Wezla(w,k: byte): byte;
begin
     if k mod nmax = 0 then
       Nr_Wezla := w * k
     else
         Nr_Wezla := (w - 1) * nmax + k
end;
function RuchKomputera(tab_gry: tab; liczba_pol: byte): byte;
var
   fi,fj: byte;
   m,mmx: integer;
   przerwanie: boolean;
begin
     mmx := -10; tpoldlugosc := 0; przerwanie := false;

     for fi := 1 to nmax do
        begin
             for fj := 1 to nmax do
                if tab_gry[fi,fj] = ' ' then
                  begin
                       tab_gry[fi,fj] := X;
                       if Wyg(tab_gry,X) = false then
                         begin
                              m := MiniMax(tab_gry,X,liczba_pol+1,-10,10,0,przerwanie);
                              tab_gry[fi,fj] := ' ';
                              if mmx <= m then
                                begin
                                     if ((mmx < 0) and (m = 0)) or ((mmx <= 0) and (m = 1)) then
                                       tpoldlugosc := 0;
                                     tpoldlugosc := tpoldlugosc + 1;
                                     tpol[tpoldlugosc] := Nr_Wezla(fi,fj);
                                     mmx := m;
                                     RuchKomputera := Nr_Wezla(fi,fj)
                                end
                         end
                       else
                           begin
                                przerwanie := true;
                                tab_gry[fi,fj] := ' ';
                                tpoldlugosc := 1;
                                tpol[tpoldlugosc] := Nr_Wezla(fi,fj);
                                RuchKomputera := Nr_Wezla(fi,fj);
                                break
                           end
                  end;
             if przerwanie = true then break
        end
end;
function Wspolrzedne(nr_pola: byte; var wsp_y,wsp_x: byte): boolean;
begin
     Wspolrzedne := false;
	 if nr_pola mod nmax = 0 then
       begin
            wsp_y := nr_pola div nmax;
            wsp_x := nmax
       end
     else
         begin
              wsp_y := (nr_pola div nmax) + 1;
              wsp_x := nr_pola mod nmax
         end;

	 if gra[wsp_y,wsp_x] = ' ' then Wspolrzedne := true
end;
end.