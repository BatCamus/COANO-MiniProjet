clear all;
close all;
clc;

%%  Constantes

Rint = 30;
Rinj = 50;
Rext = 70;

Pinj = 400e3;
Pe = 101.3e3;

dr = 0.01;
N = (Rinj - Rint)/dr+1;
M = (Rext - Rinj)/dr+1;

r1 = Rinj:-dr:Rint;
r2 = Rinj:dr:Rext;

%% Système matriciel

Aint = zeros(N);
Bint = zeros(N,1);
Aext = zeros(M);
Bext = zeros(M,1);

for i=2:N-1
    Aint(i,i)   = -2*r1(i)/(dr^2);
    Aint(i,i-1) = (r1(i)-(dr/2))/(dr^2);
    Aint(i,i+1) = (r1(i)+(dr/2))/(dr^2);
    Bint(i)     = 0;
end

for i=2:M-1
    Aext(i,i)   = -2*r2(i)/(dr^2);
    Aext(i,i-1) = (r2(i)-(dr/2))/(dr^2);
    Aext(i,i+1) = (r2(i)+(dr/2))/(dr^2);
    Bext(i)     = 0;
end

% Conditions Limites

Aint(1,1) = 1; Bint(1)=Pinj^2;
Aint(N,N) = 1; Bint(N)=Pe^2;

Aext(1,1) = 1; Bext(1)=Pinj^2;
Aext(M,M) = 1; Bext(M)= Pe^2;

Qint = Aint\Bint;
Qext = Aext\Bext;

hold;
plot(r1,sqrt(Qint),'b.');
plot(r2,sqrt(Qext),'b.');