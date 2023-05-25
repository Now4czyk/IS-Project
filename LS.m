clear; close all;

% Załadowanie oraz wybranie kluczowych do identyfikacji danych
load('cstr.dat');

% Okres próbkowania odczytany
Tp = 0.1;
% pomiar wejścia do obiektu
u = cstr(:, 2);
% pomiar wyjścia z obiektu
y = cstr(:, 3);
t = cstr(:, 1);
dataSize = size(y);
N=7500

uW = u;
yW = y;

% uW = DaneDynW(:,1); yW = DaneDynW(:,2);     % dane - szum bialy
% uC = DaneDynC(:,1); yC = DaneDynC(:,2);     % dane - szum kolorowy
figure();    % wykresy
plot(t, yW, 'r'); hold on; legend('y');
title('Odpowiedzi obiektu, estymaty i modelu'); xlabel('t'); ylabel('y');


%% dalij
Phi = [-yW(6:end-1), -yW(5:end-2), -yW(4:end-3), -yW(3:end-4), -yW(2:end-5), -yW(1:end-6), uW(6:end-1), uW(5:end-2), uW(4:end-3), uW(3:end-4), uW(2:end-5), uW(1:end-6)];
p = (Phi'*Phi)^-1 *Phi'*yW(7:end);
y_estym = [0; Phi*p];
plot(t(6:end), y_estym, 'b--');

Gm = tf([p(7), p(8), p(9), p(10), p(11), p(12)], [1, p(1), p(2), p(3), p(4), p(5), p(6)], Tp)
ym = lsim(Gm, uW, t);
plot(t, ym, 'k--')
legend('y', 'y_{est}', 'y_m');

Ep = yW(1:end-5)-y_estym;
Em = yW - ym;

Vp = Ep'*Ep/N;
Vm=Em'*Em/N;

P = Vp*(Phi'*Phi)^-1;
PU95 = [p-1.96*sqrt(diag(P/N)), p+1.96*sqrt(diag(P/N))]; % przedziały ufności
t =  0:.1:200;
figure;
impulse(Gm);

%% transmitancja z widmowej

s = tf('s')
T = -0.005279385057
Gw = 0.001*s/((1+T*s)^2)
figure
impulse(Gw)
figure
step(Gw)