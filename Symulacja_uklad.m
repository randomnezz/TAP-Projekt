%file:      Symulacja_uklad.m
%authors:   Jakub Gembiś
%           Mateusz Baczewski
%           Paweł Kallas
%%
%////////////////////////////////////////////////////////////////////////////%
%               PRZYGOTOWANIE STAŁYCH I ZMIENNYCH DO OBLICZEŃ                 %
%/////////////////////////////////////////////////////////////////////////////%

% Jednostki podstawowe w modelu - stopnie celcjusza, sekundy, cm

% Stałe
%-------------------------------------------------------------------------------------------------%
C = 0.5;            %stała wiążąca objętość i wysokość          [cm]
alfa = 20;          %stała wiążąca odpływ i wysokość            [?(cm^5)/s]


%Punkt pracy
%-------------------------------------------------------------------------------------------------%
Tc = 25;            %temperatura zimnej wody                    [°C]
Th = 84;            %temperatura ciepłej wody                   [°C]
Td = 42;            %temperatura wody dopływu zakłócającego     [°C]
Fc = 54;            %dopływ zimnej wody                         [cm?/s]
Fh = 23;            %dopływ ciepłej wody                        [cm?/s]
Fd = 10;            %dopływ wody dopływu zakłócającego          [cm?/s]
TAUc = 160;         %opóźnienie dopływu zimnej wody             [s]
TAUh = 80;          %opóźnienie dopływu ciepłej wody            [s]
h = 18.92;          %wysokość wody w zbiorniku                  [cm]
T = 42.55;          %temperatura wody w zbiorniku               [°C]

%Stałe symulacji
%czas_symulacji musi być podzielny przez krok
%-------------------------------------------------------------------------------------------------%
krok = 0.2;             %okres próbkowania                      [s]
czas_symulacji = 300;   %czas symulacji                         [s]

%Sprawdzenie poprawności zmiennych
%czas symulacji i krok
%-------------------------------------------------------------------------------------------------%
if((czas_symulacji/krok)~=round(czas_symulacji/krok)) %jeśli czas_symulacji nie dzieli się przez krok
disp('Zmienna "czas_symulacji" musi byc podzielna przez zmienną "krok".') %drukuje komunikat
return                                                                %i kończy program
end

%Wektory zmiennych
%-------------------------------------------------------------------------------------------------%
wysokosc(czas_symulacji/krok+1) = 0;      %alokacja wektora zawierającego kolejne wartości wysokości wody [cm]
temperatura(czas_symulacji/krok+1) = 0;   %alokacja wektora zawierającego kolejne wartości temperatury wody [°C]

%Utworzenie wektorów wejściowych oraz zakłócających
%Każdy zawiera skok wartości
%Po utworzeniu sprawdzane jest czy wektor został utworzony bez błędów
%-------------------------------------------------------------------------------------------------%
FcIN = Utworz_wektor(czas_symulacji,Fc,Fc+0.1,15,krok);             %wejściowy dopływ wody zimnej [cm?/s]
if(FcIN == 0)                                                       %jeśli błąd
    return                                                          %zakończ program
end

FcTab = Utworz_wektor(czas_symulacji,Fc,Fc+0.1,15+TAUc,krok);       %dopływ wody zimnej z opóźnieniem [cm?/s]
if(FcTab == 0)                                                      %jeśli błąd
    return                                                          %zakończ program
end

FhIN = Utworz_wektor(czas_symulacji,Fh,Fh+0.2,15,krok);             %wejściowy dopływ wody ciepłej [cm?/s]
if(FhIN == 0)                                                       %jeśli błąd
    return                                                          %zakończ program
end

FhTab = Utworz_wektor(czas_symulacji,Fh,Fh+0.2,15+TAUh,krok);       %dopływ wody ciepłej z opóźnieniem [cm?/s]
if(FhTab == 0)                                                      %jeśli błąd
    return                                                          %zakończ program
end

FdTab = Utworz_wektor(czas_symulacji,Fd,10.5,czas_symulacji/3,krok);%dopływ zakłócający [cm?/s]
if(FdTab == 0)                                                      %jeśli błąd
    return                                                          %zakończ program
end

TdTab = Utworz_wektor(czas_symulacji,Td,42.2,2*czas_symulacji/3,krok);%temperatura dopływu zakłócającego [°C]
if(TdTab == 0)                                                      %jeśli błąd
    return                                                          %zakończ program
end

%%
%%////////////////////////////////////////////////////////////////////////////%
%                           GŁÓWNA PĘTLA PROGRAMU                             %
%/////////////////////////////////////////////////////////////////////////////%

for t = 0:(czas_symulacji/krok)
  
   wysokosc(t+1)=h;                                             %wpisuje do tablicy wartości z poprzedniej iteracji
   temperatura(t+1)=T;                                          %indeks to "t+1", bo Matlab indeksuje wektory od 1
   T = Policz_kolejne_T(Th,Tc,TdTab(t+1),T,Fh,Fc,FdTab(t+1),alfa,h,C,krok); 
   h = Policz_kolejne_h(Fh,Fc,FdTab(t+1),alfa,h,C,krok);                    %skok wartości Fd oraz Td
   %T = Policz_kolejne_T(Th,Tc,Td,T,FhTab(t+1),FcTab(t+1),Fd,alfa,h,C,krok)
   %h = Policz_kolejne_h(FhTab(t+1),FcTab(t+1),Fd,alfa,h,C,krok);           %skok wartości Fh oraz Fc
   
end;

%%
%/////////////////////////////////////////////////////////////////////////////%
%                  PRZEDSTAWIENIE WYNIKÓW NA WYKRESACH                        %
%/////////////////////////////////////////////////////////////////////////////%

czas = 0:krok:czas_symulacji;       %wektor czasu [s]
subplot(2,1,1);                     %rysuje dwa wykresy: wysokości i temperatury
plot(czas,wysokosc)
grid on
xlabel('czas [s]');
ylabel('wysokosc [cm]');            %górny wykres: wysokość wody w zbiorniku [cm]
subplot(2,1,2);
plot(czas,temperatura)
grid on
xlabel('czas [s]');
ylabel('temperatura [^oC]');        %dolny wykres: temperatura wody w zbiorniku [°C]
