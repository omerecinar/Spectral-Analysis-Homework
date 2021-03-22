
load ecgtrain.dat  % Load training data
load ecgtest.dat  % Load test data
ecg_nsr=ecgtrain(:,1:20); 
ecg_sa=ecgtrain(:,41:55);
ecg_trinput=[ecg_nsr ecg_sa]; % E�itim seti= Training data=[Healthy1 Healthy2 ... Healthy20 Unhealthy1 Unhealthy2 ... Unhealthy15]

ecg_nsr_test=ecgtest(:,1:20);
ecg_sa_test=ecgtest(:,31:45);
ecg_testinput=[ecg_nsr ecg_sa]; % Test seti=Test data=[Healthy1 Healthy2 ... Healthy20 Unhealthy1 Unhealthy2 ... Unhealthy15]

%============================================

% Bir Normal Sin�s Ritmi patterninin �izdirilmesi---Plotting a healthy pattern (a RR interval of healthy ECG signal)
figure(1)
subplot(2,1,1);plot(ecg_nsr(:,1))
title('EKG Sinyali - Normal Sin�s Ritmi')
xlabel('Zaman (sn)')
ylabel('Genlik (Volt)')

%============================================

% Bir Sin�s Aritmisi patterninin �izdirilmesi ---Plotting an unhealthy pattern (a RR interval of unhealthy ECG signal)

subplot(2,1,2);plot(ecg_sa(:,1))
title('EKG Sinyali - Sin�s Aritmisi')
xlabel('Zaman (sn)')
ylabel('Genlik (Volt)')

%============================================

% EKG' NIN PSD' sinin HESAPLAMASI--- Calculation of power spectrum density of ECG signals (in training and test sets)

for i=1:size(ecg_nsr,2)
psd_nsr(:,i)=pwelch(ecg_nsr(:,i),51,50,[],360)
end

for i=1:size(ecg_sa,2)
psd_sa(:,i)=pwelch(ecg_sa(:,i),51,50,[],360); % pwelch(x,51,50,NFFT,Fs,'twosided') %============================================
end


for i=1:size(ecg_nsr,2)
psd_nsr_test(:,i)=pwelch(ecg_nsr_test(:,i),51,50,[],360)
end

for i=1:size(ecg_sa,2)
psd_sa_test(:,i)=pwelch(ecg_sa_test(:,i),51,50,[],360); % pwelch(x,51,50,NFFT,Fs,'twosided') %============================================
end
% ================================================
% PSD sonu�lar�n�n YSA i�in haz�rlanmas�- Normalization of ECG signal's PSD for NN

train_input1=[psd_nsr psd_sa];
for i=1:35
    train_input(:,i)=(train_input1(:,i)-min(train_input1(:,i)))/(max(train_input1(:,i))-min(train_input1(:,i)));
end

test_input1=[psd_nsr_test psd_sa_test];
for i=1:35
    test_input(:,i)=(test_input1(:,i)-min(test_input1(:,i)))/(max(test_input1(:,i))-min(test_input1(:,i)));
end

%============================================

% E�itim hedeflerinin YSA i�in haz�rlanmas� - Preparation of training targets
train_hedef=zeros(1,35);
train_hedef(1,1:20)=1;
train_hedef(1,21:35)=2;

% Test hedeflerinin YSA i�in haz�rlanmas� - Preparation of test targets
test_hedef=zeros(1,35);
test_hedef(1,1:20)=1;
test_hedef(1,21:35)=2;

% ===================================================================================================

% Yapay sinir agina EKG' nin sunulmasi ve egitme - Presentation of normalized PSD signals to NN

rand('state',0);
net=newff(minmax(train_input),[5 1],{'logsig','purelin'},'traingdx'); %[10 1]=[Number of Hidden nodes Number of output nodes]   {'logsig','logsig'}={"Activation function of hidden layer", "Activation function of output layer"}
net.trainParam.epochs = 1000; % Maximum iteration number
net.trainParam.goal = 0;
net.trainParam.time=inf;
net.trainParam.max_fail=5;
net.trainParam.min_grad = 1e-20; % Minimum MSE error between two iterations
net.trainParam.lr=2.0; % Learning rate ,[0 10]
net.trainParam.mc=0.9;% Momentum constant, [0 1]

[net,tr]=train(net,train_input,train_hedef);
out=sim(net,train_input); % Egitilen YSA' da girisin sim�le edilmesi ve training �ikislarin �retilmesi---Production of training results

out_test=sim(net,test_input);% Egitilen YSA' da girisin sim�le edilmesi ve test �ikislarin �retilmesi---Production of test results

% =========================================================================

% S�n�fland�rma sonucunun de�erlendirilmesi --- Assessment of classification results

% E��T�M--- Training

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
        % k2=SA 'li periyotlar�n say�s� 
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
        % k2t=SA 'li periyotlar�n say�s� 
    else
        kxt=kxt+1;
        % Yanl�� s�n�flanan periyotlar�n say�s�
    end
end   

Kt=k1t+k2t+kxt;

t=toc; %Program s�resini t de�i�kenine atar

% =========================================================================

