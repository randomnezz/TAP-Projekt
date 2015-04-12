function [ T ] = policz_kolejne_T_lin(T, h, Tc, Th, Td, Fc, Fh, Fd, Tp)
%Funkcja licz±ca zmieniaj±c± siê temperature

pom_T = T + 0.5*Tp * pochodna_T_lin(T, h, Tc, Th, Td, Fc, Fh, Fd);
pom_h = h + 0.5*Tp * pochodna_h_lin(h, Fc, Fh, Fd);

pochodna = pochodna_T_lin(pom_T, pom_h, Tc, Th, Td, Fc, Fh, Fd);
T = T + Tp * pochodna;

end