function [W,G,obj] = UDS2FS(X,Y, m,k)
%% 0.初始化
[d,n] = size(X);% X 输入：d*n
c = length(unique(Y));
one = ones(n,1);
% % 初始化W：d*m
options = [];
options.ReducedDim = m;
[W0,~] = PCA(X',options);
W = W0;
% 初始化F：m*c
A=randsample(n,c,false);
Y0=W'*X;
F=Y0(:,A);
% 随机取Y的c列
dist_a = L2_distance_1(F, W'*X);
[~, index] = min(dist_a);  
% 转化为onehot形式的G矩阵
G = full(ind2vec(index, c))';
Sw = X*X'-X*G/(G'*G)*G'*X'+eps*eye(d); %St=X*X' 
Sb = X*G/(G'*G)*G'*X'+eps*eye(d);
[W] = NSDFS(Sb, Sw, d,k,m);
obj = zeros(50,1);
St=X*X';
temp1 = trace(W'*Sw*W);
temp2 = trace(W'*St*W);
obj(1) = temp2/temp1;
for iter = 2:50
    %% 1.kmeans
    % 更新 F
    F = W'*X*G/(G'*G);
    % 计算dist
    dist_a = L2_distance_1(F, W'*X);
    [~, index] = min(dist_a);  
    % 转化为onehot形式的G矩阵
    G = full(ind2vec(index, c))';   
    %% 2. LDA
    % 计算Sw
    Sw = X*X'-X*G/(G'*G)*G'*X'+eps*eye(d); 
    Sb = X*G/(G'*G)*G'*X'+eps*eye(d); 
    % 更新W
    [W] = NSDFS(Sb, Sw, d,k,m);
    temp1 = trace(W'*Sw*W);
    %temp1 = sum(sum(L2_distance_1(W'*X,W'*X*G/(G'*G)*G')));
    temp2 = trace(W'*St*W);
    obj(iter) = temp2/temp1;
%     if obj(iter)-obj(iter-1)<0.00000001
%         break
%     end
end