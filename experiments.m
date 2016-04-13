%% EXPERIMENT  - CLASSIF. ON ORIGINAL FEATURE SPACE     X_original , 
clc; clear all; close all ; 
Range_profile = readdata('Rotation_1.csv'); % M by 2048
%noise
Range_profile = transpose(Range_profile) ;


%%
mu = mean(Range_profile(:)) ;

var = std(Range_profile(:))^2 ;

Range_profile_n = mu + sqrt(var/2)* ... 
           (randn(0.5*size(Range_profile,1),size(Range_profile,2)) + ...  
            j*randn(0.5*size(Range_profile,1),size(Range_profile,2)));

%%
X_original = [Range_profile((1:0.5*size(Range_profile,1)),:) ; Range_profile_n ] ;   %2M by N 

X_original = abs(X_original);

T = [ ones( size(Range_profile_n,1) ,1) ; zeros( size(Range_profile_n,1) ,1) ] ;

%%
%training
mdl = fitcknn(X_original,T,'NumNeighbors',10) ;


%testing
RP_test = Range_profile((0.5*size(Range_profile,1)+1:end),:) ;  

Noise_test =  mu + sqrt(var/2)* ... 
           (randn(0.5*size(Range_profile,1),size(Range_profile,2)) + ...  
            j*randn(0.5*size(Range_profile,1),size(Range_profile,2))); 

X_test = abs( [RP_test ; Noise_test ]) ; 

[label_test] = predict(mdl,X_test );

score =  sum ( label_test == T ) / length(T) 


%% MDA_FKT
C_TRAIN = cell(2,1);

C_TRAIN{1} = abs(Range_profile((1:0.5*size(Range_profile,1)),:)) ; 

C_TRAIN{2} = abs(Range_profile_n) ; 




[Q_TRAIN,V_TRAIN] = mda_fkt(C_TRAIN) ;

 
%%
C_TEST{1} = abs(RP_test) ; 

C_TEST{2} = abs(Noise_test) ; 




for k = 1:1: size(V,2) 

 

    Proj_Mat = Q*V(:,1:k); 

for i = 1:2
    C_proj(:,:,i) = C_TEST{i}'*Proj_mat;
    
end

X_test_mkt_fda = abs( [C_TEST{1} ; C_TEST{2} ]) ; 
mdl_mkt_fda = fitcknn(X_test_mkt_fda,T,'NumNeighbors',10) ;
[label_test_mda] = predict(mdl_mkt_fda,X_test_mkt_fda );

score_mda =  [sum ( label_test_mda == T ) / length(T)  , k ]

end






