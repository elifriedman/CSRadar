%% EXPERIMENT  - CLASSIF. ON ORIGINAL FEATURE SPACE     X_original , 
clear all; close all; 

D = 100; % Dimensionality: can be 50 or 100 to use 1 channel or 2
sub = 0.7; % fraction of frequencies we want to keep
K = 10; % K nearest neighbors
fracTrain = 0.5; % fraction of data to use for training

%% Class 1 
load(sprintf('cube_d%d.mat',D)); % load data, MM, NN
M_cube = MM; % # rows
N_cube = NN; % # columns
data_cube = data; % D x M_cube x N_cube
num_cube = size(data_cube,2);


%% Class 2
load(sprintf('corner_d%d.mat',D)); % load data, MM, NN
M_corner = MM; % # rows
N_corner = NN; % # columns
data_corner = data; % D x M_corner x N_corner
num_corner = size(data_corner,2);

num = num_cube + num_corner;

%% Subsample frequencies
D_sub = round(sub*D);
idx_sub = sort(randperm(D,D_sub)); % sort so that order is from low freq to high freq

data_cube = data_cube(idx_sub,:,:);
data_corner = data_corner(idx_sub,:,:);

D = D_sub;

%% Reshape data
% Combine the returns from each row of measurements
% into one large dimensional vector of size D*min(N_cube, N_corner)

% data is currently shaped D x M x N
% we reshape it to (D*N) x M
% where N is min(N_cube, N_corner), since they have different number of 
% measurements per row

N_rshp = min(N_cube,N_corner);
data_cube_rshp = zeros(D*N_rshp, M_cube);
for i = 1:N_rshp
    data_cube_rshp(D*(i-1)+1:D*i, :) = data_cube(:,:,i);
end

data_corner_rshp = zeros(D*N_rshp, M_corner);
for i = 1:N_rshp
    data_corner_rshp(D*(i-1)+1:D*i, :) = data_corner(:,:,i);
end

D = D*N_rshp;

%% Create data matrix
X = abs([data_cube_rshp data_corner_rshp]).'; % num x D
X = X - ones(num,1)*mean(X,1);
X = X ./ (ones(num,1)*var(X,1));
Y = [zeros(1,num_cube) ones(1,num_corner)].'; % 0 = cube, 1 = corner

%% Split into train and test
fracVal = 1-fracTrain;
idx = randperm(num);
idx_train = idx(1:round(fracTrain*num));
idx_val = idx(round(fracTrain*num)+1:end);

Xtrain = X(idx_train,:);
Ytrain = Y(idx_train,:);
Xval = X(idx_val,:);
Yval = Y(idx_val,:);

%%
%training
train_mdl = fitcknn(Xtrain,Ytrain,'NumNeighbors',K) ;

[label_test] = predict(train_mdl,Xval);
uncompressed_score =  sum ( label_test == Yval) / length(Yval);

%% MDA_FKT
C_TRAIN = {};

C_TRAIN{1} = Xtrain(Ytrain==0,:)'; % Cube
C_TRAIN{2} = Xtrain(Ytrain==1,:)'; % Corner

[Q,V] = mda_fkt(C_TRAIN);

 
%%

scores = zeros(size(V,2),1);
for k = 1:size(V,2) 
    Proj_Mat = abs(Q*V(:,1:k)); 
    Ctrain = Xtrain*Proj_Mat;
    Cval = Xval*Proj_Mat;
    
    mdl_mkt_fda = fitcknn(Ctrain,Ytrain,'NumNeighbors',K) ;
    label_test_mda = predict(mdl_mkt_fda,Cval);

    scores(k) = sum( label_test_mda == Yval ) / length(Yval);
end
%plot(1:length(scores),scores)
%title('Accuracy vs Supbspace Size');
%xlabel('Subspace Size');
%ylabel('Accuracy');
%figure
[mx,i] = max(scores);
fprintf('accuracy: min=%f, mean=%f, max=%f\n',min(scores),mean(scores),max(scores));
fprintf('best dimension=%d\n',i);
fprintf('uncompressed score=%f\n',uncompressed_score);

Proj_Mat = abs(Q*V(:,1:i));
Ctrain = Xtrain*Proj_Mat;
plot(Xtrain(Ytrain==1,:)','b');hold on;plot(Xtrain(Ytrain==0,:)','g');
title('Original Data');

figure
plot(Ctrain(Ytrain==1,:)','b');hold on;plot(Ctrain(Ytrain==0,:)','g')
title('Compressed Data');
