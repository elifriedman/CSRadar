function [dist] = D2(rt_n,rr_n,r)
% D returns the 2nd order approximation of the distance a pulse needs to travel from 
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


N = size(rt_n,1);
absr = norm(r); % 1 square root
absr2 = r*r';
r = repmat(r,[N,1]); % now N x 3
ar = r/absr;

rc = 0.5*(rt_n+rr_n);

ar_rc = diag(ar*rc');

rt2 = sum(rt_n.^2,2);
rr2 = sum(rr_n.^2,2);
dist = 2*absr*(1-ar_rc/absr - 0.5*ar_rc/absr2 + 0.25*(rt2+rr2)/absr2);
