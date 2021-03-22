clear all
clc

% EKG Sinyali

tic % Süre tutulmaya baþlanýr

%============================================

load ecgtrain.dat
load ecgtest.dat
ecg_nsr=ecgtrain(:,1:20);
ecg_rbb=ecgtrain(:,77:91);

ecg_nsr_test=ecgtest(:,1:20);
ecg_rbb_test=ecgtest(:,63:77);

%============================================

% Sinyal-1 Normal Sinüs Ritmi
figure(1)
subplot(2,1,1);plot(ecg_nsr(:,1))
title('EKG Sinyali - Normal Sinüs Ritmi')
xlabel('Zaman (sn)')
ylabel('Genlik (Volt)')

%============================================

% Sinyal-2  Sað dal bloku

subplot(2,1,2);plot(ecg_rbb(:,1))
title('EKG Sinyali - Sað dal bloku')
xlabel('Zaman (sn)')
ylabel('Genlik (Volt)')

%============================================

% ECG sinyalinin AR parametreleri ile PSD' sinin çizdirilmesi

% AR parametrelerinin "Burg" metodu ile hesaplanmasý

for i=1:size(ecg_nsr,2)
    ar_nsr_cov(:,i)=arburg(ecg_nsr(:,i),4); % ECG sinyali için 4.dereceden AR parametleri-Normal sinüs ritmi
end
Hs=spectrum.burg(4);figure(2)                     % 4th order AR model
subplot(2,1,1);psd(Hs,ecg_nsr(:,1),'NFFT',512);title('NSR için PSD')

for i=1:size(ecg_rbb,2)
    ar_rbb_cov(:,i)=arburg(ecg_rbb(:,i),4); % ECG sinyali için 4.dereceden AR parametleri- Sað dal bloku
end
Hs=spectrum.burg(4);                   % 4th order AR model
subplot(2,1,2);psd(Hs,ecg_rbb(:,i),'NFFT',512);title('RBB için PSD')


% AR parametrelerinin "YULE-WALKER" metodu ile hesaplanmasý

for i=1:size(ecg_nsr,2)
    ar_nsr_yule(:,i)=aryule(ecg_nsr(:,i),4); % ECG sinyali için 4.dereceden AR parametleri-Normal sinüs ritmi
end
Hs=spectrum.yulear(4);figure(3)                     % 4th order AR model
subplot(2,1,1);psd(Hs,ecg_nsr(:,1),'NFFT',512);title('NSR için PSD')

for i=1:size(ecg_rbb,2)
    ar_rbb_yule(:,i)=aryule(ecg_rbb(:,i),4); % ECG sinyali için 4.dereceden AR parametleri- Sað dal bloku
end
Hs=spectrum.yulear(4);                   % 4th order AR model
subplot(2,1,2);psd(Hs,ecg_rbb(:,i),'NFFT',512);title('RBB için PSD')

%============================================

% AIC ve FPE kriterleri ile model belirleme

[th,ref]=ar(ecg_nsr(:,1),4,'yw')
kriter_aic_yw=aic(th)
kriter_fpe_yw=fpe(th)

[th,ref]=ar(ecg_nsr(:,1),4,'burg')
kriter_aic_burg=aic(th)
kriter_fpe_burg=fpe(th)

%============================================


