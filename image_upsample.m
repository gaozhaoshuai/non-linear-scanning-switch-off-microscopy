
%%%%%%矩阵数据的扩充
%%%%%%数据输入格式：【扩充后的矩阵】=image_upsample（要扩充的数据，需要扩充到的行维度）


function [data_upsample]=image_upsample(image,kama)

[M,N]=size(image);
kama_x=kama/N;
kama_y=kama/M;
y=1:M;  x=1:N;  [X,Y]=meshgrid(x,y);
% f = fspecial('gaussian',[3 3],0.5); %高斯模板
% image1_smooth = imfilter(image,f,'same');%高斯滤波
% subplot(221);imshow(image1_smooth);
yi=1:(M-1)/(kama_x.*M-1):M;
xi=1:(N-1)/(kama_y.*N-1):N;
[XI,YI]=meshgrid(xi,yi);
data_upsample=interp2(X,Y,image,XI,YI,'cubic');% 双立方插值进行图像的上采样
end
