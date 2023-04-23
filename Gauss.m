clc;clear;close all;
%%%  calculate the excitation laser spot with high numberical aperture

pixel=50;
syms theta phi;
n=1.5;
NA=1.4;
lambda=0.488;%波长单位是微米
k=2.*pi./lambda;
z2=0;%焦点处

dx=0.3./pixel;
x=-0.30:dx:0.30;
x(x==0)=eps;
y=-0.3:dx:0.3;

lenx=length(x);leny=length(y);

Ex=zeros(lenx,leny);
Ey=zeros(lenx,leny);
Ez=zeros(lenx,leny);

tic
for ii=1:lenx          
    parfor jj=1:leny
        r2=sqrt(x(ii).^2+y(jj).^2);
        phi2=atan(y(jj)./x(ii));

        % 高斯光斑
        FEx=@(theta,phi)sin(theta).*sqrt(cos(theta)).*((2^(1/2)*((cos(theta) - 1)*cos(phi)^2 + 1))/2 + (2^(1/2)*cos(phi)*sin(phi)*(cos(theta) - 1)*i)/2).*exp(i.*k.*n.*(z2.*cos(theta)+r2.*sin(theta).*cos(phi-phi2)));
        FEy=@(theta,phi)sin(theta).*sqrt(cos(theta)).*((2^(1/2)*((cos(theta) - 1)*sin(phi)^2 + 1)*i)/2 + (2^(1/2)*cos(phi)*sin(phi)*(cos(theta) - 1))/2).*exp(i.*k.*n.*(z2.*cos(theta)+r2.*sin(theta).*cos(phi-phi2)));
        FEz=@(theta,phi)sin(theta).*sqrt(cos(theta)).*((2^(1/2)*cos(phi)*sin(theta))/2 + (2^(1/2)*sin(phi)*sin(theta)*i)/2).*exp(i.*k.*n.*(z2.*cos(theta)+r2.*sin(theta).*cos(phi-phi2)));         
        Ex(ii,jj)=dblquad(FEx,0,asin(NA./n),0,2.*pi);
        Ey(ii,jj)=dblquad(FEy,0,asin(NA./n),0,2.*pi);
        Ez(ii,jj)=dblquad(FEz,0,asin(NA./n),0,2.*pi);
    end
            
end
toc

E=(abs(i.*Ex)).^2+(abs(i.*Ey)).^2+(abs(i.*Ez)).^2;
en=E./max(max(E));

pcolor(y,x,en);colormap(hot);shading flat;axis equal;
% imwrite(en,'PSF488.tif');
