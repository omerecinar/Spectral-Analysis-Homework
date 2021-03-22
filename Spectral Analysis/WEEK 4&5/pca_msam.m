function [newdata,eigvector,eigvalue]=pca_msam(data,p)

rand('state',0);

% data=azaltilacak giris datasi    eigvector_n=azaltilacak sayi, data=[egitim_giris test_giris]
N=size(data,1);
mean_data=mean(data,1);mean_data=mean_data.';
data=data-(repmat(mean_data,1,N)).';
covariance=(1/(N-1))*data*(data');
[eigvector1, d] = eig(covariance);% özvektörleri ve diagonal matrisi hesapliyor
eigvalue = diag(d);

% ===================================================================================
%%% sort komutunun kullanilmasinin amaci hesaplanan eigen vektörü içerisindeki 
%%% eigen degerlerini büyükten küçüge dogru siralayarak en yüksek eigen degerlerinden
%%% seçmek, böylece principal componentleri belirlemek
[junk, index] = sort(-eigvalue);
eigvalue = eigvalue(index);
eigvector = eigvector1(:, index);	% Eigenvectors of A*A^T
% ====================================================================================

% eigvector = eigvector*diag(1./(sum(eigvector.^2).^0.5)); % Normalizasyon

if p < size(data, 1),
	eigvalue = eigvalue(1:p);
	eigvector = eigvector(:, 1:p);% ilk p adet eigenvector'ü seçiyor. 
end

newdata = eigvector'*data; % p adet temel bileþenle yeni veriyi elde ediyor.Böylece data azaltilmis oluyor
