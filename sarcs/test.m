%% Test out distance approximations

N = 10; % # time samples

% test point
r = [10 10 10]; 

% transmitter travelling along x-axis
rt = zeros(N,3);
rt(:,1) = 0:N-1; % travel at 1 unit/s

% receiver will be spaced 1 unit away from transmitter along y-axis
rr = rt;
rr(:,2) = 1;

% get actual distance
distance = D(rt,rr,r)

% get 1st order approximation
distance1 = D1(rt,rr,r)
diff1 = sum(abs(distance-distance1))

% get 2nd order approximation
distance2 = D2(rt,rr,r)
diff2 = sum(abs(distance-distance2))

%% Test out sigma estimation

% # frequency samples
K = 5; 

f0 = 2E9; % 2 GHz
f = (-K/2:K/2)*1E6; % f0 +/- -2.5 MHz

% should probably actually make up something realistic 
% for the returned signal, but don't have time right now
t0 = 1;
s = exp(-2j*pi*f0*t0)*ones(N,K);

sigma = sigma_hat(s,rt,rr,r,f0,f);

