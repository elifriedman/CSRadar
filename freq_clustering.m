%load frequency_profiles
load range_profiles

N = size(X,1);
d = size(X,2);

X = abs(X);
X = X - ones(N,1)*mean(X,1);
X = X ./ (ones(N,1)*std(X,1));

idx = kmeans(X,6,'Replicates',9)'
