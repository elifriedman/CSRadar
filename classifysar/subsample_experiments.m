%% EXPERIMENT  - CLASSIF. ON ORIGINAL FEATURE SPACE     X_original , 
clear all; close all; 

M = 15;
N = 15;

meas = 100; % # measurements at each position: can be 50 or 100 to use 1 channel or 2
D = meas * M * N; % dimensionality of data
sub = 0.2; % fraction of data to keep after subsampling

K = 1; % K nearest neighbors
fracTrain = 0.1; % fraction of data to use for training

%% Class 1 
load(sprintf('cube_d%d.mat',meas)); % load data
data_cube = data; % D x num_cube;
num_cube = size(data_cube,2);

%% Class 2
load(sprintf('corner_d%d.mat',meas)); % load data
data_corner = data; % D x num_corner
num_corner = size(data_corner,2);

num = num_cube + num_corner;

%% subsample in frequency
meas_sub = round(meas * sub);
D_sub = round(D * sub);

idx_sub = sort(randperm(meas, meas_sub));

data_cube_sub = zeros(D_sub, num_cube);
i_sub = 1;
for i = 1:meas:D
    d = data_cube(i:i+meas-1 , :);
    data_cube_sub(i_sub:i_sub+meas_sub-1,:) = d(idx_sub,:);
    i_sub = i_sub + meas_sub;
end

data_corner_sub = zeros(D_sub, num_corner);
i_sub = 1;
for i = 1:meas:D
    d = data_corner(i:i+meas-1 , :);
    data_corner_sub(i_sub:i_sub+meas_sub-1,:) = d(idx_sub,:);
    i_sub = i_sub + meas_sub;
end


%% Create data matrix
X = abs([data_cube_sub data_corner_sub]).'; % num x D
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
