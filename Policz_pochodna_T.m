function [ pochodna ] = Policz_pochodna_T(Th, Tc, Td, T, Fh, Fc, Fd, h, C)
%Funkcja liczy pochodn¹ temperatury dla danych warunków aktualnych

suma = Fh*Th+Fc*Tc+Fd*Td-(Fh+Fc+Fd)*T;
pochodna = suma/(C*h^2);

end
