clear;clc;close all;kama=2;
%Reconstructure the image from two images
%% load image 1
nSSM_ver=imread('de_ver.tif'); 
nSSM_ver=nSSM_ver(:,:,1);
nSSM_ver=im2double(nSSM_ver);
[M,N]=size(nSSM_ver);
% f = fspecial('gaussian',[3 3],0.5); 
% image1_smooth = imfilter(image_gray1,f,'same');%Gaussian filter
% nSSM_ver=nSSM_ver;
figure;subplot(231);pcolor(nSSM_ver);title('Horizontal');shading flat;axis equal off;
nSSM_ver=image_upsample(nSSM_ver,kama*N);
nSSM_ver=nSSM_ver./max(max(nSSM_ver));
de_overlay=zeros(kama*N,kama*N,3);
de_overlay(:,:,1)=nSSM_ver;
nSSM_ver_fft=fft2(nSSM_ver);
%% load image 2
nSSM_hor=imread('de_hor.tif'); 
% image2=image2(:,:,1:3);
% image2_gray=rgb2gray(image2);
nSSM_hor=im2double(nSSM_hor);
nSSM_hor=image_upsample(nSSM_hor,kama*N);
nSSM_hor=nSSM_hor./max(max(nSSM_hor));

de_overlay(:,:,2)=nSSM_hor;
% image_gray2=im2double(image2);
% image2_smooth = imfilter(image_gray2,f,'same');%Gaussian filter 
subplot(232);pcolor(nSSM_hor);title('Vertical');shading flat;axis equal off;
nSSM_hor_fft=fft2(nSSM_hor);
%% caculate the correlation
correlation=ifft2(nSSM_ver_fft.*conj(nSSM_hor_fft));
correlation1=fftshift(correlation);
correlation1=imresize(correlation1,[M,N]);
subplot(233);pcolor(correlation1);title('Correlation');
axis equal off;shading flat;
%% shift
max_value=max(max(correlation));
[row,col]=find(max_value==correlation);
if row<=0.5*M*kama && col<=0.5*N*kama
    xshift_col=-col
    yshift_row=-row
elseif row<=0.5*M*kama && col>0.5*N*kama
    xshift_col=N*kama-col
    yshift_row=-row
elseif row>0.5*M*kama && col<=0.5*N*kama
    xshift_col=-col
    yshift_row=M*kama-row
elseif row>0.5*M*kama && col>0.5*N*kama
    xshift_col=N*kama-col
    yshift_row=M*kama-row    
end
overlay=zeros(kama*M+2.*abs(yshift_row),kama*N+2.*abs(xshift_col),3);
overlay((1:kama*M)+abs(yshift_row),(1:kama*N)+abs(xshift_col),2)=1.2.*abs(nSSM_ver);
overlay((1:kama*M)+abs(yshift_row)-yshift_row,(1:kama*N)+abs(xshift_col)-xshift_col,1)=1.2.*abs((nSSM_hor));
extend_xyz_overlay=imresize(overlay,[M+2.*abs(yshift_row)./kama,N+2.*abs(xshift_col)./kama]);
subplot(234);imshow(overlay);axis on;axis equal off;title('Shift Correction')
% imwrite(extend_xyz_overlay,'overlay.tif');
%% Fourier transform 
nSSM_hor=fft2(overlay(:,:,1));          
nSSM_ver=fft2(overlay(:,:,2));          

temp=abs(nSSM_hor)-abs(nSSM_ver);
temp(temp>0)=1;temp(temp<0)=0;
fusion_fft1=temp.*nSSM_hor;

temp=abs(nSSM_ver)-abs(nSSM_hor);
temp(temp>0)=1;temp(temp<0)=0;
fusion_fft2=temp.*nSSM_ver;

fusion_fft=fusion_fft1+fusion_fft2;

fusion_fft=ifft2(fusion_fft);
fusion_fft(fusion_fft<0)=0;
fusion_fft=fusion_fft./max(max(fusion_fft));
% figure;pcolor(fusion_fft);shading interp;axis equal off;colormap(hot);title('Fourier maximum ')
%% spatial
nSSM_hor=overlay(:,:,1);         
nSSM_ver=overlay(:,:,2);          
temp=nSSM_hor-nSSM_ver;
temp(temp>0)=1;temp(temp<0)=0;
fusion_spa1=temp.*nSSM_ver;
temp=nSSM_ver-nSSM_hor;
temp(temp>0)=1;temp(temp<0)=0;
fusion_spa2=temp.*nSSM_hor;
fusion_spa=fusion_spa1+fusion_spa2;
fusion=(fusion_spa+fusion_fft)/2;

% figure;pcolor(fusion_spa);shading interp;axis equal off;colormap(hot);title('spatial minimum ')
subplot(235);pcolor(fusion);shading flat;axis equal off;colormap(hot);title('Reconstruction');caxis([0.25 1.0])

imwrite(fusion./max(max(fusion)),'fusion.tif');
