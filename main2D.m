%%% Main 2D %%%

close all
clf;

global dr 

%% Constantes
Rint=30;
Rpi=48;
Rext=75;
Rmoy=(Rext+Rint)/2; 
L=2*pi*Rmoy;
l=Rext-Rint;

Qint=(101.3e3)^2;
Qpi=(400e3)^2;
Qext=(101.3e3)^2;
dr=1;
dx=1;

Nr=round((Rpi-Rint)/dr)+1;
Nx=round(L/dx)+1;
Mr=round((Rext-Rpi))/dr+1;
Mx=Nx;
r1=Rint:dr:Rpi; %attention peut etre une couille de nombre de point
r2=Rpi:dr:Rext;

%% Syst�me matriciel
A1=zeros(Nr*Nx); B1=zeros(Nr*Nx,1); A2=zeros(Mr*Mx); B2=zeros(Mr*Mx,1);
%% Premier domaine
%Lignes generales
for i=2:Nx-1
    for j = 2:Nr-1 
        k=Nr*(i-1)+j;
        A1(k,k)=(-2*((r1(j)+dr/2)+(r1(j)-dr/2))/dr^2)-(2*Rmoy/dx^2);
        A1(k,k-1)=(r1(j)-dr/2)/dr^2;
        A1(k,k+1)=(r1(j)+dr/2)/dr^2;
        A1(k,k-Nr)=Rmoy/dx^2;
        A1(k,k+Nr)=Rmoy/dx^2;
    end
end

%Conditions limites 
j=1; % Rayon int�rieur
for i=1:Nx-1
    k=Nr*(i-1)+j;
    A1(k,k)=1;
    B1(k)=Qext;
end

j=Nr; % rayon injecteurs
for i=1:Nx-1
    k=Nr*(i-1)+j;
    A1(k,k)=1;
    B1(k)=Qpi;
end

% for j = 2 : M-1
%     A2(j,j)=-2*((r(j)+dr/2)+(r(j)-dr/2))/dr^2;
%     A2(j,j-1)=(r(j)-dr/2)/dr^2;
%     A2(j,j+1)=(r(j)+dr/2)/dr^2;
%     B2(j)=0;
% end



Q1=A1\B1;
% Q2=A2\B2;

p1=sqrt(Q1);
% p2=sqrt(Q2(2:M));
% p=[p1;p2]

%% Affichage 
graph=zeros(Nx,Nr);
for i=1:Nx
    l=(i-1)*Nx;
    graph(i,:)=p1(l+1:l+Nx,1);
end

figure 
surf(graph')
xlabel('x'), ylabel('r'); zlabel('p')