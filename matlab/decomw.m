function XY = decomw(rr,wr,y,eps)
[rr, ix] = sort(rr, 2);
for j = 1:size(rr,1)
    wr(j, :) = wr(j, ix(j, :));
end
%
% svd parameter
eps = 10^-6;
%
n = size(rr,2);
x1 = rr(:,1);
%
q = rkhs(x1,x1);
q1 = diag(wr(:,1))*q;
for i = 2:n
    q1 = q1+diag(wr(:,i))*rkhs(x1,rr(:,i));
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
