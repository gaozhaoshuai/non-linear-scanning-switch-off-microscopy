clear;close all;clc
%% nSSM point spread function
PSF=load('2um_488_Gauss.txt');
[PSF]=image_upsample(PSF,100);
PSF=PSF(25:75,25:75);
[PSF]=image_upsample(PSF,100);%pixel size 10nm
PSF=PSF./max(max(PSF));%高斯光归一化
ex_sum=sum(sum(PSF));%归一化后的激发光总功率
[m,n]=size(PSF);
%% 计算参数的初始化
phi=(1:1:180)*1e4;%激发光峰值曝光剂量,焦耳每平方厘米
% phi=(0.02:1:1)*1e4;%激发光峰值曝光剂量,焦耳每平方厘米
% 激发光斑面积：6.2E-9平方厘米
t=1;%frame acquisition time,秒
Iexc=phi/t;%激发光峰值功率,瓦每平方厘米

lambda=488e-7;  h=6.626e-34;  c=3.0e10;  sigama=1e-17;%波长厘米，普朗克常数，光速，厘米每秒，吸收截面,平方厘米
photon=Iexc*lambda/(h*c);%峰值光子流量，每秒每平方厘米
kexc=sigama*photon;%作用到荧光分子上的峰值光子数每秒，激发循环数
power=ex_sum*Iexc;%激发光总功率，瓦每平方厘米
photon=power*lambda/(h*c);%总光子流量，每秒每平方厘米

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
xlabel('光子流量（每秒每平方厘米）');
title('Power switch-off');axis square
save('eff.mat','eff');

