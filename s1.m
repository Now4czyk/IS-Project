% Załadowanie oraz wybranie kluczowych do identyfikacji danych
load('cstr.dat');
data=cstr(:, 3);
dataSize = size(data);

% Ilość próbek
N = dataSize(1);
t = 0:1:N-1; 
plot(t, data)