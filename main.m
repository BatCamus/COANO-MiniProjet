%%% Main %%%

close all
clf;

global dx 

%% Constantes
Rint=30;
Rpi=48;
Rext=75;
Qint=(101.3e3)^2;
Qpi=(400e3)^2;
Qext=(101.3e3)^2;
dx=0.1;
N=(Rpi-Rint)/dx+1;
M=(Rext-Rpi)/dx+1;
x=Rint:dx:Rext;

%% Système matriciel

A1=zeros(N); B1=zeros(N,1); A2=zeros(M); B2=zeros(M,1);

for i=2:N-1
    A1(i,i)=-2*((x(i)+dx/2)+(x(i)-dx/2))/dx^2;
    A1(i,i-1)=(x(i)-dx/2)/dx^2;
    A1(i,i+1)=(x(i)+dx/2)/dx^2;
    B1(i)=0;
end
for j = 2 : M-1
    A2(j,j)=-2*((x(j)+dx/2)+(x(j)-dx/2))/dx^2;
    A2(j,j-1)=(x(j)-dx/2)/dx^2;
    A2(j,j+1)=(x(j)+dx/2)/dx^2;
    B2(j)=0;
end

A1(1,1)=1;B1(1)=Qint;
A1(N,N)=1;B1(N)=Qpi;
A2(1,1)=1;B2(1)=Qpi;
A2(M,M)=1;B2(M)=Qext;


Q1=A1\B1;
Q2=A2\B2;

p=[sqrt(Q1);sqrt(Q2(2:M))]
plot(x,p,'b.')
hold on;


