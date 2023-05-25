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

s = tf('s');

% uW = DaneDynW(:,1); yW = DaneDynW(:,2);     % dane - szum bialy
% uC = DaneDynC(:,1); yC = DaneDynC(:,2);     % dane - szum kolorowy
figure('Position', [135, 60, 980, 660]);    % wykresy
plot(t, yW, 'r'); hold on; legend('y');
title('White noise'); xlabel('t'); ylabel('y_w');

TF=50*Tp;
n = 5; % wybór rzędu dynamiki sla filtrów SVF
F0 = 1/(1+s*TF)^n; % definicja filtru SFV typu F^0
F1 = s/(1+s*TF)^n; % definicja filtru SFV typu F^1
F2 = s^2/(1+s*TF)^n; % definicja filtru SFV typu F^1
F3 = s^3/(1+s*TF)^n; % definicja filtru SFV typu F^1
F4 = s^4/(1+s*TF)^n; % definicja filtru SFV typu F^1
F5 = s^5/(1+s*TF)^n; % definicja filtru SFV typu F^1

M=7000
tE = Tp*(N-M:N); % wektor próbek chwil czasowych dla danych estymujących
uE = uW(N-M:N); % wybór wektora próbek sygnału pobudzającego u do zbioru Ze
yE = yW(N-M:N); % wybór wektora próbek sygnału wyjściowego y do zbioru Ze

yF = lsim(F0,yE,tE,'foh'); % filtracja SVF filtrem F^0 sekwencji yE z ekstrapolacją ’foh’
ypF = lsim(F1,yE,tE,'foh'); % filtracja SVF filtrem F^1 sekwencji yE z ekstrapolacją ’foh’
yp2F = lsim(F2,yE,tE,'foh'); % filtracja SVF filtrem F^1 sekwencji yE z ekstrapolacją 2foh’
yp3F = lsim(F3,yE,tE,'foh'); % filtracja SVF filtrem F^1 sekwencji yE z ekstrapolacją 3foh’
% yp4F = lsim(F4,yE,tE,'foh'); % filtracja SVF filtrem F^1 sekwencji yE z ekstrapolacją 4foh’
% yp5F = lsim(F5,yE,tE,'foh'); % filtracja SVF filtrem F^1 sekwencji yE z ekstrapolacją 5foh’

uF = lsim(F0,uE,tE,'foh'); % filtracja SVF filtrem F^0 sekwencji uE z ekstrapolacją ’foh’
upF = lsim(F1,uE,tE,'foh'); % filtracja SVF filtrem F^0 sekwencji uE z ekstrapolacją pfoh’
up2F = lsim(F2,uE,tE,'foh'); % filtracja SVF filtrem F^0 sekwencji uE z ekstrapolacją pfoh2
up3F = lsim(F3,uE,tE,'foh'); % filtracja SVF filtrem F^0 sekwencji uE z ekstrapolacją pfoh3
% up4F = lsim(F4,uE,tE,'foh'); % filtracja SVF filtrem F^0 sekwencji uE z ekstrapolacją pfoh4
% up5F = lsim(F5,uE,tE,'foh'); % filtracja SVF filtrem F^0 sekwencji uE z ekstrapolacją pfoh5

Phi=[-yp3F, -yp2F, -ypF, -yF, up3F, up2F, upF, uF];
% Phi=[-yF, -ypF, -yp2F, -yp3F, -yp4F, -yp5F, uF, upF, up2F, up3F, up4F, up5F];
p=(Phi'*Phi)^-1*Phi'*yp3F;
ye = Phi*p
plot(tE, ye, 'r')
Gm = tf([p(5), p(6), p(7), p(8)], [1, p(1), p(2), p(3), p(4)], Tp);
ym = lsim(Gm, uE, tE)
plot(tE, ym, 'k--')