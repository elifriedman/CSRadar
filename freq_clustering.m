d = 101;
N = 24;
X = zeros(N,d);
prefix = 'fwd_csradar_mat_files/Voltage_new_case';
for i = 1:24
    s = strcat(prefix,int2str(i),'.mat');
    load(s)
    X(i,:) = transpose(x);
end

X = abs(X);
X = X - ones(N,1)*mean(X,1);
X = X ./ (ones(N,1)*std(X,1));
