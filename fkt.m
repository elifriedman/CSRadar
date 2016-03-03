%% Generate dataset
D = 2; % num dimensions
C = 2; % num classes
N = 100; % num data per class
close all

ms = rand(D,C)*6-3;
vars = zeros(D,D,C);

A = {};
test = zeros(D,N/2,C);
S = zeros(D,D,C);
for i = 1:C
    vs = rand(D,D)*2-1;
    vars(:,:,i) = vs*vs';
    A{i} = mvnrnd(ms(:,i),vars(:,:,i),N/2)';
    test(:,:,i) = mvnrnd(ms(:,i),vars(:,:,i),N/2)';
    S(:,:,i) = A{i}*A{i}';
end

St = S(:,:,1)+S(:,:,2);
[U,V] = eigs(St);
P = U*inv(V)^(.5);

Sp1 = P'*S(:,:,1)*P;
Sp2 = P'*S(:,:,2)*P;
[q1,v1] = eigs(Sp1);
v = diag(v1);
proj1 = q1(:,1);
proj2 = q1(:,2);


subsp1 = proj1*proj1'*test(:,:,1);
subsp2 = proj1*proj1'*test(:,:,2);

plot(test(1,:,1),test(2,:,1),'ro',test(1,:,2),test(2,:,2),'go')
title('original test data')
figure
plot(subsp1(1,:),subsp1(2,:),'ro',subsp2(1,:),subsp2(2,:),'go')
title('projected test data')

subsp12 = proj2*proj2'*test(:,:,1);
subsp22 = proj2*proj2'*test(:,:,2);
figure
plot(subsp12(1,:),subsp12(2,:),'ro',subsp22(1,:),subsp22(2,:),'go')
title('projected test data (lambda_2)')