%file:      Symulacja_uklad.m
%authors:   Jakub Gembiœ
%           Mateusz Baczewski
%           Pawe³ Kallas
%%
%////////////////////////////////////////////////////////////////////////////%
%               PRZYGOTOWANIE STA£YCH I ZMIENNYCH DO OBLICZEÑ                 %
%////////////////////////////////////////////////////////////////////////////%

% Jednostki podstawowe w modelu - stopnie celcjusza, sekundy, cm
clear;
addpath('liniowo')
% Sta³e
%-------------------------------------------------------------------------------------------------%
C = 0.5;            %sta³a wi¹¿¹ca objêtoœæ i wysokoœæ          [cm]
alfa = 20;          %sta³a wi¹¿¹ca odp³yw i wysokoœæ            [?(cm^5)/s]
TAUc = 160;         %opóŸnienie dop³ywu zimnej wody             [s]
TAUh = 80;          %opóŸnienie dop³ywu ciep³ej wody            [s]

%Punkt pracy
%-------------------------------------------------------------------------------------------------%
Tc0 = 25;            %temperatura zimnej wody                    [°C]
Th0 = 84;            %temperatura ciep³ej wody                   [°C]
Td0 = 42;            %temperatura wody dop³ywu zak³ócaj¹cego     [°C]
Fc0 = 54;            %dop³yw zimnej wody                         [cm?/s]
Fh0 = 23;            %dop³yw ciep³ej wody                        [cm?/s]
Fd0 = 10;            %dop³yw wody dop³ywu zak³ócaj¹cego          [cm?/s]

h = 18.92;          %wysokoœæ wody w zbiorniku                  [cm]
T = 42.55;          %temperatura wody w zbiorniku               [°C]

h_lin = 18.92;
T_lin = 42.55;

%Sta³e symulacji
%czas_symulacji musi byæ podzielny przez krok
%-------------------------------------------------------------------------------------------------%
krok = 0.1;             %okres próbkowania                      [s]
czas_symulacji = 400;   %czas symulacji                         [s]

lIter = czas_symulacji/krok + 1;    %liczba iteracji

%Sta³e symulacji
%czas_symulacji musi byæ podzielny przez krok
%-------------------------------------------------------------------------------------------------%
if(mod(lIter, 1) ~= 0) %jeœli czas_symulacji nie dzieli siê przez krok
disp('Zmienna "czas_symulacji" musi byc podzielna przez zmiennÃ„â€¦ "krok".') %drukuje komunikat
return                                                                %i koñczy program
end

%Wektory zmiennych
%-------------------------------------------------------------------------------------------------%
wysokosc(lIter) = 0;      %alokacja wektora zawieraj¹cego kolejne wartoœci wysokoœci wody [cm]
temperatura(lIter) = 0;   %alokacja wektora zawieraj¹cego kolejne wartoœci temperatury wody [°C]
wysokosc_lin(lIter) = 0;
temperatura_lin(lIter) = 0;
Fh(lIter) = 0;
Fc(lIter) = 0;
%Utworzenie wektorów wejœciowych oraz zak³ócaj¹cych
%-------------------------------------------------------------------------------------------------%
Fc_in = Fc0 * ones(lIter, 1);
Fh_in = Fh0 * ones(lIter, 1);
Fd = Fd0 * ones(lIter, 1);

Tc = Tc0 * ones(lIter, 1);
Th = Th0 * ones(lIter, 1);
Td = Td0 * ones(lIter, 1);

% skok na wejsciu
Fc_in( round((1/4)*lIter) : end) = Fc0 + 1;
% Fh_in( round((1/4)*lIter) : end) = Fh0 + 1;
% Fd( round((1/4)*lIter) : end) = Fd0 + 1;
% 
% Tc( round((1/4)*lIter) : end) = Tc0 + 1;
% Th( round((1/4)*lIter) : end) = Th0 + 1;
% Td( round((1/4)*lIter) : end) = Td0 + 1;

%%
%%////////////////////////////////////////////////////////////////////////////%
%                           G£ÓWNA PÊTLA PROGRAMU                              %
%/////////////////////////////////////////////////////////////////////////////%

for i = 1:lIter
   
    if(i - TAUh/krok > 0)
        Fh(i) = Fh_in(i - TAUh/krok);
    else
        Fh(i) = Fh0;
    end
    if(i - TAUc/krok > 0)
        Fc(i) = Fc_in(i - TAUc/krok);
    else
        Fc(i) = Fc0;
    end
  
    wysokosc(i) = h;                                             %wpisuje do tablicy wartoœci z poprzedniej iteracji
    temperatura(i) = T;                                          
    T = Policz_kolejne_T(Th(i), Tc(i), Td(i), T, Fh(i), Fc(i), Fd(i), alfa, h, C, krok); 
    h = Policz_kolejne_h(Fh(i), Fc(i), Fd(i), alfa, h, C, krok);
   
    wysokosc_lin(i) = h_lin;
    temperatura_lin(i) = T_lin;
    T_lin = policz_kolejne_T_lin(T_lin, h_lin, Tc(i), Th(i), Td(i), Fc(i), Fh(i), Fd(i), krok);
    h_lin = policz_kolejne_h_lin(h_lin, Fc(i), Fh(i), Fd(i), krok);
   
end;

%%
%/////////////////////////////////////////////////////////////////////////////%
%                  PRZEDSTAWIENIE WYNIKÓW NA WYKRESACH                        %
%/////////////////////////////////////////////////////////////////////////////%

czas = 0:krok:czas_symulacji;       %wektor czasu [s]
subplot(2,2,1);
plot(czas,wysokosc)
grid on
xlabel('czas [s]');
ylabel('wysokosc [cm]');            %wysokoœæ wody w zbiorniku [cm]
hold on

subplot(2,2,3);
plot(czas,temperatura)
grid on
xlabel('czas [s]');
ylabel('temperatura [^oC]');        %temperatura wody w zbiorniku [°C]
hold on

subplot(2,2,1);
plot(czas,wysokosc_lin)
legend('nieliniowy','liniowy','Location','west')
grid on
xlabel('czas [s]');                 %wysokoœæ - model zlinearyzowany [cm]
ylabel('wysokosc [cm]');            %na wykresie znajduja sie dwie funkcje

subplot(2,2,3);
plot(czas,temperatura_lin)
legend('nieliniowy','liniowy','Location','west')
grid on
xlabel('czas [s]');                 %temperatura - model zlinearyzowany [°C]
ylabel('temperatura [^oC]');        %na wykresie znajduja sie dwie funkcje

subplot(2,2,2);
plot(czas,(wysokosc_lin-wysokosc)./wysokosc)    %wykres bledu bezwzglednego (wysokosc) [cm]
grid on
xlabel('czas [s]');
ylabel('blad wzgledny [%]');

subplot(2,2,4);
plot(czas,(temperatura_lin-temperatura)./temperatura)%wykres bledu bezwzglednego (temperatura) [°C]
grid on
xlabel('czas [s]');
ylabel('blad wzgledny [%]');

rmpath('liniowo')
