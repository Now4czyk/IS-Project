clear; close all;

% Załadowanie oraz wybranie kluczowych do identyfikacji danych
load('cstr.dat');

% Okres próbkowania odczytany
Tp = 0.1;
% pomiar wejścia do obiektu
u = cstr(:, 2);
% pomiar wyjścia z obiektu
y = cstr(:, 3);
dataSize = size(y);

% Ilość próbek
N = dataSize(1);
t = 0:1:N-1; 
subplot(2, 1, 1);
plot(t, u, 'r')
legend('sygnał wejściowy');
subplot(2, 1, 2)
plot(t, y, 'b')
legend('sygnał wyjściowy');

%% Analiza korelacyjna
ryu= xcorr(y, u, 'biased');
ryu = ryu(N:end);
g = ryu/var(u);
figure;
plot(t, g);

NM = 7500; tM = 0:Tp:(NM-1)*Tp;
w = (20*sin(2*pi*0.04*tM).*exp(-0.05*tM))';
for k=1:NM
    yM(k) = g(1:k)'*w(k:-1:1);
end
figure;
plot(tM, yM);
legend('yM');

% Metoda dokladna
M = 60;
ruu = xcorr(u, u, 'biased');
ryu = ryu(1:M);
Ruu = zeros(M, M);
for i=1:M
    Ruu(:, i) = ruu((N+1-i):(N+M-i));
end
g2 = pinv(Ruu)*ryu; % pinv - pseudoodwrotność
t=0:Tp:(M-1)*Tp;
figure;
plot(t, g2);
hold on;
plot(t, [0; g2(1:M-1)])
legend('g(t)', 'g(t) - przesunięty')
xlabel('t'); ylabel('y')

%odpowiedź na inne wymuszenie
h=zeros(M, 1);
for i=1:M
    h(i)=Tp*sum(g2(1:i));
end
figure;
plot(t, h);
hold on;
plot(t, [0; h(1:M-1)]);
legend('h(t)', 'h(t) - przesunięty')
xlabel('t'); ylabel('y')