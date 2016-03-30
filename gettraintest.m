function [A_train,A_test] = gettraintest(D,ntrain_vec,num_test,ms,vs)


C = length(ntrain_vec);

A_train = {};
A_test = zeros(D+1,num_test);
randorder = randi(C,num_test,1);

for i = 1:C
    if ~exist('ms','var')
        m = rand(D,1)*6-3;
    else
        m = ms(:,i)';
    end
    if ~exist('vs','var')
        v = rand(D,D)*2-1;
        v = v*v';
    else
        v = vs(:,:,i);
    end
    A_train{i} = mvnrnd(m,v,ntrain_vec(i))';
    A_test(1:D,randorder==i) = mvnrnd(m,v,sum(randorder==i))';
    A_test(D+1,randorder==i) = i;
end
end