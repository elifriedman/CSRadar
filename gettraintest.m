function [A_train,A_test] = gettraintest(D,ntrain_vec,num_test)
C = length(ntrain_vec);

A_train = {};
A_test = zeros(D+1,num_test);
randorder = randi(C,num_test,1);
for i = 1:C
    ms = rand(D,1)*6-3;
    vs = rand(D,D)*2-1;
    vs = vs*vs';
    A_train{i} = mvnrnd(ms,vs,ntrain_vec(i))';
    A_test(1:D,randorder==i) = mvnrnd(ms,vs,sum(randorder==i))';
    A_test(D+1,randorder==i) = i;
end
end