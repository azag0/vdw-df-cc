function Q = rkhs(R,RI)
%
n = length(R);
ni = length(RI);
%
X = R(:).^2;
XI = RI(:).^2;
XP = repmat(XI,1,n);
XQ = repmat(X',ni,1);
Xs = min(XP,XQ);
Xl = max(XP,XQ);
Q = 1/3-1/5*Xs./Xl;
P = Xl.*Xl;
P = P.*Xl;
Q = Q./P;
