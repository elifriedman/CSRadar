function [Cov_x] = cov_display( X)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
Cov_x = cov(X,1);

[m,n] = size(Cov_x);
f3 = figure;
imagesc(1:m,1:n,Cov_x);
colorbar;
saveas(f3,'covariance_original_freq.png');

end

