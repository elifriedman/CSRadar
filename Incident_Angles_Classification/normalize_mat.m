function [ X_normalized ] = normalize_mat( X )
N = size(X,1);
d = size(X,2);

X = abs(X);
X = X - ones(N,1)*mean(X,1);
X_normalized = X ./ (ones(N,1)*std(X,1));

end

