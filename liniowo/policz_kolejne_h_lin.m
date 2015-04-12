function [ h ] = policz_kolejne_h_lin(h, Fc, Fh, Fd, Tp)
%Funkcja licz�ca wysoko�� poziomu zbiornika

pom = h + 0.5*Tp * pochodna_h_lin(h, Fc, Fh, Fd);

pochodna = pochodna_h_lin(pom, Fc, Fh, Fd);
h = h + Tp * pochodna;


end

