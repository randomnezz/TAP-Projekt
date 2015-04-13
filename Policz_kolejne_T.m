function [ T ] = Policz_kolejne_T( Th, Tc, Td, T0, Fh, Fc, Fd, alfa, h, C, Tp)
%Funkcja licz¹ca temperaturê wody w kolejnej iteracji

T1=T0+0.5*Tp*Policz_pochodna_T(Th,Tc,Td,T0,Fh,Fc,Fd,h,C);   %wyznacza wartoœæ temperatury, dla której policzy pochodn¹

h1=h+0.5*Tp*Policz_pochodna_h(Fh,Fc,Fd,alfa,h,C);           %wyznacza wartoœæ wysokoœci, dla której policzy pochodn¹

pochodna = Policz_pochodna_T(Th,Tc,Td,T1,Fh,Fc,Fd,h1,C);    %oblicza pochodn¹ dla zmienionej temperatury i wysokoœci

T=T0+pochodna*Tp;                                           %wzór Eulera na kolejn¹ wartoœæ temperatury

end
