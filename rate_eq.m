function dy=rate_eq(t,y,flag,kexc)
%% 参数初始化
% kexc=1/3.8e-8;%absorption
kf=1/3.6e-9;%fluorescence emission
koff=1/5e-9;%intersystem crossing
kon=1/10;
% kA=3.2e-4/3.6e-9;%radiationless deactivation

Nb=y(1);Nb_=y(2);Nd=y(3);

dy=[
    -kexc*Nb+kf*Nb_+kon*Nd;
    kexc*Nb-(kf+koff)*Nb_;
    -kon*Nd+koff*Nb_;
    ];
end
