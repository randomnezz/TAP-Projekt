function [ T ] = Policz_kolejne_T( Th, Tc, Td, T0, Fh, Fc, Fd, alfa, h, C, Tp)
%Funkcja licz�ca temperatur� wody w kolejnej iteracji

T1=T0+0.5*Tp*Policz_pochodna_T(Th,Tc,Td,T0,Fh,Fc,Fd,h,C);   %wyznacza warto�� temperatury, dla kt�rej policzy pochodn�

h1=h+0.5*Tp*Policz_pochodna_h(Fh,Fc,Fd,alfa,h,C);           %wyznacza warto�� wysoko�ci, dla kt�rej policzy pochodn�

pochodna = Policz_pochodna_T(Th,Tc,Td,T1,Fh,Fc,Fd,h1,C);    %oblicza pochodn� dla zmienionej temperatury i wysoko�ci

T=T0+pochodna*Tp;                                           %wz�r Eulera na kolejn� warto�� temperatury

end
