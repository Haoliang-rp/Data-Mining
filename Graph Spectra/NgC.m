E = csvread('example1.dat');
col1 = E(:,1);
col2 = E(:,2);
max_ids = max(max(col1, col2));
As = sparse(col1, col2, 1, max_ids, max_ids);
A = full(As);
D = diag(sum(A,2));
sizeA = size(A);

Graph = graph(A)
num_nodes = size(Graph.Nodes, 1)

L = (D^(-0.5)) * A * (D^(-0.5));

[v,DL] = eigs(L, size(L,1)-1);

[eigen_value_sorted,ind] = sort(diag(DL), 'descend')
Ds = DL(ind,ind)
Vs = v(:,ind)

% find k according to largest eigen gap
k = findK( eigen_value_sorted )
X = Vs(:,(1:k));
Y = X./(sum(X.^2,2)).^(0.5);

Idx = kmeans(Y, k);

h = plot(Graph, 'MarkerSize', 10);

floatIdx = Idx / max(Idx)
cm = colormap;
mycolor = zeros(num_nodes, 3)
for i = 1:num_nodes
    colorID = max(1, sum(floatIdx(i) > [0:1/length(cm(:,1)):1]));
    mycolor(i, :) = cm(colorID, :)
end

plot(Graph, 'NodeColor', mycolor);

function k = findK( nums )
% nums: in descending order
k = -1;
y = abs(diff(nums));
[~, k] = max(y);

end
