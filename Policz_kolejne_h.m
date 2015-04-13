function [ h ] = Policz_kolejne_h(Fh, Fc, Fd, alfa, h0, C, Tp)
%Funkcja licz¹ca wysokoœæ poziomu zbiornika w kolejnej iteracji

h1 = h0+0.5*Tp*Policz_pochodna_h(Fh,Fc,Fd,alfa,h0,C);   %wyznacza wartoœæ wysokoœci, dla której policzy pochodn¹

pochodna = Policz_pochodna_h(Fh,Fc,Fd,alfa,h1,C);       %oblicza pochodn¹ dla zmienionej wysokoœci

h = h0 + pochodna*Tp;                                   %wzór Eulera na kolejn¹ wartoœæ wysokoœci

end
