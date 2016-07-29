clear all;

c = 3E8;
N = 30; % # time samples
K = 5; % # frequency samples
f0 = 5E9; % 2 GHz carrier freq (made up out of thin air)
x_max = 10; % transmitter travels from 0 up until x_max
R = 3; % # of receivers
rdist = .2; % distance between them along x-axis

% use 1 idealized point scatterer at r0, with sigma(r) = delta(r0)
r0 = [5 0 30];

% 1 transmitter travelling along x-axis
rt = zeros(N,1,3); % N x 1 x 3
rt(:,:,1) = linspace(0,x_max,N); % path of transmitter from 0 to x_max

% R receivers spaced rdist units away from each other
% size(rr) = [N,R,3]
rr = repmat(rt,[1 R 1]);
r(:,:,1) = rr(:,:,1) + repmat( 0 : rdist : rdist*(R-1), [N 1]);


f = (-K/2:(K-1)/2)*1E6; % frequency steps, chosen arbitrarily

%%
% Calculate return signal from point scatterer at r0
distance = repmat(D(rt,rr,r0),[1 1 K]); % N x R x K

tn = distance/c;
fn = repmat(reshape(f,[1 1 K]),[N R 1]);

% the return signal at the receivers
s = exp(-2j*pi*(f0+fn).*tn); % N x R x K

%%
% Measure blur function B(r,r0)

% we'll plot the blur function from x = 0..scanlens(1) and y = -scanlens(2)/2 ... scanlens(2)/2
scanlens = [10 80]; 
density = 100; % how many points to measure along each axis?

blur = zeros(density);
i = 1;
for y = linspace(-scanlens(2)/2,scanlens(2)/2,density)
  j = 1;
  for x = linspace(0,scanlens(1),density)
    r = [x y r0(3)];
%    blur(i,j) = sigma_hat(s,rt,rr,r,f0,f);
    blur(i,j) = B(rt,rr,r,r0,f0,f);
    j = j + 1;
  end
  i = i + 1;
end

%%
% Plot
blurplot = abs(blur)/max(abs(blur(:))); % normalize for plotting
imwrite(blurplot,'blur.png');
