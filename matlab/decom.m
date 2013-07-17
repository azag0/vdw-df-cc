function XY = decom(rr,y)
%
% svd parameter
eps = 10^(-6);
%
n = size(rr,2);
Xs = sort(rr,2);
x1 = Xs(:,1);
%
q = rkhs(x1,x1);
q1 = q;
for i = 2:n
    q1 = q1+rkhs(x1,Xs(:,i));
end
[u,s,v] = svd(q1);
sd = diag(s);
j = sd>=eps;
si = zeros(size(sd));
si(j) = 1./sd(j);
si = diag(si);
q1i = v*si*u';
yy = q*q1i*y;
%
XY = [x1 yy];