function sigma_h = sigma_hat(s,rt_n,rr_n,r,f0,f)
% sigma_hat returns the estimated RCS of the point at location r, where 
% the transmitter and receiver at time n are located at rt_n(n,:) and rr_n(n,:)
% respectively.
% 
% Let N be the number of timesteps and K the number of frequency steps
%
% s: the received signal as an N x K matrix
%
% rt_n: a matrix of size N x 3 that contains the position of the transmitter at each
% timestep
%
% rr_n: a matrix of size N x 3 that contains the position of the receivers at each
% timestep. (assuming only 1 receive)
% 
% r: a vector of size 3 representing a point of interest to determine the distance D(r)
%
% f0: the carrier frequency
%
% f: a K dimensional vector containing the stepped frequencies
c = 3E8;
K = length(f);
N = size(rt_n,1);

uf = u(rt_n,rr_n,r) * ones(1,K); % Nx1 * 1xK = NxK

% calculate distances  with or without approximations
Df = D(rt_n,rr_n,r) * ones(1,K); % Nx1 * 1xK = NxK
% Df = D2(rt_n,rr_n,r) * ones(1,K); % Nx1 * 1xK = NxK.  ## 2nd order approximation
% Df = D1(rt_n,rr_n,r) * ones(1,K); % Nx1 * 1xK = NxK.  ## 1st order approximation

Nf = ones(N,1) * f(:)'; % Nx1 * 1xK = NxK

N_r = sum(uf(:));

sigma_h = 1/N_r*sum(sum(s.*uf.*exp(1j*2*pi/c*(f0+Nf).*Df)));
