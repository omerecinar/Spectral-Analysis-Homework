
% PERİYODORAM YÖNTEMLERİNİN İNCELENMESİ

%============================================================

% Rectangular (default) Pencere ile Periyodogramların Çizdirilmesi
randn('state',0);
Fs = 1000;
t = 0:1/Fs:.3; 
x = cos(2*pi*t*200)+0.1*randn(size(t));
figure(1);plot(t,x) 
Hs=spectrum.periodogram; % Eğer pencere tipi belirtilmediyse "dikdörtgen" dir.
figure(2);
psd(Hs,x,'Fs',Fs)

%============================================================

% Bartlett Yöntemi ile Periyodogramların Çizdirilmesi

Hs=spectrum.periodogram('bartlett'); % Pencere tipi "Bartlett" olarak seçildi.
figure(3);
psd(Hs,x,'Fs',Fs)

%============================================================

% Welch Yöntemi ile Periyodogramların Çizdirilmesi

Hs=spectrum.welch; % Welch  yönteminin seçilmesi
figure(3);
psd(Hs,x,'Fs',Fs)% Default overlap %50, default window:Hamming
figure(4)
Hs = spectrum.welch('Hamming',51,50)
psd(Hs,x,'Fs',Fs)% Default overlap %50, default window:Hamming

% % ayrık olarak çizdirmek için
% s_psd=psd(Hs,x,'Fs',Fs);
% figure(5);stem(s_psd.Frequencies,s_psd.Data)

% PWELCH komutunun kullanımı
randn('state',0);
Fs = 1000;   t = 0:1/Fs:.3;
x = cos(2*pi*t*200) + 0.1*randn(size(t));% 200Hz cos sinyali + gürültü
figure(5);
pwelch(x,31,30,[],Fs); % pwelch(x,31,30,[],Fs,'twosided') 

% NFFT yerine [] konulabilir, aşağıdaki gibi hesaplanarak yazıladabilir
L=length(x); % Sinyalin uzunluğu
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
figure(6);
pwelch(x,31,30,NFFT,Fs); % pwelch(x,31,30,[],Fs,'twosided') 

%============================================================

% Burg Yöntemi ile Periyodogramların Çizdirilmesi

% PBURG komutunun kullanımı
randn('state',0);
Fs = 1000;   t = 0:1/Fs:.3;
x = cos(2*pi*t*200) + 0.1*randn(size(t));% 200Hz cos sinyali + gürültü
figure(5);
pburg(x,51,50,[],Fs); % pwelch(x,31,30,[],Fs,'twosided') 

