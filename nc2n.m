function [ labels ] = nc2n( nc_labels )
%N2NC rows x 1 to rows x unique(labels) , for each label in labels, nc_labels(the row of label, label) = 1
%   labels = [[1,0],[0,1]] => new_labels = [1;2]
n=size(nc_labels,1);
labels=zeros(n,1);

for i = 1:n
   [~,labels(i)]=max(nc_labels(i,:)); 
end

