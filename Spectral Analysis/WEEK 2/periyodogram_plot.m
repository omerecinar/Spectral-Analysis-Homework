
% PER�YODORAM Y�NTEMLER�N�N �NCELENMES�

%============================================================

% Rectangular (default) Pencere ile Periyodogramlar�n �izdirilmesi
randn('state',0);
Fs = 1000;
t = 0:1/Fs:.3; 
x = cos(2*pi*t*200)+0.1*randn(size(t));
figure(1);plot(t,x) 
Hs=spectrum.periodogram; % E�er pencere tipi belirtilmediyse "dikd�rtgen" dir.
figure(2);
psd(Hs,x,'Fs',Fs)

%============================================================

% Bartlett Y�ntemi ile Periyodogramlar�n �izdirilmesi

Hs=spectrum.periodogram('bartlett'); % Pencere tipi "Bartlett" olarak se�ildi.
figure(3);
psd(Hs,x,'Fs',Fs)

%============================================================

% Welch Y�ntemi ile Periyodogramlar�n �izdirilmesi

Hs=spectrum.welch; % Welch  y�nteminin se�ilmesi
figure(3);
psd(Hs,x,'Fs',Fs)% Default overlap %50, default window:Hamming
figure(4)
Hs = spectrum.welch('Hamming',51,50)
psd(Hs,x,'Fs',Fs)% Default overlap %50, default window:Hamming

% % ayr�k olarak �izdirmek i�in
% s_psd=psd(Hs,x,'Fs',Fs);
% figure(5);stem(s_psd.Frequencies,s_psd.Data)

% PWELCH komutunun kullan�m�
randn('state',0);
Fs = 1000;   t = 0:1/Fs:.3;
x = cos(2*pi*t*200) + 0.1*randn(size(t));% 200Hz cos sinyali + g�r�lt�
figure(5);
pwelch(x,31,30,[],Fs); % pwelch(x,31,30,[],Fs,'twosided') 

% NFFT yerine [] konulabilir, a�a��daki gibi hesaplanarak yaz�ladabilir
L=length(x); % Sinyalin uzunlu�u
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
figure(6);
pwelch(x,31,30,NFFT,Fs); % pwelch(x,31,30,[],Fs,'twosided') 

%============================================================

% Burg Y�ntemi ile Periyodogramlar�n �izdirilmesi

% PBURG komutunun kullan�m�
randn('state',0);
Fs = 1000;   t = 0:1/Fs:.3;
x = cos(2*pi*t*200) + 0.1*randn(size(t));% 200Hz cos sinyali + g�r�lt�
figure(5);
pburg(x,51,50,[],Fs); % pwelch(x,31,30,[],Fs,'twosided') 

