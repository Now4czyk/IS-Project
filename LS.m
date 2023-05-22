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

uW = u;
yW = y;

% uW = DaneDynW(:,1); yW = DaneDynW(:,2);     % dane - szum bialy
% uC = DaneDynC(:,1); yC = DaneDynC(:,2);     % dane - szum kolorowy
figure('Position', [135, 60, 980, 660]);    % wykresy
plot(t, yW, 'r'); hold on; legend('y');
title('White noise'); xlabel('t'); ylabel('y_w');

Phi = [-yW(1:end-1), uW(1:end-1)];
p = (Phi'*Phi)^-1 *Phi'*yW(2:end);
y_estym = [0; Phi*p];
plot(t, y_estym, 'b--');

Ep = yW-y_estym;
Em = yo-ym;

Vp = Ep'*Ep/N;
Vm = Em'*Em/N;

P = Vp*(Phi'*Phi)^-1;
PU95 = [p-1.96*sqrt(diag(P/N)), p+1.96*sqrt(diag(P/N))]; % przedziały ufności