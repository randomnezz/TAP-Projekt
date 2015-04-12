%file:      Symulacja_uklad.m
%authors:   Jakub GembiĹ›
%           Mateusz Baczewski
%           PaweĹ‚ Kallas
%%
%////////////////////////////////////////////////////////////////////////////%
%               PRZYGOTOWANIE STAĹ?YCH I ZMIENNYCH DO OBLICZEĹ?                 %
%////////////////////////////////////////////////////////////////////////////%

% Jednostki podstawowe w modelu - stopnie celcjusza, sekundy, cm
clear;
addpath('liniowo')
% StaĹ‚e
%-------------------------------------------------------------------------------------------------%
C = 0.5;            %staĹ‚a wiÄ…ĹĽÄ…ca objÄ™toĹ›Ä‡ i wysokoĹ›Ä‡          [cm]
alfa = 20;          %staĹ‚a wiÄ…ĹĽÄ…ca odpĹ‚yw i wysokoĹ›Ä‡            [?(cm^5)/s]
TAUc = 160;         %opĂłĹşnienie dopĹ‚ywu zimnej wody             [s]
TAUh = 80;          %opĂłĹşnienie dopĹ‚ywu ciepĹ‚ej wody            [s]

%Punkt pracy
%-------------------------------------------------------------------------------------------------%
Tc0 = 25;            %temperatura zimnej wody                    [Â°C]
Th0 = 84;            %temperatura ciepĹ‚ej wody                   [Â°C]
Td0 = 42;            %temperatura wody dopĹ‚ywu zakĹ‚ĂłcajÄ…cego     [Â°C]

Fc0 = 54;            %dopĹ‚yw zimnej wody                         [cm?/s]
Fh0 = 23;            %dopĹ‚yw ciepĹ‚ej wody                        [cm?/s]
Fd0 = 10;            %dopĹ‚yw wody dopĹ‚ywu zakĹ‚ĂłcajÄ…cego          [cm?/s]

h = 18.92;          %wysokoĹ›Ä‡ wody w zbiorniku                  [cm]
T = 42.55;          %temperatura wody w zbiorniku               [Â°C]

h_lin = 18.92;
T_lin = 42.55;

%StaĹ‚e symulacji
%czas_symulacji musi byÄ‡ podzielny przez krok
%-------------------------------------------------------------------------------------------------%
krok = 0.1;             %okres prĂłbkowania                      [s]
czas_symulacji = 400;   %czas symulacji                         [s]

lIter = czas_symulacji/krok + 1;    %liczba iteracji

%Sprawdzenie poprawnoĹ›ci zmiennych
%czas symulacji i krok
%-------------------------------------------------------------------------------------------------%
if(mod(lIter, 1) ~= 0) %jeĹ›li czas_symulacji nie dzieli siÄ™ przez krok
disp('Zmienna "czas_symulacji" musi byc podzielna przez zmiennÄ… "krok".') %drukuje komunikat
return                                                                %i koĹ„czy program
end

%Wektory zmiennych
%-------------------------------------------------------------------------------------------------%
wysokosc(lIter) = 0;      %alokacja wektora zawierajÄ…cego kolejne wartoĹ›ci wysokoĹ›ci wody [cm]
temperatura(lIter) = 0;   %alokacja wektora zawierajÄ…cego kolejne wartoĹ›ci temperatury wody [Â°C]
wysokosc_lin(lIter) = 0;
temperatura_lin(lIter) = 0;
Fh(lIter) = 0;
Fc(lIter) = 0;
%Utworzenie wektorĂłw wejĹ›ciowych
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
%                           GĹ?Ă“WNA PÄ?TLA PROGRAMU                             %
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
  
    wysokosc(i) = h;                                             %wpisuje do tablicy wartoĹ›ci z poprzedniej iteracji
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
%                  PRZEDSTAWIENIE WYNIKĂ“W NA WYKRESACH                        %
%/////////////////////////////////////////////////////////////////////////////%

czas = 0:krok:czas_symulacji;       %wektor czasu [s]
subplot(2,2,1);
plot(czas,wysokosc)
grid on
xlabel('czas [s]');
ylabel('wysokosc [cm]');            %wysokoĹ›Ä‡ wody w zbiorniku [cm]
hold on

subplot(2,2,3);
plot(czas,temperatura)
grid on
xlabel('czas [s]');
ylabel('temperatura [^oC]');        %temperatura wody w zbiorniku [Â°C]
hold on

subplot(2,2,1);
plot(czas,wysokosc_lin)
legend('nieliniowy','liniowy','Location','west')
grid on
xlabel('czas [s]');                 %wysokosc - model zlinearyzowany [cm]
ylabel('wysokosc [cm]');            %na wykresie znajduja sie dwie funkcje

subplot(2,2,3);
plot(czas,temperatura_lin)
legend('nieliniowy','liniowy','Location','west')
grid on
xlabel('czas [s]');                 %temperatura - model zlinearyzowany [°C]
ylabel('temperatura [^oC]');        %na wykresie znajduja sie dwie funkcje

subplot(2,2,2);
plot(czas,wysokosc_lin-wysokosc)    %wykres bledu bezwzglednego (wysokosc) [cm]
grid on
xlabel('czas [s]');
ylabel('blad bezwzgledny (lin-nlin) [cm]');

subplot(2,2,4);
plot(czas,temperatura_lin-temperatura)%wykres bledu bezwzglednego (temperatura) [°C]
grid on
xlabel('czas [s]');
ylabel('blad bezwzgledny (lin-nlin) [^oC]');

rmpath('liniowo')
