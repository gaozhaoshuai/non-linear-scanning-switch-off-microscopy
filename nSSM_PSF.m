clear;close all;clc
%% nSSM point spread function
PSF=load('2um_488_Gauss.txt');
[PSF]=image_upsample(PSF,100);
PSF=PSF(25:75,25:75);
[PSF]=image_upsample(PSF,100);%pixel size 10nm
PSF=PSF./max(max(PSF));%��˹���һ��
ex_sum=sum(sum(PSF));%��һ����ļ������ܹ���
[m,n]=size(PSF);
%% ��������ĳ�ʼ��
phi=(1:1:180)*1e4;%�������ֵ�ع����,����ÿƽ������
% phi=(0.02:1:1)*1e4;%�������ֵ�ع����,����ÿƽ������
% ������������6.2E-9ƽ������
t=1;%frame acquisition time,��
Iexc=phi/t;%�������ֵ����,��ÿƽ������

lambda=488e-7;  h=6.626e-34;  c=3.0e10;  sigama=1e-17;%�������ף����ʿ˳��������٣�����ÿ�룬���ս���,ƽ������
photon=Iexc*lambda/(h*c);%��ֵ����������ÿ��ÿƽ������
kexc=sigama*photon;%���õ�ӫ������ϵķ�ֵ������ÿ�룬����ѭ����
power=ex_sum*Iexc;%�������ܹ��ʣ���ÿƽ������
photon=power*lambda/(h*c);%�ܹ���������ÿ��ÿƽ������

bleached=zeros(m,n);
dt=1e-8;%pixel dwell time
tspan=[0 dt];
for kk=1:length(Iexc)
ex=kexc(kk).*PSF;
kk
tic
y0=[1,0,0];
for ii=1:m
%     tic
    for jj=1:n
       [t,y]=ode45('rate_eq',tspan,y0,[],ex(ii,jj));
       lent=size(y);
       bleached(ii,jj,kk)=y(lent(1),2);%y(lent(1),1);
       y0=[y(lent(1),1),y(lent(1),2),y(lent(1),3)]; 
    end
%     toc
end
eff(:,:,kk)=ex.*bleached(:,:,kk);
toc
end
pcolor(eff(:,:,150));axis equal off;title('nSSM');shading interp;colormap(jet)
xlabel('����������ÿ��ÿƽ�����ף�');
title('Power switch-off');axis square
save('eff.mat','eff');

