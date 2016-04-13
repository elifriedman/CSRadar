%% EXPERIMENT  - CLASSIF. ON ORIGINAL FEATURE SPACE     X_original , 
clc; clear all; close all; 

%% Class 1 
Range_profile = readdata('RotationData/Rotation_1.csv')'; % 2048 x N

N = size(Range_profile,1);
D = size(Range_profile,2);


%% Class 2
N2 = N;

mu = 1E-5+repmat(mean(Range_profile,1),N2,1); % N2 x D
var = repmat(std(Range_profile,1).^2,N2,1);

Range_profile_n = mu + sqrt(var/2).* ... 
           (randn([N2,D]) + j*randn([N2,D]));

%% Split into train and test
fracTrain = 0.5;
fracVal = 0.5;
X = [abs(Range_profile); abs(Range_profile_n)];
y = [ones(N,1);zeros(N2,1)];
[Xtrain,Ytrain,Xval,Yval,~,~] = valset(X,y,fracTrain,fracVal);

%%
%training
mdl = fitcknn(Xtrain,Ytrain,'NumNeighbors',10) ;


[label_test] = predict(mdl,Xval);
uncompressed_score =  sum ( label_test == Yval) / length(Yval) 


%% MDA_FKT
C_TRAIN = {};

C_TRAIN{1} = Xtrain(Ytrain==1,:)'; 
C_TRAIN{2} = Xtrain(Ytrain==0,:)'; 

[Q,V] = mda_fkt(C_TRAIN) ;

 
%%

scores = zeros(size(V,2),1);
for k = 1:size(V,2) 
    Proj_Mat = abs(Q*V(:,1:k)); 
    Ctrain = Xtrain*Proj_Mat;
    Cval = Xval*Proj_Mat;
    
    mdl_mkt_fda = fitcknn(Ctrain,Ytrain,'NumNeighbors',10) ;
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
Proj_Mat = abs(Q*V(:,1:i));
Ctrain = Xtrain*Proj_Mat;
plot(Xtrain(Ytrain==1,:)','b');hold on;plot(Xtrain(Ytrain==0,:)','g');
title('Original Data');

figure
plot(Ctrain(Ytrain==1,:)','b');hold on;plot(Ctrain(Ytrain==0,:)','g')
title('Compressed Data');
