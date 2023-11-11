function [W,mean0,std0,max0,obj] = main(X,Y,m,k)
X=X';
%X:d*n
[d,n]=size(X);
%% main process
for iter = 1:20
    [W,G,obj] = UDS2FS(X,Y, m,k);
    s = zeros(n,1);
    s = nc2n(G);
    y = bestMap(Y,s);
    result(iter,:) = ClusteringMeasure(Y,y);
end
mean0=mean(result);
max0=[max(result(:,1)) max(result(:,2)) max(result(:,3))];
std0=std(result);

