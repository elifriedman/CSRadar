
%% EXPERIMENT  - CLASSIF. ON ORIGINAL FEATURE SPACE     X_original , 
Range_profile = readdata('Rotation_1.csv'); % M by 2048
%noise
Range_profile = Range_profile.' ;

%%
var = 0.5

Range_profile_n =  sqrt(var)*randn(0.5*size(Range_profile,1),size(Range_profile,2)) ;


X_original = [Range_profile((1:0.5*size(Range_profile,1)),:) ; Range_profile_n ] ;   %2M by N 


T = [ ones( size(Range_profile_n,1) ,1) ; zeros( size(Range_profile_n,1) ,1) ] ;

%training
mdl = fitcknn(X_original,T,'NumNeighbors',10) ;


%testing
RP_test = Range_profile((0.5*size(Range_profile,1)+1:end),:) ;  

Noise_test = sqrt(var)*randn(0.5*size(Range_profile,1),size(Range_profile,2)) ;

X_test =  [RP_test ; Noise_test ] ; 

[label_test] = predict(mdl, X_test) ; 

score =  sum ( label_test == T ) / length(T) ; 


%%

