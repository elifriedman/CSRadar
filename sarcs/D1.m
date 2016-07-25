function [dist] = D1(rt_n,rr_n,r)
% D returns the 1st order approximation of the distance a pulse needs to travel from 
% the transmitter (located at rt_n) to a point (located at r) and back to a receiver 
% (located at rr_n)
% 
% Let N be the number of timesteps
%
% rt_n: a matrix of size N x 3 that contains the position of the transmitter at each
% timestep
%
% rr_n: a matrix of size N x 3 that contains the position of the receivers at each
% timestep. (assuming only 1 receive)
% 
% r: a vector of size 3 representing a point of interest to determine the distance D(r)

absr = norm(r); % 1 square root

N = size(rt_n,1);
r = repmat(r,[N,1]); % now N x 3
ar = r/absr;

rc = 0.5*(rt_n+rr_n);

ar_rc = diag(ar*rc');

dist = 2*absr*(1-ar_rc/absr);
