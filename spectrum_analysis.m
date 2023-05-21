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

%% Analiza widmowa
k = 0:N-1;
F = 2*pi/(N*Tp)*k;
G = fft(y)./fft(u);
Lm = 20*log10(abs(G));
fi = atan2(imag(G), real(G));
figure;
subplot(2,1,1);
semilogx(F, Lm);
title('Lm')
subplot(2,1,2); 
semilogx(F, fi);
title('fi')

Ryu = xcorr(y,u);
Ruy = xcorr(u,y);
Ruu = xcorr(u,u);
% stworzymy tutaj bezpieczne okno hanninga
Mw=200;
Hn = [zeros((2*N-2*Mw-2)/2, 1) ; hann(2*Mw+1) ; zeros((2*N-2*Mw-2)/2, 1)];

% pierwsza część
Ryu = Ryu.*Hn;
Ruy = Ruy.*Hn;
Ruu = Ruu.*Hn;

% druga część
Ryu = Ryu(N:end);
Ruy = Ruy(N:end);
Ruu = Ruu(N:end);

% trzecia część
Ruu = [Ruu(1:Mw+1); zeros(N-2*Mw-1, 1); Ruu(Mw+1:-1:2)];
Ryu = [Ryu(1:Mw+1); zeros(N-2*Mw-1, 1); Ruy(Mw+1:-1:2)];
G = fft(Ryu)./fft(Ruu);

figure;
Lm = 20*log10(abs(G));
fi = atan2(imag(G), real(G));
subplot(2,1,1);
semilogx(F, Lm);
title('Lm')
subplot(2,1,2);
semilogx(F, fi);
title('fi')
xlim([0.01, 10]);
