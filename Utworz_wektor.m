function [ wektor ] = Utworz_wektor(dlugosc, y0, y1, skok, krok)
%Funkcja tworzy wektor wierszowy o długości "dlugosc/krok+1",
%jako zmienna długość należy podać czas wyrażony w sekundach.
%Wartości wektora do czasu [sek] "skok" mają wartości "y0" a dla kolejnych
%indeksów przyjmują wartości "y1".
%Funkcja zwraca zero jeśli wystąpił błąd.

%   wektor          - wektor wynikowy
%   dlugosc         - długość wektora wyrażona w sekundach
%   y0              - wartości przed skokiem
%   y1              - wartości po skoku
%   skok            - wyrażona w sekundach wartość po jakiej nastąpi skok
%   krok            - wyrażony w sekundach czas próbkowania

%sprawdzenie poprawności danych wejściowych
if (skok >= dlugosc)                            %jeśli "skok" jest większa od "dlugosc"
    disp('Zmienna "skok" musi być mniejsza od zmiennej "dlugosc".')
    wektor = 0;
elseif (dlugosc/krok ~= round(dlugosc/krok))    %jeśli "dlugosc" nie dzieli się przez "krok"
    disp('Zmienna "dlugosc" musi być podzielna przez zmienną "krok".')
    wektor = 0;
elseif (skok/krok ~= round(skok/krok))          %jeśli "skok" nie dzieli się przez "krok"
    disp('Zmienna "skok" musi być podzielna przez zmienną "krok".')
    wektor = 0;
else
    wektor = y0*ones(1,dlugosc/krok+1);         %wektor jest zapełniany wartościami początkowymi "y0"
    
    wektor(:,(skok/krok+1):(dlugosc/krok+1)) = y1*ones(1,dlugosc/krok-skok/krok+1);%dla indeksów odpowiadających
                                                       %czasowi po "skok" wartości wektora zmieniają się na "y1"
end

end
