function [W,G,obj] = UFDR_SDFS(X,Y, m,k)
%% 0.��ʼ��
[d,n] = size(X);% X ���룺d*n
c = length(unique(Y));
one = ones(n,1);
% % ��ʼ��W��d*m
options = [];
options.ReducedDim = m;
[W0,~] = PCA(X',options);
W = W0;
% ��ʼ��F��m*c
A=randsample(n,c,false);
Y0=W'*X;
F=Y0(:,A);
% ���ȡY��c��
dist_a = L2_distance_1(F, W'*X);
[~, index] = min(dist_a);  
% ת��Ϊonehot��ʽ��G����
G = full(ind2vec(index, c))';
Sw = X*X'-X*G/(G'*G)*G'*X'+eps*eye(d); %St=X*X' 
Sb = X*G/(G'*G)*G'*X'+eps*eye(d);
[W] = NSDFS(Sb, Sw, d,k,m);
obj = zeros(50,1);
St=X*X';
temp1 = trace(W'*Sw*W);
%temp1 = sum(sum(L2_distance_1(W'*X,W'*X*G/(G'*G)*G')));
temp2 = trace(W'*St*W);
obj(1) = temp2/temp1;
for iter = 2:50
    %% 1.kmeans
    % ���� F
    F = W'*X*G/(G'*G);
    % ����dist
    dist_a = L2_distance_1(F, W'*X);
    [~, index] = min(dist_a);  
    % ת��Ϊonehot��ʽ��G����
    G = full(ind2vec(index, c))';   
    %% 2. LDA
    % ����Sw
    Sw = X*X'-X*G/(G'*G)*G'*X'+eps*eye(d); 
    Sb = X*G/(G'*G)*G'*X'+eps*eye(d); 
    % ����W
    [W] = NSDFS(Sb, Sw, d,k,m);
    temp1 = trace(W'*Sw*W);
    %temp1 = sum(sum(L2_distance_1(W'*X,W'*X*G/(G'*G)*G')));
    temp2 = trace(W'*St*W);
    obj(iter) = temp2/temp1;
%     if obj(iter)-obj(iter-1)<0.00001
%         break
%     end
end