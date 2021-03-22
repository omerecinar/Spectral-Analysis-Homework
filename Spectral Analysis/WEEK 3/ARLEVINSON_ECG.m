

% AR parametrelelerinin Levinson Metodu ile hesaplanmasý(levinson)

clear all
clc

% EKG Sinyali

tic % Süre tutulmaya baþlanýr

%============================================

load ecgtrain.dat
load ecgtest.dat
ecg_nsr=ecgtrain(:,1:20);
ecg_afib=ecgtrain(:,107:121);

ecg_nsr_test=ecgtest(:,1:20);
ecg_afib_test=ecgtest(:,93:107);

%============================================

% Sinyal-1 Normal Sinüs Ritmi
figure(1)
subplot(2,1,1);plot(ecg_nsr(:,1))
title('EKG Sinyali - Normal Sinüs Ritmi')
xlabel('Zaman (sn)')
ylabel('Genlik (Volt)')

%============================================

% Sinyal-2  Atrial Fibrilasyon

subplot(2,1,2);plot(ecg_afib(:,1))
title('EKG Sinyali - Atrial Fibrilasyon')
xlabel('Zaman (sn)')
ylabel('Genlik (Volt)')

%============================================

% ECG sinyalinin AR parametreleri ile PSD' sinin çizdirilmesi

% EÐÝTÝM verileri için AR parametrelerinin hesaplanmasý

for i=1:size(ecg_nsr,2)
    corr_coef_nsr(:,i)=autocorr(ecg_nsr(:,i),4);
    ar_nsr(:,i)=levinson(corr_coef_nsr(:,i),4); % ECG sinyali için 4.dereceden AR parametleri-Normal sinüs ritmi
end
Hs=spectrum.yulear(4);figure(2)                     % 4th order AR model
subplot(2,1,1);psd(Hs,ecg_nsr(:,1),'NFFT',512);title('NSR için PSD')


for i=1:size(ecg_afib,2)
    corr_coef_afib(:,i)=autocorr(ecg_afib(:,i),4);
    ar_afib(:,i)=levinson(corr_coef_afib(:,i),4); % ECG sinyali için 4.dereceden AR parametleri- Sað dal bloku
end
Hs=spectrum.yulear(4);                   % 4th order AR model
subplot(2,1,2);psd(Hs,ecg_afib(:,i),'NFFT',512);title('AFÝB için PSD')

% TEST verileri için AR parametrelerinin hesaplanmasý
for i=1:size(ecg_nsr_test,2)
    corr_coef_nsr_test(:,i)=autocorr(ecg_nsr_test(:,i),4);
    ar_nsr_test(:,i)=levinson(corr_coef_nsr_test(:,i),4); % ECG sinyali için 4.dereceden AR parametleri-Normal sinüs ritmi
end
for i=1:size(ecg_afib_test,2)
    corr_coef_afib_test(:,i)=autocorr(ecg_afib(:,i),4);
    ar_afib_test(:,i)=levinson(corr_coef_afib_test(:,i),4); % ECG sinyali için 4.dereceden AR parametleri- Sað dal bloku
end

%============================================

% Bu AR parametreleri kullanýlarak sinyalin sýnýflandýrýlmasý
train_input=[ar_nsr ar_afib];
train_hedef=zeros(1,35);
train_hedef(1,1:20)=0;
train_hedef(1,21:35)=1;

test_input=[ar_nsr_test ar_afib_test];
test_hedef=zeros(1,35);
test_hedef(1,1:20)=0;
test_hedef(1,21:35)=1;

rand('state',0);
net=newff(minmax(train_input),[10 1],{'logsig','logsig'},'traingdx');
net.trainParam.show = 200;
net.trainParam.epochs = 500;
net.trainParam.goal = 0;
net.trainParam.time=inf;
net.trainParam.max_fail=5;
net.trainParam.min_grad = 1e-20;
net.trainParam.lr=2.0;
net.trainParam.mc=0.9;
net.trainParam.delt_inc=1.0;
net.trainParam.delt_dec=0.5;
net.trainParam.delta0=0.07;
net.trainParam.deltamax=50.0;

[net,tr]=train(net,train_input,train_hedef);
out=sim(net,train_input); % Egitilen YSA' da girisin simüle edilmesi ve çikislarin üretilmesi

out_test=sim(net,test_input);

% =========================================================================

% Sýnýflandýrma sonucunun deðerlendirilmesi

% EÐÝTÝM

clear nor
clear r

nor=out(1,1:20);
r=out(1,21:35);

k1=0;k2=0;kx=0;K=0;

for k=1:size(nor,2);
    if out(1,k)<0.5 
        k1=k1+1;
        % k1=normal periyotlarýn sayýsý 
    else
        kx=kx+1;
        % Yanlýþ sýnýflanan periyotlarýn sayýsý
    end
end  

for k=(size(nor,2)+1):(size(out,2));
    if out(1,k)>=0.5 
        k2=k2+1;
        % k2=Afib 'li periyotlarýn sayýsý 
    else
        kx=kx+1;
        % Yanlýþ sýnýflanan periyotlarýn sayýsý
    end
end   

K=k1+k2+kx;

% TEST
clear nort
clear rt
clear k

nort=out_test(1,1:20);
rt=out_test(1,21:35);

k1t=0;k2t=0;kxt=0;Kt=0;

for k=1:size(nort,2);
    if out_test(1,k)<0.5 
        k1t=k1t+1;
        % k1t=normal periyotlarýn sayýsý 
    else
        kxt=kxt+1;
        % Yanlýþ sýnýflanan periyotlarýn sayýsý
    end
end  

for k=(size(nort,2)+1):(size(out_test,2));
    if out_test(1,k)>=0.5 
        k2t=k2t+1;
        % k2t=AFib 'li periyotlarýn sayýsý 
    else
        kxt=kxt+1;
        % Yanlýþ sýnýflanan periyotlarýn sayýsý
    end
end   

Kt=k1t+k2t+kxt;

t=toc; %Program süresini t deðiþkenine atar

% =========================================================================



