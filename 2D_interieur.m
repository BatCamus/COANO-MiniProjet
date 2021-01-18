close all;
clear all;
clc;

pinj = 400e3;
pe = 0;
Rinj = 48;
Rint = 30;
Rext = 75;
Rmoy = (Rint+Rext)/2;
L    = pi*Rmoy/6;

n = 25;
Nx = 2*n+1
dx = L/(Nx-1)
Nr = 2*n+1;
dr = (Rinj-Rint)/(Nx-1);
r = Rint:dr:Rinj;

A = zeros(Nr*Nx);
B = zeros(Nr*Nx,1);

C = zeros(Nr*Nx);
D = zeros(Nr*Nx,1);

%% Domaine Intérieur

for j=2:Nr-1
    for i = 2:Nx-1 
        k=Nr*(i-1)+j;       
        A(k,k)   =-2*((r(j)/dr^2)+(Rmoy/dx^2));
        A(k,k-1) =(r(j)-dr/2)/dr^2;
        A(k,k+1) =(r(j)+dr/2)/dr^2;
        A(k,k-Nr)= Rmoy/dx^2;
        A(k,k+Nr)= Rmoy/dx^2;
        B(k)=0;
    end
end

j=1; % Rayon intérieur
for i=1:Nx
    k=Nr*(i-1)+j;
    A(k,k)=1;
    B(k)=pe^2;
end

i=1; % Bord gauche
for j=2:Nr
    k=Nr*(i-1)+j;
    A(k,k)=-3*Rmoy/dx^2;
    A(k,k+Nr)=4*Rmoy/dx^2;
    A(k,k+2*Nr)=-Rmoy/dx^2;
    B(k)=0;
end

i=Nx; % Bord droit
for j=2:Nr-1
    k=Nr*(i-1)+j;
    A(k,k)=3*Rmoy/dx^2;
    A(k,k-Nr)=-4*Rmoy/dx^2;
    A(k,k-2*Nr)=Rmoy/dx^2;
    B(k)=0;
end

j=Nr %Ligne injecteur

k=Nr*n+j;
A(k,k)=1;
B(k)=pinj^2;
    
for i=2:n
    k=Nr*(i-1)+j;
    A(k,k)=(r(j)+3*dr/2)/(dr^2)-2*Rmoy/dx^2;
    A(k,k-1)=-(2*r(j)+2*dr)/dr^2;
    A(k,k-2)=(r(j)-dr/2)/dr^2;
    A(k,k-Nr)=Rmoy/dx^2;
    A(k,k+Nr)=Rmoy/dx^2;
    B(k)=0;
end
for i=n+2:Nx
    k=Nr*(i-1)+j;
    A(k,k)=(r(j)+3*dr/2)/(dr^2)-2*Rmoy/dx^2;
    A(k,k-1)=-(2*r(j)+2*dr)/dr^2;
    A(k,k-2)=(r(j)-dr/2)/dr^2;
    A(k,k-Nr)=Rmoy/dx^2;
    A(k,k+Nr)=Rmoy/dx^2;
    B(k)=0;
end


Qint = A\B;

 %% Domaine extérieur
% r = Rinj:dr:Rext;
% %Termes généraux
% for j=2:Nr-1
%     for i = 2:Nx-1 
%         k=Nr*(i-1)+j;       
%         C(k,k)   =-2*((r(j)/dr^2)+(Rmoy/dx^2));
%         C(k,k-1) =(r(j)-dr/2)/dr^2;
%         C(k,k+1) =(r(j)+dr/2)/dr^2;
%         C(k,k-Nr)= Rmoy/dx^2;
%         C(k,k+Nr)= Rmoy/dx^2;
%         D(k)=0;
%     end
% end
% 
% j=Nr; % Rayon extérieur
% for i=1:Nx
%     k=Nr*(i-1)+j;
%     C(k,k)=1;
%     D(k)=pe^2;
% end
% 
% i=1; % Bord gauche
% for j=2:Nr
%     k=Nr*(i-1)+j;
% %     A(k,k)=-2*((r(j)/dr^2)+(-3*Rmoy/dx^2));
% %     A(k,k-1)=(r(j)-dr/2)/dr^2;
% %     A(k,k+1)=(r(j)+dr/2)/dr^2;
%     C(k,k)=-3*Rmoy/dx^2;
%     C(k,k+Nr)=4*Rmoy/dx^2;
%     C(k,k+2*Nr)=-Rmoy/dx^2;
%     D(k)=0;
% end
% 
% i=Nx; % Bord droit
% for j=2:Nr-1
%     k=Nr*(i-1)+j;
% %     A(k,k)=-2*((r(j)/dr^2)+(3*Rmoy/dx^2));
%     C(k,k)=3*Rmoy/dx^2;
%     C(k,k-Nr)=-4*Rmoy/dx^2;
%     C(k,k-2*Nr)=Rmoy/dx^2;
%     D(k)=0;
% end
% 
% j=1 %Ligne injecteur
% 
% k=Nr*n+j;
% C(k,k)=1;
% D(k)=pinj^2;
%     
% for i=2:n
%     k=Nr*(i-1)+j;
% % %     A(k,k)=(-3*r(j)+12*dr);%/(4*dr^2)-2*Rmoy/dx^2;
% % %     A(k,k-1)=-(2*dr+11*r(j));%/4*dr^2;
% % %     A(k,k-2)=(r(j)-4*dr);%/4*dr^2;
% % %     A(k,k-3)=(r(j)-2*dr);%/4*dr^2;
% 
% %     A(k,k)=(9*r(j)/4-r(j-1))/(dr^2)-2*Rmoy/dx^2;
% %     A(k,k-1)=-(r(j-2)/4-3*r(j))/dr^2;
% %     A(k,k-2)=(3*r(j)/4-r(j-1))/dr^2;
% %     A(k,k-3)=(r(j-2)/4)/dr^2;
%     
%     C(k,k)=(r(j)-3*dr/2)/(dr^2)-2*Rmoy/dx^2;
%     C(k,k-1)=(-2*r(j)+2*dr)/dr^2;
%     C(k,k-2)=(r(j)+dr/2)/dr^2;
%  
% %     A(k,k) = -2*Rmoy/dx^2;
% 
%     C(k,k-Nr)=Rmoy/dx^2;
%     C(k,k+Nr)=Rmoy/dx^2;
%     D(k)=0;
% end
% for i=n+2:Nx
%     k=Nr*(i-1)+j;
%     
% %     A(k,k)=(9*r(j)/4-r(j-1))/(dr^2)-2*Rmoy/dx^2;
% %     A(k,k-1)=-(r(j-2)/4-3*r(j))/dr^2;
% %     A(k,k-2)=(3*r(j)/4-r(j-1))/dr^2;
% %     A(k,k-3)=(r(j-2)/4)/dr^2;
% 
% % %     A(k,k)=(-3*r(j)+12*dr);%/(4*dr^2)-2*Rmoy/dx^2;
% % %     A(k,k-1)=-(2*dr+11*r(j));%/4*dr^2;
% % %     A(k,k-2)=(r(j)-4*dr);%/4*dr^2;
% % %     A(k,k-3)=(r(j)-2*dr);%/4*dr^2;
% 
%     C(k,k)=(r(j)-3*dr/2)/(dr^2)-2*Rmoy/dx^2;
%     C(k,k-1)=(-2*r(j)+2*dr)/dr^2;
%     C(k,k-2)=(r(j)+dr/2)/dr^2;
%     
% %     A(k,k) = -2*Rmoy/dx^2;
% 
%     C(k,k-Nr)=Rmoy/dx^2;
%     C(k,k+Nr)=Rmoy/dx^2;
%     D(k)=0;
% end
% Qext = C\D;

%% Résultats
 p1=sqrt(abs(Qint));
% p1 = Qint;



graph=zeros(Nx,Nr-1);
for i=1:Nx
    lg1=(i-1)*Nr;
    graph(i,1:Nr)=p1(lg1+1:lg1+Nr,1);
end

figure(1)
[X,R] = meshgrid(0:dx:L,Rint:dr:Rinj);
surf(X,R,graph')
xlabel('x'), ylabel('r'); zlabel('sqrt(|Q|)')