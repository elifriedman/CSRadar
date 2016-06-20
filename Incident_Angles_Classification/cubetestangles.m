%% CUBETESTANGLES
%
% Reference cube diagrams.
% Find angle from Tx/Rx center to normal of closest face of cube.
%
% Rotation and translation in xy-plane
% Heights not aligned so have z-component
%
%
clc; clear all; close all; 
%% Position Parameters (given)
%     Each position a 2x1 vector


%     All distances in   m
CubeCtr0= [0;0;0];
TxRxHeight= -0.03;
TxRxDist= 3.23;     % x displacement to origin
TxRxSep=  0.60;     % +y diplacement of Rx rel to Tx
dxdy= [0.46,0.46];  % xy dimensions of cube
theta= [0,30,15,60, 75, 45]  % 1 2 3 4 5 6  
%[0,15,30,45,60,75];    % rotations in degrees
pos= [0,-0.15,-0.3,0.15]%  1 2 3 4
  %[-0.15,0,0.15,0.30];  % y-displacements of cube center

%% Compute tx and rx locations and center
%
Tx= [-TxRxDist;-TxRxSep/2; TxRxHeight];
Rx= [-TxRxDist; TxRxSep/2; TxRxHeight];
TxRxCtr= (Tx+Rx)/2;

%% Compute (pos,theta) pairs
Nrot= length(theta);
Npos= length(pos);
th1= repmat(theta(:),1,Npos)';
p1= repmat(pos(:),1,Nrot);
% (posidx,rotidx) identifies rotation in th1 and position in p1
posth= [p1(:),th1(:)];
% each row in posth is (pos,theta) pair
Nposrot= size(posth,1);

%% Compute positions of cube vertices and face centers
%
% First before rotation and translation, then after
cubev0= [-dxdy(1)/2 dxdy(1)/2 dxdy(1)/2 -dxdy(1)/2; ...
    dxdy(2)/2, dxdy(2)/2, -dxdy(2)/2, -dxdy(2)/2; ...
    zeros(1,4) ];
cubef0= [(cubev0(:,2:end)+cubev0(:,1:end-1))/2, ...
    (cubev0(:,end)+cubev0(:,1))/2];
% Apply rotations
for ii=1:Nposrot
    r= eye(3,3);
    r(1:2,1:2)= rotmat(posth(ii,2));
    cubectr(:,ii)= [0;posth(ii,1);0];
    displacement= repmat(cubectr(:,ii),1,4);
    cubev(:,:,ii)= r*cubev0+ displacement;
    cubef(:,:,ii)= r*cubef0+ displacement;
end

%% Find face closest to TxRx center
%
TxRxCtrmat= repmat(TxRxCtr,1,4);
for ii=1:Nposrot
    [~,idxclosest(ii)]= min(eucdist(TxRxCtrmat,cubef(:,:,ii)));
    facenorm(:,ii)= cubef(:,idxclosest(ii),ii)-cubectr(:,ii);
    facenorm(:,ii)= facenorm(:,ii)/norm(facenorm(:,ii));
    viewvec(:,ii)= TxRxCtr-cubef(:,idxclosest(ii),ii);
    viewvec(:,ii)= viewvec(:,ii)/norm(viewvec(:,ii));
    incang(ii)= abs(acos(dot(viewvec(:,ii),facenorm(:,ii)))*180/pi);
end

%%
p_idx = repmat((1:1:4)', [6,1]); 
r_idx = kron( (1:1:6)', ones(4,1));
check_mat = [ p_idx, r_idx, incang']

check_less_15 = find ( incang < 15 )' ;
check_greater_30 = find( incang > 30)' ;

class_1 = check_mat (check_less_15,1:2)     % (p,r )
class_2 = check_mat (check_greater_30,1:2)



%% BINARY CLASSIFICATION - INCIDENT ANGLE < 15 (1 )  INCIDENT ANDLE > 30 (2)

%%
A = cell(4,6);

for ii = 1:1:4
    for jj = 1:1:6
        str = strcat('cube_p',num2str(ii),'_','r',num2str(jj));
        file_name = strcat(str,'.mat');
        cube_data = load(file_name) ; 
        A{ii,jj} = cube_data.(str); 
       clear str
       clear file_name
       
    end
end

%% TRAIN TEST - 2 CLASSES
[ x y] = size( A{1,1});

clear A_train
clear A_test
A_train = [];  %4776 points x 100 features
A_test = [];    %4776 points x 100 features

train_labels =  [ones(7*100,1) ; 2*ones(7*100,1)]  ;
test_labels = train_labels ; 

c_mat = [ class_1(1:7,:) ; class_2(1:7,:)];

%%

for ii = 1:1:14

    A_train = cat(1,A_train,transpose(A{c_mat(ii,1),c_mat(ii,2)}(:,1:100)));  
    A_test = cat(1,A_test,transpose(A{c_mat(ii,1),c_mat(ii,2)}(:,101:200))); 
 
end

%% Random Subsampling  s= 50  (50/100 reduction of frequency measurements)
s = 50 ; % s_max = 100 features
[ A_train_red, idx_red] = rand_subsample( A_train, s );


A_test_red = A_test(:, idx_red); 
%NORMALIZE DATA 
A_train_norm = normalize_mat(A_train_red);
A_test_norm = normalize_mat(A_test_red);


%%
scores_2_classes = zeros(10,1);
vec = 10:10:100 ;
tic;
for ii = 1:1:10
    nn = vec(ii);
    mdl_2_classes = fitcknn(A_train_norm,train_labels,'NumNeighbors',nn) ;
    label_test = predict(mdl_2_classes,A_test_norm);
    scores_2_classes(ii) = sum( label_test == test_labels ) / length(test_labels);
    clear mdl_2_classes
    clear label_test
end
toc;
% scores_24_clases = the percent correct classification using 10,20,...100 Nearest
% Neighbors 

idx = find(scores_2_classes == max (scores_2_classes)) ; 
vec = 10:10:100;
Best_NN_2 = vec(idx)
Best_Score_2_classes = scores_2_classes(idx)

%% FKT APPROACH 
%% Create data structure for MDA-FKT function
%
% create cell, each data vector is a COLUMN so must transpose
C= 2;  % # of classes
N1train = 700 ;
N2train = N1train ;

Cell_train = cell(1,2);
Cell_train{1,1} = transpose(A_train_red(1:N1train, :));
Cell_train{1,2} = transpose(A_train_red((N1train+1):end, :));
tic;
[Q,V]= mda_fkt(Cell_train);
% Optimum proj onto k-dim subspace:  Q*V(:,1:k)
toc;


%% Classify

Xtrain_all= A_train;
labeltrain_all= train_labels;
Xtest_all= A_test;
labeltest_all= test_labels;
classnames= {'Incident Angle < 15'; 'Incident Angle > 30'}
scores = zeros(size(V,2),1);
tic;


for k = 1:size(V,2) 
    
    Proj_Mat = Q*V(:,randperm(100,k)); 
    Ctrain = abs(Xtrain_all*Proj_Mat);
    Ctest = abs(Xtest_all*Proj_Mat);
    
    mdl_mkt_fda = fitcknn(Ctrain,labeltrain_all,'NumNeighbors',2) ;
    label_test_mda = predict(mdl_mkt_fda,Ctest);

    scores(k) = sum( label_test_mda == labeltest_all ) / length(labeltest_all);
    
end
toc;
%% plot 2D and 3D MDA/FKT projections

load 'MDA_FKT_100f_samples_incident_angles.mat'
numdim= 2; %change to 3 for 3D projection
figure;
if numdim==3
    plot3(Ctrain(1:N1train,1),Ctrain(1:N1train,2),Ctrain(1:N1train,3),'k*',Ctrain((N1train+1):end,1),...
       Ctrain((N1train+1):end,2),Ctrain((N1train+1):end,3),'go')
      grid on ;
      title('MDA-FKT Random Projection [3-D case] 100% samples')
else
    plot(Ctrain(1:N1train,1),Ctrain(1:N1train,2),'k*', ...
        Ctrain((N1train+1):end,1),Ctrain((N1train+1):end,2),'go')
    grid on ;
     title('MDA-FKT Random Projection [2-D case] 100% random samples')
end
legend(classnames{1},classnames{2})

 
%save('MDA_FKT_100f_random_projection_samples_incident_angles.mat')     

