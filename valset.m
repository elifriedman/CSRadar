function varargout = valset( X, y, fracTrain, fracVal )
%VALSET Creates a train, validation and test set from the data
%       [indxTrain,indxVal,indxTest] = valset(X,y,fracTrain,fracVal)
%       returns the indices of the training, validation, and test
%       sets where the training set has approximately fracTrain*length(y)
%       elements, the validation set has around fracVal*length(y) elements
%       and the test set has (1 - fracTrain - fracVal)*length(y) elements.
%
%       [Xtrain,Ytrain,Xval,Yval,Xtest,Ytest] = valset(X,y,fracTrain,fracVal)
%       returns the training, validation, and test sets where the training 
%       set has approximately fracTrain*length(y) elements, the validation 
%       set has around fracVal*length(y) elements and the test set has 
%       (1 - fracTrain - fracVal)*length(y) elements.
%   
varargout = cell(1,nargout);
n = length(y);
if fracTrain + fracVal > 1
    error('your fractions must add up to less than or equal to 1');
end
if size(X,1) ~= n
    error('First dimension of X must be same size as y')
end
ntrain = round(fracTrain*n);
nval = round(fracVal*n);
while ntrain + nval > n
    nval = nval - 1;
end
ntest = n - ntrain - nval;
ns = [ntrain, nval, ntest];
r = randperm(n);
if nargout<=3
    k = 1;
    for i = 1:nargout
        varargout{i} = r(k:k+ns(i)-1);
        k = k + ns(i);
    end
end
if nargout>3
    k = 1;
    for i = 1:(nargout+1)/2
        varargout{2*i-1} = X(r(k:k+ns(i)-1),:);
        varargout{2*i} = y(r(k:k+ns(i)-1),:);
        k = k + 1;
    end
end
end

