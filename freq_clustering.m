%load range profile or frequency data
clc; clear all; close all; 

%% run this section or skip to the next
load range_profiles

%% 

%{
load frequency_profiles


reduce_factor = 0.5
X = rand_subsample(X,floor(size(X,2)*reduce_factor));

%}

%%

N = size(X,1);
d = size(X,2);

X = abs(X);
X = X - ones(N,1)*mean(X,1);
X = X ./ (ones(N,1)*std(X,1));


for k = 2:1:10 
    
idx = kmeans(X,k,'Replicates',9);

clustered_mat = reshape(idx,[6 4 ] )

%{
6 angular orientations x 4 locations

ANGLES:
1 - No rotation
2 - 20 degree ( counter-clockwise)
3 - 20 degree (clockwise)
4 - Back 
5 - Back  20 degree(counter-clockwise)
6 - Back 20 (clockwise)

%}


end