function [ h ] = Policz_kolejne_h(Fh, Fc, Fd, alfa, h0, C, Tp)
%Funkcja licz�ca wysoko�� poziomu zbiornika w kolejnej iteracji

h1 = h0+0.5*Tp*Policz_pochodna_h(Fh,Fc,Fd,alfa,h0,C);   %wyznacza warto�� wysoko�ci, dla kt�rej policzy pochodn�

pochodna = Policz_pochodna_h(Fh,Fc,Fd,alfa,h1,C);       %oblicza pochodn� dla zmienionej wysoko�ci

h = h0 + pochodna*Tp;                                   %wz�r Eulera na kolejn� warto�� wysoko�ci

end
