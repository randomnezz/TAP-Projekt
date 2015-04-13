C = 0.5;
alfa = 20;

Tc0 = 25;
Th0 = 84;
Td0 = 42;

Fc0 = 54;
Fh0 = 23;
Fd0 = 10;

tau_c = 160;
tau_h = 80;

h0 = 18.92;
T0 = 42.55;
V0 = 10;

syms h Fc Fh Fd Tc Th Td T;
% Funkcja dh/dt w wyra¿eniach symbolicznych
dhdt = (1/(2*C*h)) * (Fh + Fc + Fd - alfa*sqrt(h));
% Rozwiniêcie w Taylora. subs podstawia wartoœci do zmiennych
% symbolicznych, diff liczy pochodn¹ symbolicznie. 
dhdt_lin = subs(dhdt, [Fc, Fh, Fd, h], [Fc0, Fh0, Fd0, h0]) + ...           %wartoœæ funkcji w punkcie pracy
            subs(diff(dhdt, h), [Fc, Fh, Fd, h], [Fc0, Fh0, Fd0, h0]) * (h-h0) + ...    % Pochodne cz¹stkowe przemno¿one przez odpowiednie ró¿nice
            subs(diff(dhdt, Fh), [Fc, Fh, Fd, h], [Fc0, Fh0, Fd0, h0]) * (Fh-Fh0) + ...
            subs(diff(dhdt, Fc), [Fc, Fh, Fd, h], [Fc0, Fh0, Fd0, h0]) * (Fc-Fc0) + ...
            subs(diff(dhdt, Fd), [Fc, Fh, Fd, h], [Fc0, Fh0, Fd0, h0]) * (Fd-Fd0);
        
% analogicznie drugie równanie
dTdt = (1/(C*h*h)) * (Fh*Th + Fc*Tc + Fd*Td - (Fh+Fc+Fd)*T);

dTdt_lin =  subs(dTdt, [Fc, Fh, Fd, Tc, Th, Td, T, h], [Fc0, Fh0, Fd0, Tc0, Th0, Td0, T0, h0]) + ...
            subs(diff(dTdt, h), [Fc, Fh, Fd, Tc, Th, Td, T, h], [Fc0, Fh0, Fd0, Tc0, Th0, Td0, T0, h0]) * (h-h0) + ...
            subs(diff(dTdt, Fc), [Fc, Fh, Fd, Tc, Th, Td, T, h], [Fc0, Fh0, Fd0, Tc0, Th0, Td0, T0, h0]) * (Fc-Fc0) + ...
            subs(diff(dTdt, Fh), [Fc, Fh, Fd, Tc, Th, Td, T, h], [Fc0, Fh0, Fd0, Tc0, Th0, Td0, T0, h0]) * (Fh-Fh0) + ...
            subs(diff(dTdt, Fd), [Fc, Fh, Fd, Tc, Th, Td, T, h], [Fc0, Fh0, Fd0, Tc0, Th0, Td0, T0, h0]) * (Fd-Fd0) + ...
            subs(diff(dTdt, Tc), [Fc, Fh, Fd, Tc, Th, Td, T, h], [Fc0, Fh0, Fd0, Tc0, Th0, Td0, T0, h0]) * (Tc-Tc0) + ...
            subs(diff(dTdt, Th), [Fc, Fh, Fd, Tc, Th, Td, T, h], [Fc0, Fh0, Fd0, Tc0, Th0, Td0, T0, h0]) * (Th-Th0) + ...
            subs(diff(dTdt, Td), [Fc, Fh, Fd, Tc, Th, Td, T, h], [Fc0, Fh0, Fd0, Tc0, Th0, Td0, T0, h0]) * (Td-Td0) + ...
            subs(diff(dTdt, T), [Fc, Fh, Fd, Tc, Th, Td, T, h], [Fc0, Fh0, Fd0, Tc0, Th0, Td0, T0, h0]) * (T-T0);
            
% przekszta³cenie tego na funkcje symboliczne (mo¿na to by³o od pocz¹tku tak traktowaæ, ale za póŸno to znalaz³em)        
dhdt_fun = symfun(dhdt_lin, [Fc, Fh, Fd, h]);
dTdt_fun = symfun(dTdt_lin, [Fc, Fh, Fd, Tc, Th, Td, T, h]);

%% model stanowy
% x = [h; T];
% u = [Fc; Fh; Fd; Tc; Th; Td]


A = double([dhdt_fun(0, 0, 0, 1) - dhdt_fun(0, 0, 0, 0), 0;
    dTdt_fun(0, 0, 0, 0, 0, 0, 0, 1) - dTdt_fun(0, 0, 0, 0, 0, 0, 0, 0),  dTdt_fun(0, 0, 0, 0, 0, 0, 1, 0) - dTdt_fun(0, 0, 0, 0, 0, 0, 0, 0)]);

B = double([dhdt_fun(1, 0, 0, 0) - dhdt_fun(0, 0, 0, 0), dhdt_fun(0, 1, 0, 0) - dhdt_fun(0, 0, 0, 0), dhdt_fun(0, 0, 1, 0) - dhdt_fun(0, 0, 0, 0), 0;
    dTdt_fun(1,0,0,0,0,0,0,0) - dTdt_fun(0,0,0,0,0,0,0,0), dTdt_fun(0,1,0,0,0,0,0,0) - dTdt_fun(0,0,0,0,0,0,0,0), dTdt_fun(0,0,1,0,0,0,0,0) - dTdt_fun(0,0,0,0,0,0,0,0), ...
    dTdt_fun(0,0,0,0,0,1,0,0) - dTdt_fun(0,0,0,0,0,0,0,0)]);

C = [1, 0; 0, 1];
D = [0,0,0,0;
    0,0,0,0];
sys = ss(A,B,C,D);
