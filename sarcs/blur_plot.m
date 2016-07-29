clear all;

c = 3E8;
N = 150; % # time samples
K = 10; % # frequency samples
f0 = 5E9; % 2 GHz carrier freq (made up out of thin air)
x_max = 10; % transmitter travels from 0 up until x_max

% use 1 idealized point scatterer at r0, with sigma(r) = delta(r0)
r0 = [2 0 100];

% transmitter travelling along x-axis
rt = zeros(N,3);
rt(:,1) = linspace(0,x_max,N); % path of transmitter from 0 to x_max

% receiver will be spaced 1 unit away from transmitter along x-axis
rr = rt;
rr(:,1) = rt(:,1) + 1;

f = (-K/2:K/2)*1E6; % frequency steps, chosen arbitrarily

%%
% Calculate return signal from point scatterer at r0
distance = D(rt,rr,r0);
[fn,tn] = meshgrid(f, distance/c); 

% the return signal at the receiver
s = exp(-2j*pi*(f0+fn).*tn); % N x K

%%
% Measure blur function B(r,r0)

% we'll plot the blur function from x = 0..scanlens(1) and y = -scanlens(2)/2 ... scanlens(2)/2
scanlens = [10 80]; 
density = 200; % how many points to measure along each axis?

blur = zeros(density);
i = 1;
for y = linspace(-scanlens(2)/2,scanlens(2)/2,density)
  j = 1;
  for x = linspace(0,scanlens(1),density)
    r = [x y r0(3)];
    blur(i,j) = B(rt,rr,r,r0,f0,f);
    j = j + 1;
  end
  i = i + 1;
end

%%
% Plot
blurplot = abs(blur)/max(abs(blur(:))); % normalize for plotting
imwrite(blurplot,'blur.png');
% xaxis is linspace(0,scanlens(1),density)
% yaxis is linspace(-scanlens(2)/2,scanlens(2)/2,density)
% title is "Point scatterer blur function at r = (r0(1),r0(2),r0(3))"
