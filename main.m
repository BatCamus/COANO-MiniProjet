%%% Main 1D %%%

close all
clf;

global dx 

%% Constantes
Rint=30;
Rpi=50;
Rext=70;
Rmoy=(Rext+Rint)/2; 
L=2*pi*Rmoy;
l=Rext-Rint;

Qint=(0)^2;
Qpi=(400e3-101.3e3)^2;
Qext=(0)^2;
dx=0.1;
N=round((Rpi-Rint)/dx)+1;
M=round((Rext-Rpi)/dx)+1;
r1=Rint:dx:Rpi;
r2=Rpi:dx:Rext;
%% Syst�me matriciel

A1=zeros(N); B1=zeros(N,1); A2=zeros(M); B2=zeros(M,1);

for i=2:N-1
    A1(i,i)=-((r1(i)+dx/2)+(r1(i)-dx/2))/dx^2;
%     A1(i,i)=-2*r1(i)/dx^2;
    A1(i,i-1)=(r1(i)-dx/2)/dx^2;
    A1(i,i+1)=(r1(i)+dx/2)/dx^2;
    B1(i)=0;
end
for j = 2 : M-1
    A2(j,j)=-((r2(j)+dx/2)+(r2(j)-dx/2))/dx^2;
%     A2(j,j)=-2*r2(j)/dx^2;
    A2(j,j-1)=(r2(j)-dx/2)/dx^2;
    A2(j,j+1)=(r2(j)+dx/2)/dx^2;
    B2(j)=0;
end

A1(1,1)=1;B1(1)=Qint;
A1(N,N)=1;B1(N)=Qpi;
A2(1,1)=1;B2(1)=Qpi;
A2(M,M)=1;B2(M)=Qext;


Q1=A1\B1;
Q2=A2\B2;


%% Solution analytique 
A1 = (Qint-Qpi)/log(Rint/Rpi);
B1 = Qpi-((Qint-Qpi)/log(Rint/Rpi))*log(Rpi);
A2 = (Qext-Qpi)/log(Rext/Rpi);
B2 = Qpi-((Qext-Qpi)/log(Rext/Rpi))*log(Rpi);

Qanal1 = A1*log(r1)+B1;
Qanal2 = A2*log(r2)+B2;

%% Affichage 
x=[r1,r2(2:length(r2))];
p=[sqrt(Q1);sqrt(Q2(2:M))];
panal=[sqrt(Qanal1');sqrt(Qanal2(2:M))'];

plot(x,panal,'r-','linewidth',1)
hold on;
plot(x,p,'bo')
xlabel('Rayon de la but�e (en mm)')
ylabel('Pression relative (en Pa)')
title({['R�partition de pression le long de la but�e a�rostatique']; [' Rayon injecteur : ', num2str(Rpi), ' mm']})
legend('Solution analytique', 'Solution num�rique')

%% Erreur 
erreur = zeros(N+M,1);
for i = 1 : N
    erreur(i)=abs(Q1(i)-Qanal1(i))/Qanal2(i);
end
for i = 1:M
    erreur(i+N)=abs(Q2(i)-Qanal2(i))/Qanal2(i);
end
errmean=mean(erreur)
