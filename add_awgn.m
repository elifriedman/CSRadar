function [PSNR_vec, A_noisy] = add_awgn( A, noise_power_vec )
% measure PSNR tolerance 
[m, n ] = size(A);

A_noisy  = zeros(m,n, length(noise_power_vec) ) ;
noise_mat = zeros(m,n, length(noise_power_vec) ) ; 

PSNR_vec = zeros(size(noise_power_vec); 

for ii = 1 : length(noise_power_vec)
   noise_mat(:,:,ii) = sqrt(0.5./noise_power_vec(ii)).*( randn(m,n)+ j*randn(m,n)) ;
   
   A_noisy(:,:,ii) = noise_mat(:,:,ii) + A ; 
   
   PSNR_vec(ii) = psnr(A_noisy,A) ; 
     
end


end

