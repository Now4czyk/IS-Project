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
figure('Position', [135, 60, 980, 660]);    % wykresy
plot(t, yW, 'r'); hold on; legend('y');
title('White noise'); xlabel('t'); ylabel('y_w');
%% dalij
Nest = 5000;
Phi = [-yW(6:Nest-1), -yW(5:Nest-2), -yW(4:Nest-3), -yW(3:Nest-4), -yW(2:Nest-5), -yW(1:Nest-6), uW(6:Nest-1), uW(5:Nest-2), uW(4:Nest-3), uW(3:Nest-4), uW(2:Nest-5), uW(1:Nest-6)];
p = (Phi'*Phi)^-1 *Phi'*yW(7:Nest);
y_estym = [0; Phi*p];
plot(t(6:Nest), y_estym, 'b--');

Gm = tf([p(7), p(8), p(9), p(10), p(11), p(12)], [1, p(1), p(2), p(3), p(4), p(5), p(6)], Tp);
ym = lsim(Gm, uW, t);
plot(t, ym, 'k--')
legend('y', 'yp', 'ym');

Ep = yW(1:Nest-5)-y_estym;
Em = yW - ym

Vp = Ep'*Ep/N;
Vm=Em'*Em/N

P = Vp*(Phi'*Phi)^-1;
PU95 = [p-1.96*sqrt(diag(P/N)), p+1.96*sqrt(diag(P/N))]; % przedziały ufności

% figure;
% step(Gm)

%% IV

x = ym;

Z = [-x(6:Nest-1), -x(5:Nest-2), -x(4:Nest-3), -x(3:Nest-4), -x(2:Nest-5), -x(1:Nest-6), x(6:Nest-1), x(5:Nest-2), x(4:Nest-3), x(3:Nest-4), x(2:Nest-5), x(1:Nest-6)];
pIV = pinv(Z'*Phi)*Z'*yW(7:Nest);

yp =[0; Phi*pIV]; %odpowiedź predyktora
Gc = tf([pIV(7), pIV(8), pIV(9), pIV(10), pIV(11), pIV(12)], [1, pIV(1), pIV(2), pIV(3), pIV(4), pIV(5), pIV(6)], Tp);
ym2 = lsim(Gc, uW, t);

figure;
plot(t, yW, 'r'); legend('y');
title('White noise'); xlabel('t'); ylabel('y_w');
hold on
plot(t(6:Nest), yp, 'b--');
% plot(t, ym2, 'k--')
legend('y', 'yp', 'ym');
