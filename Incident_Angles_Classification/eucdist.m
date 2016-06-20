function d= eucdist(a,b)
%% function d= eucdist(a,b)
%
% a: MxN, b: MxN
% Each col. vector in R^M (or C^M)
% d= list of distances between the columns
%
d= sqrt(sum(abs(a-b).^2));
