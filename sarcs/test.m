%% Test out distance approximations
c = 3E8;

N = 10; % # time samples

% test point
r = [10 10 10]; 

% transmitter travelling along x-axis
rt = zeros(N,3);
rt(:,1) = 0:N-1; % travel at 1 unit/s

% receiver will be spaced 1 unit away from transmitter along x-axis
rr = rt;
rr(:,1) = 1;

% get actual distance
distance = D(rt,rr,r);

% get 1st order approximation
distance1 = D1(rt,rr,r);
diff1 = sum(abs(distance-distance1));

% get 2nd order approximation
distance2 = D2(rt,rr,r);
diff2 = sum(abs(distance-distance2));

%% Test out sigma estimation with 1 point
% # frequency samples
K = 5; 

f0 = 2E9; % 2 GHz
f = (-K/2:K/2)*1E6; % f0 +/- -2.5 MHz

% use 1 point scatterer at r0
r0 = [5 5 10];
t0n,fn = meshgrid(distance/c, f); % t0 should have each row be 1 timestep, f should have each column be 1 freq

s = exp(-2j*pi*(f0+fn).*t0n); % N x K

voxels = [10 10]; % 2D for now
sigma = zeros(voxels)
for x = 1:voxels(1)
  for y = 1:voxels(2)
    r = [x y 10];
    sigma(x,y) = sigma_hat(s,rt,rr,r,f0,f);
  end
end

% plot sigma. probably should plot blurring function
% which subtracts D(r0) inside the argument
imshow(abs(sigma)); % should have a peak at r0, in the center
xlabel(1:voxels(1));
ylabel(1:voxels(2));
title('Estimation of sigma');
