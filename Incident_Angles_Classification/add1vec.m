function c= add1vec(a,b)
%% function c= add1vec(a,b)
%
% a= Mx1 vec, b= MxN matrix, c= add a to each col of b
%
[M,N]= size(b);
s= size(a);
if s(1)~=M | s(2)~=1
    disp('size of a is:')
    size(a)
    disp('size of b is:')
    size(b)
    error('a, b not compatible')
end
c= b+repmat(a,1,N);

end

    