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

training_dataset_percent = 0.7;
validation_dataset_percentage = 1- training_dataset_percent;

yW_training = yW(1:N*training_dataset_percent);
uW_training = uW(1:N*training_dataset_percent);
t_training = t(1:N*training_dataset_percent);

yW_validation = yW(N*training_dataset_percent:N);
uW_validation = uW(N*training_dataset_percent:N);
t_validation = t(N*training_dataset_percent:N);


figure('Position', [100, 100, 800, 600]);    % wykresy
plot(t_validation, yW_validation, 'r'); hold on; legend('y');
title('Odpowiedzi obiektu, estymaty i modelu'); xlabel('t'); ylabel('y');


%% LS
% Phi = [-yW(6:end-1), -yW(5:end-2), -yW(4:end-3), -yW(3:end-4), -yW(2:end-5), -yW(1:end-6), uW(6:end-1), uW(5:end-2), uW(4:end-3), uW(3:end-4), uW(2:end-5), uW(1:end-6)];
% p = (Phi'*Phi)^-1 *Phi'*yW(7:end);
% y_estym = [0; Phi*p];
% plot(t(6:end), y_estym, 'b--');

Phi = [-yW_training(4:end-1), -yW_training(3:end-2), -yW_training(2:end-3), -yW_training(1:end-4), uW_training(4:end-1), uW_training(3:end-2), uW_training(2:end-3), uW_training(1:end-4)];
p = (Phi'*Phi)^-1 *Phi'*yW_training(5:end);
Phi_validation = [-yW_validation(4:end-1), -yW_validation(3:end-2), -yW_validation(2:end-3), -yW_validation(1:end-4), uW_validation(4:end-1), uW_validation(3:end-2), uW_validation(2:end-3), uW_validation(1:end-4)];
y_estym = [0; Phi_validation*p];
plot(t_validation(4:end), y_estym, 'b--');

y_estym_training = [0; Phi*p]


Gm = tf([p(5), p(6), p(7), p(8)], [1, p(1), p(2), p(3), p(4)], Tp)
ym = lsim(Gm, uW_validation, t_validation);
ym_training = lsim(Gm, uW_training, t_training);
plot(t_validation, ym, 'k--')
legend('y', 'y_{est}', 'y_m');

Ep = yW_validation(1:end-3)-y_estym;
Em = yW_validation - ym;

Vp = Ep'*Ep/(N*validation_dataset_percentage)
Vm=Em'*Em/(N*validation_dataset_percentage)

Ep_training = yW_training(1:end-3)-y_estym_training;
Em_training = yW_training - ym_training;

Vp_training = Ep_training'*Ep_training/(N*training_dataset_percent)
Vm_training=Em_training'*Em_training/(N*training_dataset_percent)

% P = Vp*(Phi'*Phi)^-1;
% PU95 = [p-1.96*sqrt(diag(P/N)), p+1.96*sqrt(diag(P/N))]; % przedziały ufności
% t =  0:.1:200;
figure;
step(Gm);