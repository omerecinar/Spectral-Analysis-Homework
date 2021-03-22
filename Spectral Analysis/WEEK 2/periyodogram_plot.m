
% PERÝYODORAM YÖNTEMLERÝNÝN ÝNCELENMESÝ

%============================================================

% Rectangular (default) Pencere ile Periyodogramlarýn Çizdirilmesi
randn('state',0);
Fs = 1000;
t = 0:1/Fs:.3; 
x = cos(2*pi*t*200)+0.1*randn(size(t));
figure(1);plot(t,x) 
Hs=spectrum.periodogram; % Eðer pencere tipi belirtilmediyse "dikdörtgen" dir.
figure(2);
psd(Hs,x,'Fs',Fs)

%============================================================

% Bartlett Yöntemi ile Periyodogramlarýn Çizdirilmesi

Hs=spectrum.periodogram('bartlett'); % Pencere tipi "Bartlett" olarak seçildi.
figure(3);
psd(Hs,x,'Fs',Fs)

%============================================================

% Welch Yöntemi ile Periyodogramlarýn Çizdirilmesi

Hs=spectrum.welch; % Welch  yönteminin seçilmesi
figure(3);
psd(Hs,x,'Fs',Fs)% Default overlap %50, default window:Hamming
figure(4)
Hs = spectrum.welch('Hamming',51,50)
psd(Hs,x,'Fs',Fs)% Default overlap %50, default window:Hamming

% % ayrýk olarak çizdirmek için
% s_psd=psd(Hs,x,'Fs',Fs);
% figure(5);stem(s_psd.Frequencies,s_psd.Data)

% PWELCH komutunun kullanýmý
randn('state',0);
Fs = 1000;   t = 0:1/Fs:.3;
x = cos(2*pi*t*200) + 0.1*randn(size(t));% 200Hz cos sinyali + gürültü
figure(5);
pwelch(x,31,30,[],Fs); % pwelch(x,31,30,[],Fs,'twosided') 

% NFFT yerine [] konulabilir, aþaðýdaki gibi hesaplanarak yazýladabilir
L=length(x); % Sinyalin uzunluðu
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
figure(6);
pwelch(x,31,30,NFFT,Fs); % pwelch(x,31,30,[],Fs,'twosided') 

%============================================================

% Burg Yöntemi ile Periyodogramlarýn Çizdirilmesi

% PBURG komutunun kullanýmý
randn('state',0);
Fs = 1000;   t = 0:1/Fs:.3;
x = cos(2*pi*t*200) + 0.1*randn(size(t));% 200Hz cos sinyali + gürültü
figure(5);
pburg(x,51,50,[],Fs); % pwelch(x,31,30,[],Fs,'twosided') 

