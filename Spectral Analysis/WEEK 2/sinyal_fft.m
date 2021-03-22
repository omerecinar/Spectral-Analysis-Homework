
% �K� S�N�ZO�D�N TOPLAMINDAN OLU�AN S�NYALDE FFT ��Z�M�

% Sinyalin form�le edilmesi

Fs = 1000;                    % �rnekleme frekans�
T = 1/Fs;                     % �rnekleme periyodu
L = 1000;                     % Sinyalin uzunlu�u
t = (0:L-1)*T;                % Time vector
% Sinyalimizi 50 Hz ve 120 Hz' lik iki sin�zoidalin toplam� ise
x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t); 
y = x + 2*randn(size(t));     % Random fonksiyonu g�r�lt� fonksiyonudur
figure(1)
plot(Fs*t(1:50),y(1:50))
title('G�r�lt� ile bozuluma u�ram�� sinyaller')
xlabel('Zaman (milisaniye)')
ylabel('Genlik (Volt)')

% Sinyalin FFT' sinin al�nmas�
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
figure(2);
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

% Sinyalin g�r�lt� eklenmemi� halinin FFT' si
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
X = fft(x,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
figure(3);
plot(f,2*abs(X(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
