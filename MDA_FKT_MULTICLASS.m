function [ Labels,Score,Confusion_Matrix ] = MDA_FKT_MULTICLASS( A_train,  A_test )
%UNTITLED3 Summary of this function goes here
%   ALGORITHM 2 - COMPUTE QR DECOMPOSITION FOR MDA/FKT APPROACH
% data matrix (A) 

%initialization
n_train = zeros ( [ len(A_train), 1]);
train_label = (1:len(A_train))'; 


test_label = A_test(end,:); %not given but used to compute score

A_test = A_test(1:end-1,:); %test matrix

D = size(A_train(:,:,1),1);

for ii = 1 : size(A_train,3)    
    n_train(ii,1) = size(A_train{ii},2) ;
end

%% STEP 1 

%PART A - COMPUTE H_I

N_I = sum(n_train.*(n_train-1)/2);
H_I = zeros(D,N_I);

idx = 1;
for ii = 1: len(A_train) % loop through classes
    for jj = 1:n_train(ii) % loop through samples in a class
        for kk = jj+1:n_train(ii)
            H_I(:,idx) = A_train{ii}(:,jj)-A_train{ii}(:,kk);
            idx = idx+1;
        end
    end
end

H_I = (1/sqrt(N_I) )* H_I ; 
            
%PART B = 

        
    end

    
    
end







  

end

