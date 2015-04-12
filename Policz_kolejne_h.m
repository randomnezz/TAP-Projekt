function [ h ] = Policz_kolejne_h(Fh, Fc, Fd, alfa, h0, C, Tp)
%Funkcja licząca wysokość poziomu zbiornika w kolejnej iteracji

h1 = h0+0.5*Tp*Policz_pochodna_h(Fh,Fc,Fd,alfa,h0,C);   %wyznacza wartość wysokości, dla której policzy pochodną

pochodna = Policz_pochodna_h(Fh,Fc,Fd,alfa,h1,C);       %oblicza pochodną dla zmienionej wysokości

h = h0 + pochodna*Tp;                                   %wzór Eulera na kolejną wartość wysokości

end
