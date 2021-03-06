close all;
clear all;
clc;

ninj=12;
pinj = 400e3-101e3;
pe = 0;
Rinj = 48;
Rint = 30;
Rext = 75;
Rmoy = (Rint+Rext)/2;
L    = 2*pi*Rmoy;
Ln   = L/ninj;

n = 25;
Nx = 2*n+1
dx = Ln/(2*n)
Nr = 2*n+1;
dr = (Rinj-Rint)/(Nr-1);
r=Rint:dr:Rinj;

A = zeros(Nr*Nx);
B = zeros(Nr*Nx,1);

% lignes générales
for j=2:Nr-1
    for i = 2:Nx-1 
        k=Nr*(i-1)+j;
        A(k,k)=-2*((r(j)/dr^2)+(Rmoy/dx^2));
        A(k,k-1)=(r(j)-dr/2)/dr^2;
        A(k,k+1)=(r(j)+dr/2)/dr^2;
        A(k,k-Nr)=Rmoy/dx^2;
        A(k,k+Nr)=Rmoy/dx^2;
        B(k)=0;
    end
end

i=1; % Bord gauche
for j=2:Nr-1
    k=Nr*(i-1)+j;
    A(k,k)= (-3/(2*dx));
    A(k,k+Nr)=4/(2*dx);
    A(k,k+2*Nr)=-1/(2*dx);
    B(k)=0; 
end
i=Nx; % Bord droit
for j=2:Nr-1
    k=Nr*(i-1)+j;
    A(k,k)=+(3/(2*dx));
    A(k,k-Nr)=-4/(2*dx);
    A(k,k-2*Nr)=1/(2*dx);
    B(k)=0;
end
j=1; % Rayon intérieur
for i=1:Nx
    k=Nr*(i-1)+j;
    A(k,k)=1;
    B(k)=pe^2;
end

%Ligne injecteur
j=Nr; 
i=n+1;
k=Nr*(i-1)+j;
A(k,k)=1;
B(k)=pinj^2;

for i=2:Nx
    k=Nr*(i-1)+j;
    if A(k,k)== 0
    A(k,k)=-2*((r(j)/dr^2)+(Rmoy/dx^2));
    A(k,k-1)=(r(j)-dr/2)/dr^2;
    A(k,k+1)=(r(j)+dr/2)/dr^2;
    A(k,k-Nr)=Rmoy/dx^2;
    A(k,k+Nr)=Rmoy/dx^2;
    B(k)=0;
    end
end

Q=A\B;

% p1=sqrt(Q);
p1 = Q;

graph=zeros(Nx,Nr-1);
for i=1:Nx
    lg1=(i-1)*Nr;
    graph(i,1:Nr)=p1(lg1+1:lg1+Nr,1);
end

figure(1)
surf(graph')
xlabel('x'), ylabel('r'); zlabel('p')
