%%% Main 2D %%%
clear all
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
for j=2:Nr-1
    for i = 2:Nx-1 
        k=Nr*(i-1)+j;
        A1(k,k)=(-((r1(j)+dr/2)+(r1(j)-dr/2))/dr^2)-(2*Rmoy/dx^2);
        A1(k,k-1)=(r1(j)-dr/2)/dr^2;
        A1(k,k+1)=(r1(j)+dr/2)/dr^2;
        A1(k,k-Nr)=Rmoy/dx^2;
        A1(k,k+Nr)=Rmoy/dx^2;
    end
end

    %%Conditions limites 
i=1; % Bord gauche
for j=2:Nr-1
    k=Nr*(i-1)+j;
    A1(k,k)=(-((r1(j)+dr/2)+(r1(j)-dr/2))/dr^2)+(2*Rmoy/dx^2);
    A1(k,k-1)=(r1(j)-dr/2)/dr^2;
    A1(k,k+1)=(r1(j)+dr/2)/dr^2;
    A1(k,k+Nr)=-5*Rmoy/dx^2;
    A1(k,k+2*Nr)=4*Rmoy/dx^2;
    A1(k,k+3*Nr)=-Rmoy/dx^2;
end

i=Nx; % Bord droit
for j=2:Nr-1
    k=Nr*(i-1)+j;
    A1(k,k)=(-((r1(j)+dr/2)+(r1(j)-dr/2))/dr^2)+(2*Rmoy/dx^2);
    A1(k,k-1)=(r1(j)-dr/2)/dr^2;
    A1(k,k+1)=(r1(j)+dr/2)/dr^2;
    A1(k,k-Nr)=-5*Rmoy/dx^2;
    A1(k,k-2*Nr)=4*Rmoy/dx^2;
    A1(k,k-3*Nr)=-Rmoy/dx^2;
end

j=1; % Rayon int�rieur
for i=1:Nx
    k=Nr*(i-1)+j;
    A1(k,k)=1;
    B1(k)=Qext;
end

j=Nr; % rayon injecteurs
for i=1:Nx
    k=Nr*(i-1)+j;
    A1(k,k)=1;
    B1(k)=Qpi;
end

%% Deuxi�me domaine
    %Lignes generales
for j=2:Mr-1
    for i = 2:Mx-1 
        k=Mr*(i-1)+j;
        A2(k,k)=(-((r2(j)+dr/2)+(r2(j)-dr/2))/dr^2)-(2*Rmoy/dx^2);
        A2(k,k-1)=(r2(j)-dr/2)/dr^2;
        A2(k,k+1)=(r2(j)+dr/2)/dr^2;
        A2(k,k-Mr)=Rmoy/dx^2;
        A2(k,k+Mr)=Rmoy/dx^2;
    end
end

    %%Conditions limites 
i=1; % Bord gauche
for j=2:Mr-1
    k=Mr*(i-1)+j;
    A2(k,k)=(-((r2(j)+dr/2)+(r2(j)-dr/2))/dr^2)+(2*Rmoy/dx^2);
    A2(k,k-1)=(r2(j)-dr/2)/dr^2;
    A2(k,k+1)=(r2(j)+dr/2)/dr^2;
    A2(k,k+Mr)=-5*Rmoy/dx^2;
    A2(k,k+2*Mr)=4*Rmoy/dx^2;
    A2(k,k+3*Mr)=-Rmoy/dx^2;
end

i=Mx; % Bord droit
for j=2:Mr-1
    k=Mr*(i-1)+j;
    A2(k,k)=(-((r2(j)+dr/2)+(r2(j)-dr/2))/dr^2)+(2*Rmoy/dx^2);
    A2(k,k-1)=(r2(j)-dr/2)/dr^2;
    A2(k,k+1)=(r2(j)+dr/2)/dr^2;
    A2(k,k-Mr)=-5*Rmoy/dx^2;
    A2(k,k-2*Mr)=4*Rmoy/dx^2;
    A2(k,k-3*Mr)=-Rmoy/dx^2;
end

j=1; % Rayon injecteur
for i=1:Mx
    k=Mr*(i-1)+j;
    A2(k,k)=1;
    B2(k)=Qpi;
end

j=Mr; % rayon exterieur
for i=1:Mx
    k=Mr*(i-1)+j;
    A2(k,k)=1;
    B2(k)=Qext;
end




Q1=A1\B1;
Q2=A2\B2;

p1=sqrt(Q1);
p2=sqrt(Q2(2:length(Q2)));

p=[p1;p2];
r=[r1,r2];

%% Affichage 
graph=zeros(Nx,Nr+Mr-1);
for i=1:Nx
    lg1=(i-1)*Nr;
    lg2=(i-1)*(Mr);
    graph(i,1:Nr)=p1(lg1+1:lg1+Nr,1);
    graph(i,Nr+1:Nr+Mr-1)=p2(lg2+1:lg2+Mr-1,1);
end

figure(1)
surf(graph')
xlabel('x'), ylabel('r'); zlabel('p')

figure(2)
plot(graph(5,:))
