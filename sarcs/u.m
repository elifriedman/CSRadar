function visible = u(rt_n,rr_n,r)
% returns a 1 if point r is illuminated
% 
% Let N be the number of timesteps
%
% rt_n: a matrix of size N x 3 that contains the position of the transmitter at each
% timestep
%
% rri_n: a matrix of size N x 3 that contains the position of the receivers at each
% timestep. (assuming only 1 receive)
% 
% r: a vector of size 3 representing a point of interest to determine the distance D(r)

% we need actual radar parameters to determine whether r[n] is lit up
% for now, I'll assume r[n] is illuminated if it's (x,y) coordinate
% is within a certain radius K of rt[n]'s (x,y) coordinate.
K = 1;
N = size(rt_n,1);
r = ones(N,1)*r; % now N x 3
rt_r = rt_n-r;
visible = rt_r(:,1).^2 + rt_r(:,2).^2 <= K.^2;
