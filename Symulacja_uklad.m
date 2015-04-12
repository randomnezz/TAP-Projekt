%file:      Symulacja_uklad.m
%authors:   Jakub Gembiś
%           Mateusz Baczewski
%           Paweł Kallas
%%
%////////////////////////////////////////////////////////////////////////////%
%               PRZYGOTOWANIE STA�?YCH I ZMIENNYCH DO OBLICZE�?                 %
%////////////////////////////////////////////////////////////////////////////%

% Jednostki podstawowe w modelu - stopnie celcjusza, sekundy, cm
clear;
addpath('liniowo')
% Stałe
%-------------------------------------------------------------------------------------------------%
C = 0.5;            %stała wiążąca objętość i wysokość          [cm]
alfa = 20;          %stała wiążąca odpływ i wysokość            [?(cm^5)/s]
TAUc = 160;         %opóźnienie dopływu zimnej wody             [s]
TAUh = 80;          %opóźnienie dopływu ciepłej wody            [s]

%Punkt pracy
%-------------------------------------------------------------------------------------------------%
Tc0 = 25;            %temperatura zimnej wody                    [°C]
Th0 = 84;            %temperatura ciepłej wody                   [°C]
Td0 = 42;            %temperatura wody dopływu zakłócającego     [°C]

Fc0 = 54;            %dopływ zimnej wody                         [cm?/s]
Fh0 = 23;            %dopływ ciepłej wody                        [cm?/s]
Fd0 = 10;            %dopływ wody dopływu zakłócającego          [cm?/s]

h = 18.92;          %wysokość wody w zbiorniku                  [cm]
T = 42.55;          %temperatura wody w zbiorniku               [°C]

h_lin = 18.92;
T_lin = 42.55;

%Stałe symulacji
%czas_symulacji musi być podzielny przez krok
%-------------------------------------------------------------------------------------------------%
krok = 0.1;             %okres próbkowania                      [s]
czas_symulacji = 400;   %czas symulacji                         [s]

lIter = czas_symulacji/krok + 1;    %liczba iteracji

%Sprawdzenie poprawności zmiennych
%czas symulacji i krok
%-------------------------------------------------------------------------------------------------%
if(mod(lIter, 1) ~= 0) %jeśli czas_symulacji nie dzieli się przez krok
disp('Zmienna "czas_symulacji" musi byc podzielna przez zmienną "krok".') %drukuje komunikat
return                                                                %i kończy program
end

%Wektory zmiennych
%-------------------------------------------------------------------------------------------------%
wysokosc(lIter) = 0;      %alokacja wektora zawierającego kolejne wartości wysokości wody [cm]
temperatura(lIter) = 0;   %alokacja wektora zawierającego kolejne wartości temperatury wody [°C]
wysokosc_lin(lIter) = 0;
temperatura_lin(lIter) = 0;
Fh(lIter) = 0;
Fc(lIter) = 0;
%Utworzenie wektorów wejściowych
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
%                           G�?ÓWNA P�?TLA PROGRAMU                             %
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
  
    wysokosc(i) = h;                                             %wpisuje do tablicy wartości z poprzedniej iteracji
    temperatura(i) = T;                                          
    T = Policz_kolejne_T(Th(i), Tc(i), Td(i), T, Fh(i), Fc(i), Fd(i), alfa, h, C, krok); 
    h = Policz_kolejne_h(Fh(i), Fc(i), Fd(i), alfa, h, C, krok);
   
    wysokosc_lin(i) = h_lin;
    temperatura_lin(i) = T_lin;
    h_lin = policz_kolejne_h_lin(h_lin, Fc(i), Fh(i), Fd(i), krok);
    T_lin = policz_kolejne_T_lin(T_lin, h_lin, Tc(i), Th(i), Td(i), Fc(i), Fh(i), Fd(i), krok);
   
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
ylabel('wysokosc [cm]');            %wysokość wody w zbiorniku [cm]
title('Model nieliniowy');
subplot(2,2,3);
plot(czas,temperatura)
grid on
xlabel('czas [s]');
ylabel('temperatura [^oC]');        %temperatura wody w zbiorniku [°C]
title('Model nieliniowy');

subplot(2,2,2);
plot(czas,wysokosc_lin)
grid on
xlabel('czas [s]');
ylabel('wysokosc [cm]');
title('Model liniowy');
subplot(2,2,4);
plot(czas,temperatura_lin)
grid on
xlabel('czas [s]');
ylabel('temperatura [^oC]');
title('Model liniowy');

rmpath('liniowo')