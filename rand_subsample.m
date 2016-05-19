function [ X_new, idx] = rand_subsample( X, s )
%random subsampling of frequency measurements

%%
[m n] = size(X);
sample_vec = randperm(n,s);
X_new = zeros(m,s);

X_new = X(:,sort(sample_vec));


idx = sort(sample_vec);


end

