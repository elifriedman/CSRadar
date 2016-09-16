function [cdata] = load_corner_data(D, k, sub_idx)
% D is dimension, either 50 or 100
% k is length of "subsquare" to include
% sub_idx is a list of indexes, used for subsampling

% loads data, MM, NN, N (# points per cell)
% data is size MM x NN x D x N
load(sprintf('corner_d%d.mat',D))

sub_D = length(sub_idx);
MM = 15;
NN = 15;

KM = floor(MM/k);
KN = floor(NN/k);

cdata = zeros(sub_D*k*k, N*KM*KN);

cnt = 1;
for ii = 1:k:KM*k
    for jj = 1:k:KN*k


        datapoint = zeros(sub_D*k*k, N);
        kcnt = 1;
        for ki = 0:k-1
            for kj = 0:k-1
                datapoint((kcnt-1)*sub_D + 1: kcnt*sub_D,:) = squeeze(data(ii + ki, jj + kj, sub_idx,:));
                kcnt = kcnt + 1;
            end
        end

        cdata(:, (cnt-1)*N + 1: cnt*N) = datapoint;
        cnt = cnt + 1;
    end
end

end
