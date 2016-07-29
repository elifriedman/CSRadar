function sigma_h = sigma_hat(s,rt,rr,r,f0,f)
% sigma_hat returns the estimated RCS of the point at location r, where 
% the transmitter and receiver at time n are located at rt(n,:) and rr(n,:)
% respectively.
% 
% Let N be the number of timesteps, R the number of receivers, and K the number of frequency steps
%
% s: the received signal as an N x R x K matrix
%
% rt: a matrix of size N x 1 x 3 that contains the position of the transmitter at each
% timestep
%
% rr: a matrix of size N x R x 3 that contains the position of the receivers at each
% timestep. 
% 
% r: a vector of size 3 representing a point of interest to determine the sigma estimation
%
% f0: the carrier frequency
%
% f: a K dimensional vector containing the stepped frequencies
c = 3E8;
K = length(f);
N = size(rt,1);
R = size(rr,2);

uf = repmat(u(rt,rr,r),[1 R K]); % N x R x K

% calculate distances  with or without approximations
distance = repmat(D(rt,rr,r),[1 1 K]);
% distance = D2(rt,rr,r); % Nx1 * 1xK = NxK ## 2nd order approximation
% distance = D1(rt,rr,r); % Nx1 * 1xK = NxK ## 1st order approximation

tn = distance/c;
fn = repmat(reshape(f,[1 1 K]),[N R 1]);

N_r = sum(uf(:));

sigma_h = 1/N_r*sum(s(:).*uf(:).*exp(2j*pi*(f0+fn(:)).*tn(:)));
