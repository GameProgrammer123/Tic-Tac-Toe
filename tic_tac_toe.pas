program Tic_Tac_Toe;
uses Graph,WinCrt,Silnik;
var
   sterownik : integer;
   tryb : integer;
   kolor_kolka : byte;
   kolor_krzyzyka: byte;
   licz: integer;
   wspXtekst,wspYtekst: integer;
   liczba_graf: string[56];
   nastepna: char;
procedure Czolowka_Gry;
var
   wi: byte;
   str_nmax: string[1];
begin
     SetColor(8);
     SetTextStyle(SansSerifFont,HorizDir,5);
     OutTextXY((getmaxx div 2) - (TextWidth('Game - Tic-Tac-Toe') div 2),130,'Game - Tic-Tac-Toe');

     SetColor(15);
     SetTextStyle(SansSerifFont,HorizDir,3);
     wspXtekst := (getmaxx div 2) - (TextWidth('Press 1 to select the circle character') div 2);
     OutTextXY(wspXtekst,210,'Press 1 to select the circle character');
     OutTextXY(wspXtekst,260,'Press 2 to select the cross character');

     repeat
           wi := ord(readkey);
           case wi of
                49: O := '0';
                50: X := 'X'
           end
     until Chr(wi) in ['1'..'2'];

     if Chr(wi) = '1' then begin X := 'X'; O := '0' end
     else begin X := '0'; O := 'X' end;

     if O = '0' then
       begin
            OutTextXY(wspXtekst,310,'You have chosen a circle');
            OutTextXY(wspXtekst,360,'The computer sing is: a cross');
       end
     else
         begin
              OutTextXY(wspXtekst,310,'You have chosen a cross');
              OutTextXY(wspXtekst,360,'The computer sing is: a circle');
         end;

     OutTextXY(wspXtekst,410,'Set the board size !!!');
     OutTextXY(wspXtekst,460,'Press 1 size 3x3');
     OutTextXY(wspXtekst,510,'Press 2 size 4x4');
     OutTextXY(wspXtekst,560,'Press 3 size 5x5');
     repeat
           wi := ord(readkey);
           case wi of
                49: nmax := 3;
                50: nmax := 4;
                51: nmax := 5
           end
     until Chr(wi) in ['1'..'3'];
     str(nmax,str_nmax);
     OutTextXY(wspXtekst,610,'Size board is: '+str_nmax+'x'+str_nmax)
end;
procedure Graficzna_Ilustracja(wsp_x,wsp_y: integer; punkt_x1,punkt_y1: integer; wymiar: byte);
var
   wi,wj: byte;
   punkt_x,punkt_y: integer;
   punkt_x2: integer;
   punkt_y2: integer;
begin
     punkt_x := punkt_x1 + (wsp_x div 2);
     punkt_y := punkt_y1 + (wsp_y div 2);
     punkt_x2 := punkt_x1 + wsp_x;
     punkt_y2 := punkt_y1 + wsp_y;

     for wi := 1 to wymiar do
        begin
             for wj := 1 to wymiar do
                begin
                     if gra[wi,wj] = '0' then
                       begin
                            setcolor(1);
                            circle(punkt_x,punkt_y,(wsp_y div 2)-2)
                       end;
                     if gra[wi,wj] = 'X' then
                       begin
                            setcolor(2);
                            line(punkt_x1,punkt_y1,punkt_x2,punkt_y2);
                            line(punkt_x2,punkt_y1,punkt_x1,punkt_y2)
                       end;
                     if Wyg(gra,X) or Wyg(gra,O) then
                       begin
                            setcolor(4);
                            if (nr_wiersza = wi) and (nr_kolumny = 0) then
                              line(Round(getmaxx/7.65),punkt_y,getmaxx-Round(getmaxx/7.65),punkt_y);
                            if (nr_kolumny = wj) and (nr_wiersza = 0) then
                              line(punkt_x,Round(getmaxy/8.05),punkt_x,getmaxy-Round(getmaxy/8.05))
                       end;
                     punkt_x := punkt_x + wsp_x;
                     punkt_x1 := punkt_x1 + wsp_x;
                     punkt_x2 := punkt_x2 + wsp_x
                end;

             punkt_x := Round(getmaxx/7.65) + (wsp_x div 2);
             punkt_x1 := Round(getmaxx/7.65);
             punkt_x2 := punkt_x1 + wsp_x;

             if wi < wymiar then
               begin
                    punkt_y := punkt_y + wsp_y;
                    punkt_y1 := punkt_y1 + wsp_y;
                    punkt_y2 := punkt_y2 + wsp_y
               end;

             if Wyg(gra,X) or Wyg(gra,O) then
               begin
                    setcolor(4);
                    if nr_wiersza - nr_kolumny = 0 then
                      line(Round(getmaxx/7.65),Round(getmaxy/8.05),getmaxx-(Round(getmaxx/7.65)-1),getmaxy-(Round(getmaxy/8.05)+1))
                    else
                        if (nr_wiersza <> 0) and (nr_kolumny <> 0) then
                          line(getmaxx-(Round(getmaxx/7.65)-1),Round(getmaxy/8.05)-1,Round(getmaxx/7.65)-1,getmaxy-(Round(getmaxy/8.05)+1))
               end
        end
end;
procedure Rozgrywka(zaczyna: byte; dlug_x,dlug_y,marg_x,marg_y: integer; size: byte);
var
   rows,cols: integer;
   start: byte;
begin
     if zaczyna = 1 then start := 2 else start := 1;

     repeat
          for rows := 1 to nmax*nmax do
             tpol[rows] := 0;

          tpoldlugosc := 0;

          if (zaczyna = 1) or (zajete_pola > 0) then
            begin
                 repeat
                       i := ord(readkey);
                       if i in [49..57] then i := i - 48
                       else
                           i := i - 55
		 until (i in [1..nmax*nmax]) and Wspolrzedne(i,i,j);
                 gra[i,j] := O;
                 zajete_pola := zajete_pola + 1;
                 Graficzna_Ilustracja(dlug_x,dlug_y,marg_x,marg_y,nmax)
            end;

          if zajete_pola < nmax*nmax then
            begin
                 if zajete_pola = 0 then
                   begin
                        repeat
                              rows := random(nmax) + 1;
                              cols := random(nmax) + 1
                        until (not (rows in[2..nmax-1])) and (not (cols in[2..nmax-1]))
                        or (rows = (nmax div 2) + 1) and (cols = (nmax div 2) + 1);
                        gra[rows,cols] := X;
                   end
                 else
                     if (start < nmax) and (nmax > 3) then
                       begin
                            repeat
                                  rows := random(nmax) + 1;
                                  cols := random(nmax) + 1
                            until gra[rows,cols] = ' ';
                            gra[rows,cols] := X
                       end
                     else
                         Wspolrzedne(RuchKomputera(gra,zajete_pola),i,j);

                 if tpoldlugosc > 0 then
                   begin
                        randomize;
                        Wspolrzedne(tpol[random(tpoldlugosc)+1],i,j);
                        gra[i,j] := X
                   end;

                 zajete_pola := zajete_pola + 1;
                 Graficzna_Ilustracja(dlug_x,dlug_y,marg_x,marg_y,nmax)
	    end;

          setcolor(12);
          if Wyg(gra,O) = true then
            OutTextXY(Round(getmaxx/6.731),getmaxy - Round(getmaxy/10.744),'Win player !!!')
          else
              if Wyg(gra,X) = true then
                OutTextXY(Round(getmaxx/6.731),getmaxy - Round(getmaxy/10.744),'Win computer !!!')
              else
                  if zajete_pola = nmax*nmax then
                    OutTextXY(Round(getmaxx/6.731),getmaxy - Round(getmaxy/10.744),'Draw !!!');
          start := start + 1
     until (zajete_pola = nmax*nmax) or (Wyg(gra,O) = true) or (Wyg(gra,X) = true)
end;
procedure Runda;
var nr_pola: byte;
margines_X,margines_Y: integer;
wymiar_X,wymiar_Y: integer;
li_po_kr: byte;
li_pi_kr: byte;
begin
     repeat
            ClearDevice;

            Czolowka_Gry;

            for i := 1 to nmax do
               for j := 1 to nmax do
                  gra[i,j] := ' ';

            zajete_pola := 0; { Liczba zajetych p¢l na planszy. }

            repeat
                  OutTextXY(wspXtekst,660,'1 - First start player');
                  OutTextXY(wspXtekst,710,'2 - First start computer');
                  i := ord(readkey);
            until Chr(i) in ['1'..'2'];
            i := i - 48;

            ClearDevice;

            margines_X := Round(getmaxx/7.65);
            margines_Y := Round(getmaxy/8.05);
            wymiar_x := getmaxx - (margines_x * 2);
            wymiar_y := getmaxy - (margines_y * 2);

            for li_po_kr := 1 to nmax - 1 do
               Line(margines_X+((wymiar_X * li_po_kr) div nmax),margines_Y,margines_X+((wymiar_X * li_po_kr) div nmax),getmaxy - margines_Y);

            SetTextStyle(DefaultFont,HorizDir,8);

            wspXtekst := (margines_X+(wymiar_X div nmax) div 2) - Round(getmaxx/63.95);
            wspYtekst := (margines_Y+(wymiar_Y div nmax) div 2) - Round(getmaxy/48.35);

            for nr_pola := 1 to nmax*nmax do
               begin
                    if nr_pola < 10 then
                      liczba_graf := chr(nr_pola+48)
                    else
                        liczba_graf := chr(nr_pola+55);

                    OutTextXY(wspXtekst,wspYtekst,liczba_graf);
                    wspXtekst := wspXtekst + wymiar_X div nmax;

                    if nr_pola mod nmax = 0 then
                      begin
                           wspYtekst := wspYtekst + wymiar_Y div nmax;
                           wspXtekst := (margines_X+(wymiar_X div nmax) div 2) - Round(getmaxx/63.95)
                      end
                 end;

            for li_pi_kr := 1 to nmax - 1 do
               Line(margines_X,((wymiar_Y * li_pi_kr) div nmax)+margines_y,getmaxx - margines_X,((wymiar_Y * li_pi_kr) div nmax)+margines_y);

            SetColor(15);
            SetTextStyle(SansSerifFont,HorizDir,5);
            if getmaxx div 2 - TextWidth('Press the keys form 1 to '+liczba_graf) div 2 > 0 then
              OutTextXY(getmaxx div 2 - TextWidth('Press the keys form 1 to '+liczba_graf) div 2,Round(getmaxy/19.34),'Press the keys form 1 to '+liczba_graf)
            else
                OutTextXY(0,Round(getmaxy/19.34),'Press the keys form 1 to '+liczba_graf);

            randomize;
	    Rozgrywka(i,wymiar_X div nmax,wymiar_Y div nmax,margines_X,margines_Y,nmax);

            SetTextStyle(DefaultFont,HorizDir,2); SetColor(15);
            OutTextXY(Round(getmaxx/5.116),getmaxy-Round(getmaxy/24.175),'Do you want to play again ? Press Y otherwise any key');
            nastepna := readkey
     until not (nastepna = 'Y')
end;
begin
     sterownik := detect;
     InitGraph(sterownik,tryb,'');
     Runda;
     CloseGraph
end.