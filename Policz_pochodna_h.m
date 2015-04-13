function [ pochodna ] = Policz_pochodna_h(Fh, Fc, Fd, alfa, h, C)
%Funkcja liczy pochodn¹ wysokoœci dla danych warunków aktualnych

suma = Fh+Fc+Fd-alfa*sqrt(h);
pochodna = suma/(2*C*h);

end
