clear;close all;clc
%%%Eliminate the sidelobes

nSSM=double(imread('nSSM.tif'));%pixel size 10 nm

[nSSM]=image_upsample(nSSM,200);%pixel size 10 nm
gauss=double(imread('gauss.tif'));%pixel size 10 nm

kama=2;
%% load PSF
main=imread('main.tif');
main=main(:,:,1:3);
main=rgb2gray(main);
main=double(main);
[m,n]=size(main);
% main=main./max(max(main));
main=image_upsample(main,kama*m);
side=imread('side.tif');
side=side(:,:,1:3);
side=rgb2gray(side);
side=double(side);
[m,n]=size(side);
% side=main./max(max(side));
side=image_upsample(side,kama*m);
main_side=1.0*main-0.36*side;
% figure;
% subplot(131);pcolor(main_side);shading flat;axis equal off;colormap(jet);title('‘ÀÀ„PSF')
%% load image A
image=imread('nSSM_hor.tif');
% image=image(:,:,1:3);
% image=rgb2gray(image);
image=double(image);
image=image./max(max(image));
image=image_upsample(image,kama*m);


subplot(121);pcolor(image);shading flat;axis equal off;colormap(jet);title('input image')
%% eliminate the sidelobs
El_sidelobe=conv2(image,main_side,'same');
El_sidelobe=El_sidelobe./max(max(El_sidelobe));
El_sidelobe(El_sidelobe<0)=0;

El_sidelobe = deconvlucy(El_sidelobe, main, 5);
El_sidelobe = deconvlucy(El_sidelobe, gauss, 3);
El_sidelobe =El_sidelobe./max(max(El_sidelobe));

subplot(122);pcolor(El_sidelobe);shading flat;axis equal off;colormap(jet);title('eliminate sidelobes')
imwrite(El_sidelobe./max(max(El_sidelobe)),'de_hor.tif')
%% %% load image B
image=imread('nSSM_ver.tif');
% image=image(:,:,1:3);
% image=rgb2gray(image);
image=double(image);
image=image./max(max(image));
image=image_upsample(image,kama*m);
figure
subplot(121);pcolor(image);shading flat;axis equal off;colormap(jet);title('input image')
%% eliminate the sidelobs
El_sidelobe=conv2(image,main_side','same');
El_sidelobe=El_sidelobe./max(max(El_sidelobe));
El_sidelobe(El_sidelobe<0)=0;
main=main';
El_sidelobe = deconvlucy(El_sidelobe, main,5);
El_sidelobe = deconvlucy(El_sidelobe, gauss, 3);
El_sidelobe =El_sidelobe./max(max(El_sidelobe));

subplot(122);pcolor(El_sidelobe);shading flat;axis equal off;colormap(jet);title('eliminate sidelobes')
imwrite(El_sidelobe./max(max(El_sidelobe)),'de_ver.tif')
