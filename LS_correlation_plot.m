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
% figure('Position', [135, 60, 980, 660]);    % wykresy
% plot(t, yW, 'r'); hold on; legend('y');
% title('Odpowiedzi obiektu, estymaty i modelu'); xlabel('t'); ylabel('y');
%% dalij
Phi = [-yW(6:end-1), -yW(5:end-2), -yW(4:end-3), -yW(3:end-4), -yW(2:end-5), -yW(1:end-6), uW(6:end-1), uW(5:end-2), uW(4:end-3), uW(3:end-4), uW(2:end-5), uW(1:end-6)];
p = (Phi'*Phi)^-1 *Phi'*yW(7:end);
y_estym = [0; Phi*p];
% plot(t(6:end), y_estym, 'b--');

Gm = tf([p(7), p(8), p(9), p(10), p(11), p(12)], [1, p(1), p(2), p(3), p(4), p(5), p(6)], Tp);
ym = lsim(Gm, uW, t);
% plot(t, ym, 'k--')
% legend('y', 'y_{est}', 'y_m');

Ep = yW(1:end-5)-y_estym;
Em = yW - ym

Vp = Ep'*Ep/N;
Vm=Em'*Em/N

P = Vp*(Phi'*Phi)^-1;
PU95 = [p-1.96*sqrt(diag(P/N)), p+1.96*sqrt(diag(P/N))]; % przedziały ufności

% figure;
% impulse(Gm)
% hold on

%% Analiza korelacyjna
ryu= xcorr(y, u, 'biased');
ryu = ryu(N:end);
g = ryu/var(u);
% figure;
% plot(t, g);

NM = 7500; tM = 0:Tp:(NM-1)*Tp;
w = (20*sin(2*pi*0.04*tM).*exp(-0.05*tM))';
for k=1:NM
    yM(k) = g(1:k)'*w(k:-1:1);
end
figure;
% plot(tM, yM);
% legend('yM');

% Metoda dokladna
M = 2000;
ruu = xcorr(u, u, 'biased');
ryu = ryu(1:M);
Ruu = zeros(M, M);
for i=1:M
    Ruu(:, i) = ruu((N+1-i):(N+M-i));
end
g2 = pinv(Ruu)*ryu; % pinv - pseudoodwrotność
t=0:Tp:(M-1)*Tp;
% figure;
plot(t, g2);
hold on;
plot(t, [0; g2(1:M-1)])
y_i = impulse(Gm, t);
plot(t, y_i, 'r--')
legend('g(t)', 'g(t) - przesuniety', 'g(t) - modelu')

%odpowiedź na inne wymuszenie
h=zeros(M, 1);
for i=1:M
    h(i)=Tp*sum(g2(1:i));
end
figure;
plot(t, h);
hold on;
plot(t, [0; h(1:M-1)]);
y_s = step(Gm, t)
plot(t, y_s, 'r--')
legend('h(t)', 'h(t) - przesuniety', 'h(t) - modelu')

% Tutaj zastosowałem tą metodę okna hanninga i na podstawie wykresów trzeba
% pownioskować
% k = 0:N-1;
% F = 2*pi/(N*Tp)*k;
% Ryu = xcorr(y,u);
% Ruy = xcorr(u,y);
% Ruu = xcorr(u,u);
% Mw=200;
% Hn = [zeros((2*N-2*Mw-2)/2, 1) ; hann(2*Mw+1) ; zeros((2*N-2*Mw-2)/2, 1)];
% Ryu = Ryu.*Hn;
% Ruy = Ruy.*Hn;
% Ruu = Ruu.*Hn;
% Ryu = Ryu(N:end);
% Ruy = Ruy(N:end);
% Ruu = Ruu(N:end);
% Ruu = [Ruu(1:Mw+1); zeros(N-2*Mw-1, 1); Ruu(Mw+1:-1:2)];
% Ryu = [Ryu(1:Mw+1); zeros(N-2*Mw-1, 1); Ruy(Mw+1:-1:2)];
% G = fft(Ryu)./fft(Ruu);
% figure;
% Lm = 20*log10(abs(G));
% fi = atan2(imag(G), real(G));
% semilogx(F, Lm);
% figure;
% semilogx(F, fi);