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

% Tutaj zastosowałem tą metodę okna hanninga i na podstawie wykresów trzeba
% pownioskować
k = 0:N-1;
F = 2*pi/(N*Tp)*k;
Ryu = xcorr(y,u);
Ruy = xcorr(u,y);
Ruu = xcorr(u,u);
Mw=200;
Hn = [zeros((2*N-2*Mw-2)/2, 1) ; hann(2*Mw+1) ; zeros((2*N-2*Mw-2)/2, 1)];
Ryu = Ryu.*Hn;
Ruy = Ruy.*Hn;
Ruu = Ruu.*Hn;
Ryu = Ryu(N:end);
Ruy = Ruy(N:end);
Ruu = Ruu(N:end);
Ruu = [Ruu(1:Mw+1); zeros(N-2*Mw-1, 1); Ruu(Mw+1:-1:2)];
Ryu = [Ryu(1:Mw+1); zeros(N-2*Mw-1, 1); Ruy(Mw+1:-1:2)];
G = fft(Ryu)./fft(Ruu);
figure;
Lm = 20*log10(abs(G));
fi = atan2(imag(G), real(G));
semilogx(F, Lm);
figure;
semilogx(F, fi);