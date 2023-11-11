function [W] = NSDFS(Sb, Sw,d,k,m)
% X: training data each column is a data;
% Y: label vector
% Written by Steven Wang, email: zhengwangml@gmail.com
W0 = orth(rand(d,m));
lambda = trace(W0'*Sb*W0)/trace(W0'*Sw*W0);
obj = [];
for iter = 1:5
obj = [obj;lambda];
eigvalue = eigs(Sb - lambda*Sw,1,'SA');
if eigvalue>=0
    A = Sb - lambda*Sw;
else
    eta = - eigvalue;
    A = Sb - lambda*Sw + eta*eye(d);
end
W = L20_function(A,k,W0);
lambda = trace(W'*Sb*W)/trace(W'*Sw*W);
W0 = W;
end

