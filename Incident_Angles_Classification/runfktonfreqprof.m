%% runfktonfreqprof
% Run MDA-FKT on Frequency Profiles
% freq_profiles.mat containts X:   24xD  (N=101)
% 6 rotations (row) by 4 positions (col)
% first 3 rot: concave;  last 3: convex
%
% Enter here with X
% load('frequency_profiles.mat')

%% Subsample if need be
frac= 1;
[N0,D]= size(X);
Dkeep= round(D*frac);
idxkeep= sort(randperm(D,Dkeep));
X1= X(:,idxkeep);

%% Split into classes
%Xabs= abs(X1);   % use just mag info for now
Xabs= X1;
[N0,D]= size(Xabs);
idxall= 0:N0-1;
idxconcave= rem(idxall,6)<3;
X1= Xabs(idxconcave,:);
X2= Xabs(~idxconcave,:);
classnames= {'Convex'; 'Concave'}
N1= size(X1,1);
N2= size(X2,1);   % # in each class

%% Select Training vs. Validation Data: use 75%
trainfrac= 11/12;
N1train= round(N1*trainfrac);
N1test= N1-N1train;
N2train= round(N2*trainfrac);
N2test= N2-N2train;
idxperm1= randperm(N1);   % need more efficient way to do this for large N1!
idxtrain1= sort(idxperm1(1:N1train));
idxtest1= sort(idxperm1((N1train+1):end));
idxperm2= randperm(N2);
idxtrain2= sort(idxperm2(1:N2train));
idxtest2= sort(idxperm2((N2train+1):end));
X1train= X1(idxtrain1,:);
X1test= X1(idxtest1,:);
X2train= X2(idxtrain2,:);
X2test= X2(idxtest2,:);

%% Create data structure for MDA-FKT function
%
% create cell, each data vector is a COLUMN so must transpose
C= 2;  % # of classes
A_train={ transpose(X1train); transpose(X2train) };
[Q,V]= mda_fkt(A_train);
% Optimum proj onto k-dim subspace:  Q*V(:,1:k)

%{ 
disp('Check unitarity:  Q*V should have ortho cols: (Q*V)''*(Q*V)=I')
eye0= (Q*V)'*(Q*V);
[mQ,nQ]= size(Q)
[mV,nV]= size(V)
s= svd(eye(nV,nV)-eye0);
errorth= s(1)
%}

%% Classify

Xtrain_all= [X1train; X2train];
labeltrain_all= [ones(N1train,1);zeros(N2train,1)];
Xtest_all= [X1test; X2test];
labeltest_all= [ones(N1test,1);zeros(N2test,1)];

scores = zeros(size(V,2),1);
for k = 1:size(V,2) 
    Proj_Mat = Q*V(:,1:k); 
    Ctrain = abs(Xtrain_all*Proj_Mat);
    Ctest = abs(Xtest_all*Proj_Mat);
    
    mdl_mkt_fda = fitcknn(Ctrain,labeltrain_all,'NumNeighbors',2) ;
    label_test_mda = predict(mdl_mkt_fda,Ctest);

    scores(k) = sum( label_test_mda == labeltest_all ) / length(labeltest_all);
end

numdim= 2;

if numdim==3
    plot3(Ctrain(1:N1train,1),Ctrain(1:N1train,2),Ctrain(1:N1train,3),'k*',Ctrain((N1train+1):end,1),...
       Ctrain((N1train+1):end,2),Ctrain((N1train+1):end,3),'go')
else
    plot(Ctrain(1:N1train,1),Ctrain(1:N1train,2),'k*', ...
        Ctrain((N1train+1):end,1),Ctrain((N1train+1):end,2),'go')
end
legend(classnames{1},classnames{2})
title('MDA-FKT Optimal Projection [3-D case] 50% samples')


