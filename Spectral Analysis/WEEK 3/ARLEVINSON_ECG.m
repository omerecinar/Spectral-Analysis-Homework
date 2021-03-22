

% AR parametrelelerinin Levinson Metodu ile hesaplanmas�(levinson)

clear all
clc

% EKG Sinyali

tic % S�re tutulmaya ba�lan�r

%============================================

load ecgtrain.dat
load ecgtest.dat
ecg_nsr=ecgtrain(:,1:20);
ecg_afib=ecgtrain(:,107:121);

ecg_nsr_test=ecgtest(:,1:20);
ecg_afib_test=ecgtest(:,93:107);

%============================================

% Sinyal-1 Normal Sin�s Ritmi
figure(1)
subplot(2,1,1);plot(ecg_nsr(:,1))
title('EKG Sinyali - Normal Sin�s Ritmi')
xlabel('Zaman (sn)')
ylabel('Genlik (Volt)')

%============================================

% Sinyal-2  Atrial Fibrilasyon

subplot(2,1,2);plot(ecg_afib(:,1))
title('EKG Sinyali - Atrial Fibrilasyon')
xlabel('Zaman (sn)')
ylabel('Genlik (Volt)')

%============================================

% ECG sinyalinin AR parametreleri ile PSD' sinin �izdirilmesi

% E��T�M verileri i�in AR parametrelerinin hesaplanmas�

for i=1:size(ecg_nsr,2)
    corr_coef_nsr(:,i)=autocorr(ecg_nsr(:,i),4);
    ar_nsr(:,i)=levinson(corr_coef_nsr(:,i),4); % ECG sinyali i�in 4.dereceden AR parametleri-Normal sin�s ritmi
end
Hs=spectrum.yulear(4);figure(2)                     % 4th order AR model
subplot(2,1,1);psd(Hs,ecg_nsr(:,1),'NFFT',512);title('NSR i�in PSD')


for i=1:size(ecg_afib,2)
    corr_coef_afib(:,i)=autocorr(ecg_afib(:,i),4);
    ar_afib(:,i)=levinson(corr_coef_afib(:,i),4); % ECG sinyali i�in 4.dereceden AR parametleri- Sa� dal bloku
end
Hs=spectrum.yulear(4);                   % 4th order AR model
subplot(2,1,2);psd(Hs,ecg_afib(:,i),'NFFT',512);title('AF�B i�in PSD')

% TEST verileri i�in AR parametrelerinin hesaplanmas�
for i=1:size(ecg_nsr_test,2)
    corr_coef_nsr_test(:,i)=autocorr(ecg_nsr_test(:,i),4);
    ar_nsr_test(:,i)=levinson(corr_coef_nsr_test(:,i),4); % ECG sinyali i�in 4.dereceden AR parametleri-Normal sin�s ritmi
end
for i=1:size(ecg_afib_test,2)
    corr_coef_afib_test(:,i)=autocorr(ecg_afib(:,i),4);
    ar_afib_test(:,i)=levinson(corr_coef_afib_test(:,i),4); % ECG sinyali i�in 4.dereceden AR parametleri- Sa� dal bloku
end

%============================================

% Bu AR parametreleri kullan�larak sinyalin s�n�fland�r�lmas�
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
out=sim(net,train_input); % Egitilen YSA' da girisin sim�le edilmesi ve �ikislarin �retilmesi

out_test=sim(net,test_input);

% =========================================================================

% S�n�fland�rma sonucunun de�erlendirilmesi

% E��T�M

clear nor
clear r

nor=out(1,1:20);
r=out(1,21:35);

k1=0;k2=0;kx=0;K=0;

for k=1:size(nor,2);
    if out(1,k)<0.5 
        k1=k1+1;
        % k1=normal periyotlar�n say�s� 
    else
        kx=kx+1;
        % Yanl�� s�n�flanan periyotlar�n say�s�
    end
end  

for k=(size(nor,2)+1):(size(out,2));
    if out(1,k)>=0.5 
        k2=k2+1;
        % k2=Afib 'li periyotlar�n say�s� 
    else
        kx=kx+1;
        % Yanl�� s�n�flanan periyotlar�n say�s�
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
        % k1t=normal periyotlar�n say�s� 
    else
        kxt=kxt+1;
        % Yanl�� s�n�flanan periyotlar�n say�s�
    end
end  

for k=(size(nort,2)+1):(size(out_test,2));
    if out_test(1,k)>=0.5 
        k2t=k2t+1;
        % k2t=AFib 'li periyotlar�n say�s� 
    else
        kxt=kxt+1;
        % Yanl�� s�n�flanan periyotlar�n say�s�
    end
end   

Kt=k1t+k2t+kxt;

t=toc; %Program s�resini t de�i�kenine atar

% =========================================================================



