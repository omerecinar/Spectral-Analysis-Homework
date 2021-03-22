
% PCA ve YSA ILE EKG ARITMILERINI SINIFLANDIRMA

clear all
clc;

% EKG Sinyali

tic % Süre tutulmaya baþlanýr

%============================================

load ecgtrain.dat
load ecgtest.dat
ecg_nsr=ecgtrain(:,1:20);
ecg_sa=ecgtrain(:,41:55);
ecg_trinput=[ecg_nsr ecg_sa];

ecg_nsr_test=ecgtest(:,1:20);
ecg_sa_test=ecgtest(:,31:45);
ecg_testinput=[ecg_nsr ecg_sa];

%============================================

% Sinyal-1 Normal Sinüs Ritmi
figure(1)
subplot(2,1,1);plot(ecg_nsr(:,1))
title('EKG Sinyali - Normal Sinüs Ritmi')
xlabel('Zaman (sn)')
ylabel('Genlik (Volt)')

%============================================

% Sinyal-2  Sinüs Aritmisi

subplot(2,1,2);plot(ecg_sa(:,1))
title('EKG Sinyali - Sinüs Aritmisi')
xlabel('Zaman (sn)')
ylabel('Genlik (Volt)')

%============================================

% EKG' NIN WAVELET ILE AZALTILMASI
CA=zeros(101,35);
CD=zeros(101,35);
for i=1:35
    [CA(:,i),CD(:,i)]=dwt(ecg_trinput(:,i),'db2');
end

CA_test=zeros(101,35);
CD_test=zeros(101,35);
for i=1:35
    [CA_test(:,i),CD_test(:,i)]=dwt(ecg_testinput(:,i),'db2');
end

%============================================
% Wavelet sonucunda elde edilen yaklaþým katsayýlarýnýn çizdirilmesi

%Sinyal-1 Normal Sinüs Ritmi
figure(2)
subplot(2,1,1);plot(CA(:,1))
title('EKG Sinyalinin Wavelet Transformu - Normal Sinüs Ritmi')
xlabel('Zaman (sn)')
ylabel('Genlik (Volt)')

%Sinyal-1 Normal Sinüs Ritmi
figure(2)
subplot(2,1,2);plot(CA(:,21))
title('EKG Sinyalinin Wavelet Transformu - Sað Dal Bloku')
xlabel('Zaman (sn)')
ylabel('Genlik (Volt)')

%============================================

% WT sonuçlarýnýn YSA için hazýrlanmasý

train_input1=CA;
for i=1:35
    train_input(:,i)=(train_input1(:,i)-min(train_input1(:,i)))/(max(train_input1(:,i))-min(train_input1(:,i)));
end

test_input1=CA_test;
for i=1:35
    test_input(:,i)=(test_input1(:,i)-min(test_input1(:,i)))/(max(test_input1(:,i))-min(test_input1(:,i)));
end

%============================================

% Eðitim hedeflerinin YSA için hazýrlanmasý
train_hedef=zeros(1,35);
train_hedef(1,1:20)=1;
train_hedef(1,21:35)=2;

% Test hedeflerinin YSA için hazýrlanmasý
test_hedef=zeros(1,35);
test_hedef(1,1:20)=1;
test_hedef(1,21:35)=2;

% ===================================================================================================

% Yapay sinir agina EKG' nin sunulmasi ve egitme 

rand('state',0);
net=newff(minmax(train_input),[10 1],{'logsig','purelin'},'traingdx');
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
    if out(1,k)>=0.5 & out(1,k)<1.5 
        k1=k1+1;
        % k1=normal periyotlarýn sayýsý 
    else
        kx=kx+1;
        % Yanlýþ sýnýflanan periyotlarýn sayýsý
    end
end  

for k=(size(nor,2)+1):(size(out,2));
    if out(1,k)>=1.5
        k2=k2+1;
        % k2=SA 'li periyotlarýn sayýsý 
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
    if out_test(1,k)>=0.5 & out_test(1,k)<1.5 
        k1t=k1t+1;
        % k1t=normal periyotlarýn sayýsý 
    else
        kxt=kxt+1;
        % Yanlýþ sýnýflanan periyotlarýn sayýsý
    end
end  

for k=(size(nort,2)+1):(size(out_test,2));
    if out_test(1,k)>=1.5
        k2t=k2t+1;
        % k2t=SA 'li periyotlarýn sayýsý 
    else
        kxt=kxt+1;
        % Yanlýþ sýnýflanan periyotlarýn sayýsý
    end
end   

Kt=k1t+k2t+kxt;

t=toc; %Program süresini t deðiþkenine atar

% =========================================================================

% PCA sonucunda elde edilen temel bileþenlerin çizimi

% figure(2);newdatax=abs(newdata_inp);
% plot(newdatax(1,1:20),newdatax(2,1:20),'+');
% hold on;
% plot(newdatax(1,21:35),newdatax(2,21:35),'r*');

% =========================================================================