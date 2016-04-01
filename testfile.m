%% TOY 1
clc; clear all; close all;
C = zeros(3,3,3);
C(:,:,1) = [1,1,0]'*[1,1,0] + 0.1*[0,1,1]'*[0,1,1];
C(:,:,2) = [0,1,1]'*[0,1,1] + 0.1*[1,0,1]'*[1,0,1];
C(:,:,3) = [1,0,1]'*[1,0,1] + 0.1*[1,1,0]'*[1,1,0];
[A_train,A_test] = gettraintest(3,[100 100 100],1,zeros(3,3),C);
proj_mat = mda_fkt(A_train,2);
figure
hold on
s = {'ob','.k','xg'};
for i = 1:3
    plot3(A_train{i}(1,:),A_train{i}(2,:),A_train{i}(3,:),s{i});
end
hold off
figure
hold on
for i = 1:3
    A_proj = proj_mat'*A_train{i};
    plot(A_proj(1,:),A_proj(2,:),s{i});
end
hold off


%% TOY 2

 clc; clear all ; close all;
C = 0.5*repmat(eye(3,3),[1,1,4]);

means = zeros(3,4);
means(:,2) = [1;10;0];
means(:,3) = [20*sqrt(3);-20;0];
means(:,4) = [-20*sqrt(3);-20;0];

[A_train,A_test] = gettraintest(3,[150 50 50 50],1,means,C);


A_train{2} = [A_train{2} A_train{3} A_train{4}];
A_train(:,3:end) = []; % should only have 2 classes, remove extra



[proj_mat] = mda_fkt(A_train,2);



figure
hold on
s = {'ob','.k','xg'};
for i = 1:2
    plot3(A_train{i}(1,:),A_train{i}(2,:),A_train{i}(3,:),s{i});
end
hold off
figure
hold on

for i = 1:2
    A_proj = A_train{i}'*proj_mat;
    plot(A_proj(:,1),A_proj(:,2),s{i});
end
hold off

%% DIGIT RECOGNITION
feat = [dlmread('mfeat/mfeat-fou') dlmread('mfeat/mfeat-fac')...
        dlmread('mfeat/mfeat-mor') dlmread('mfeat/mfeat-kar')...
        dlmread('mfeat/mfeat-zer') dlmread('mfeat/mfeat-pix')];
feat = (feat-ones(size(feat,1),1)*mean(feat));
feat = feat./(ones(size(feat,1),1)*var(feat));

classize = 200;
trainsize = 30;
testsize = classize-trainsize;
C = 10;
A_train = {};
A_test = zeros(size(feat,2)+1,C*testsize);
for i = 1:C
    r=randperm(classize) + (i-1)*classize;
    A_train{i} = feat(r(1:trainsize),:);
    dim = (i-1)*classize+1;
    A_test(1:end-1,dim:dim+testsize-1) = feat(r(trainsize+1:end),:)';
    A_test(end,dim:dim+testsize-1) = i;
end
    
proj_mat = mda_fkt(A_train,A_test,2);