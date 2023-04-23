clc;clear;close all;
% % scanning the sample with nSSM PSF
%% load the light spot
nSSM=double(imread('nSSM.tif'));%pixel size 10 nm

[nSSM]=image_upsample(nSSM,200);%pixel size 10 nm
gauss=double(imread('gauss.tif'));%pixel size 10 nm
%% generate sample 
sample=zeros(200);%样品的大小10微米
sample(117:122,97:102)=100;
sample(97:102,117:122)=100;
sample(117:122,117:122)=100;
sample(77:82,97:102)=100;
sample(97:102,77:82)=100;
sample(77:82,77:82)=100;
sample(117:122,77:82)=100;
sample(77:82,117:122)=100;


nSSM_hor=conv2(sample,nSSM,'same');
nSSM_hor=nSSM_hor./max(max(nSSM_hor));

nSSM=nSSM';
nSSM_ver=conv2(sample,nSSM,'same');
nSSM_ver=nSSM_ver./max(max(nSSM_ver));

Confocal=conv2(sample,gauss,'same');
Confocal=Confocal./max(max(Confocal));

figure(1);
pcolor(sample);shading flat;axis equal off;title('sample,2 um');colormap(gray);
figure(2);
subplot(121),pcolor(nSSM_hor);shading flat;axis equal off;title('nSSM_hor');colormap(gray);
subplot(122),pcolor(nSSM_ver);shading flat;axis equal off;title('nSSM_ver');colormap(gray);
figure(3);
pcolor(Confocal);shading flat;axis equal off;title('Confocal');colormap(gray);

imwrite(sample,'sample.tif');
imwrite(nSSM_ver,'nSSM_ver.tif');
imwrite(nSSM_hor,'nSSM_hor.tif');
imwrite(Confocal,'Confocal.tif');


