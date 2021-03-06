clear all;
close all;
clc;

pinj = 400e3;
pe = 101.3e3;
Rinj = 48;
Rint = 30;
Rext = 70;


n = 1000;
drint = (Rinj - Rint)/(n-1);
drext = (Rext - Rinj)/(n-1);
rint = 0:drint:(Rinj - Rint);
rext = 0:drext:(Rext - Rinj);

Aint = zeros(n);
Bint = zeros(n,1);
Aext = zeros(n);
Bext = zeros(n,1);

for i=2:n-1
    Aint(i,i)   = -2*rint(i)/(drint^2);
    Aint(i,i-1) = (rint(i)-(drint/2))/(drint^2);
    Aint(i,i+1) = (rint(i)+(drint/2))/(drint^2);
    Bint(i)     = 0;
end
for i=2:n-1
    Aext(i,i)   = -2*rext(i)/(drext^2);
    Aext(i,i-1) = (rext(i)-(drext/2))/(drext^2);
    Aext(i,i+1) = (rext(i)+(drext/2))/(drext^2);
    Bext(i)     = 0;
end

Aint(1,1) =1;
Bint(n)   = pe^2;
Aint(n,n) =1;
Bint(1)   = pinj^2;


Aext(1,1) = 1;
Bext(1) = pinj^2;
Aext(n,n) = 1;
Bext(n) = pe^2;
   
Qint = Aint\Bint;
Qext = Aext\Bext;
Qint2= zeros(n,1);

for i=1:n 
    Qint2(i) = Qint(n-i+1);
end
hold;
plot(rint(:)+Rint,sqrt(Qint2),'b.');
plot(rext(:)+Rinj,sqrt(Qext),'b.');
% p=[sqrt(Qint);sqrt(Qext)]
% rtot =[r(:)+rint;r(:)+rinj]
% plot(r+rtot,p,'b.');
