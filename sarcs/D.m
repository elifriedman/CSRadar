function [dist] = D(rt_n,rri_n,r)
% D returns the distance a pulse needs to travel from the transmitter (located at rt_n) 
% to a point (located at r) and back to a receiver (located at rri_n)
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

N = size(rt_n,1);
r = repmat(r,[N,1]); % now N x 3
rt_r = sqrt(sum((rt_n-r).^2,2));
r_rr = sqrt(sum((rri_n-r).^2,2));
dist = rt_r + r_rr;
