
%%%%%%�������ݵ�����
%%%%%%���������ʽ���������ľ���=image_upsample��Ҫ��������ݣ���Ҫ���䵽����ά�ȣ�


function [data_upsample]=image_upsample(image,kama)

[M,N]=size(image);
kama_x=kama/N;
kama_y=kama/M;
y=1:M;  x=1:N;  [X,Y]=meshgrid(x,y);
% f = fspecial('gaussian',[3 3],0.5); %��˹ģ��
% image1_smooth = imfilter(image,f,'same');%��˹�˲�
% subplot(221);imshow(image1_smooth);
yi=1:(M-1)/(kama_x.*M-1):M;
xi=1:(N-1)/(kama_y.*N-1):N;
[XI,YI]=meshgrid(xi,yi);
data_upsample=interp2(X,Y,image,XI,YI,'cubic');% ˫������ֵ����ͼ����ϲ���
end
