function [ T ] = Policz_kolejne_T( Th, Tc, Td, T0, Fh, Fc, Fd, alfa, h, C, Tp)
%Funkcja licząca temperaturę wody w kolejnej iteracji

T1=T0+0.5*Tp*Policz_pochodna_T(Th,Tc,Td,T0,Fh,Fc,Fd,h,C);   %wyznacza wartość temperatury, dla której policzy pochodną

h1=h+0.5*Tp*Policz_pochodna_h(Fh,Fc,Fd,alfa,h,C);           %wyznacza wartość wysokości, dla której policzy pochodną

pochodna = Policz_pochodna_T(Th,Tc,Td,T1,Fh,Fc,Fd,h1,C);    %oblicza pochodną dla zmienionej temperatury i wysokości

T=T0+pochodna*Tp;                                           %wzór Eulera na kolejną wartość temperatury

end
