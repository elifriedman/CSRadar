clear all;

c = 3E8;
N = 150; % # time samples
K = 10; % # frequency samples
f0 = 5E9; % 2 GHz carrier freq (made up out of thin air)
x_max = 50; % transmitter travels from 0 up until x_max

% transmitter travelling along x-axis
rt = zeros(N,3);
rt(:,1) = linspace(0,x_max,N); % path of transmitter

% receiver will be spaced 1 unit away from transmitter along x-axis
rr = rt;
rr(:,1) = rt(:,1) + 1;

f = (-K/2:K/2)*1E6; % frequency steps, chosen arbitrarily

% use 1 point scatterer at r0
r0 = [25 0 30];
distance = D(rt,rr,r0);
[fn,tn] = meshgrid(f, distance/c); % t0 should have each row be 1 timestep, f should have each column be 1 freq

% calculate the return signal at the receiver
s = exp(-2j*pi*(f0+fn).*tn); % N x K

voxels = [50 50]; % 2D for now
density = 350;
blur = zeros(density);
i = 1;
for y = linspace(-voxels(2)/2,voxels(2)/2,density)
  j = 1;
  for x = linspace(0,voxels(1),density)
    r = [x y r0(3)];
    blur(i,j) = B(rt,rr,r,r0,f0,f);
    j = j + 1;
  end
  i = i + 1;
end

% plot sigma. probably should plot blurring function
% which subtracts D(r0) inside the argument
%imshow(abs(sigma)); % should have a peak at r0, in the center
%xlabel(1:voxels(1));
%ylabel(1:voxels(2));
%
