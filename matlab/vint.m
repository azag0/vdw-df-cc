function VI = vint(RI,XX)
%
R = XX(:,1);
V = XX(:,2);
n = length(R);
%
X = R.^2;
%XP = repmat(X,1,n);
%XQ = repmat(X',n,1);
XP = X(:,ones(n,1));
XQ = XP';
Xs = min(XP,XQ);
Xl = max(XP,XQ);
%Q = 1/3*(1-3/5*Xs./Xl)./Xl.^3;
Q = 1/3-1/5*Xs./Xl;
P = Xl.*Xl;
P = P.*Xl;
Q = Q./P;
% speed up 2.2x
A = Q\V;
%
ni = length(RI);
XI = RI(:).^2;
%XP = repmat(XI,1,n);
%XQ = repmat(X',ni,1);
XP = XI(:,ones(n,1));
XQ = X(:,ones(ni,1));
XQ = XQ';
Xs = min(XP,XQ);
Xl = max(XP,XQ);
QI = 1/3*(1-3/5*Xs./Xl)./Xl.^3;
VI = QI*A;