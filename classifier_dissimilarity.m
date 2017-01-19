% dissimilarity representation
% use small representation of 5% of the whole dataset
% the dissimilarity is based on pixels
%small_reps = gendat(dataset_pixel_basic, 0.1);
%dis_cityblock = proxm(small_reps,'c');
%dis_euclidean = proxm(small_reps,'d',2);
%dis_euclidean = distm(small_reps);
%dataset_pixel_cityblock = dataset_pixel_basic*dis_cityblock;
%dataset_pixel_euclidean = dataset_pixel_basic*dis_euclidean;

% classifier evaluation for dissimilarity
% list of classifier to test : ldc, qdc, knnc, parzenc, loglc, nmc, fisherc, svc,
% bpxnc (neural network), treec?, rnnc, lmnc, neurc

% parametric classifier : ldc, qdc, loglc, fisherc, svc
%par_clas_dis = {ldc([]),qdc([]),nmc([]),fisherc([]),loglc([])};
%[E_par_dis_cb, S_par_dis_cb] = prcrossval(dataset_pixel_cityblock, par_clas_dis, 10, 2);
%[E_par_dis_eu, S_par_dis_eu] = prcrossval(dataset_pixel_euclidean, par_clas_dis, 10, 2);

% non parametric classifier : knnc, parzenc
%nonpar_clas_dis = {knnc([],2),knnc([],3),knnc([],4),knnc([],5),parzenc([])};
%[E_nonpar_dis_cb, S_nonpar_dis_cb] = prcrossval(dataset_pixel_cityblock, nonpar_clas_dis, 10, 2);
%[E_nonpar_dis_eu, S_nonpar_dis_eu] = prcrossval(dataset_pixel_euclidean, nonpar_clas_dis, 10, 2);

% support vector machine with radial basis
%svc_clas_dis = {bpxnc([])};
%[E_neural_dis_cb, S_neural_dis_cb] = prcrossval(dataset_pixel_cityblock, neural_clas_dis, 10, 2);
%[E_neural_dis_eu, S_neural_dis_eu] = prcrossval(dataset_pixel_euclidean, neural_clas_dis, 10, 2);

% neural network (bpxnc)
%neural_clas_dis = {bpxnc([])};
%[E_neural_dis_cb, S_neural_dis_cb] = prcrossval(dataset_pixel_cityblock, neural_clas_dis, 10, 2);
%[E_neural_dis_eu, S_neural_dis_eu] = prcrossval(dataset_pixel_euclidean, neural_clas_dis, 10, 2);

% neural network (lmnc)
%lneural_clas_dis = {lmnc([])};
%[E_lneural_dis_cb, S_lneural_dis_cb] = prcrossval(dataset_pixel_cityblock, lneural_clas_dis, 10, 2);
%[E_lneural_dis_eu, S_lneural_dis_eu] = prcrossval(dataset_pixel_euclidean, lneural_clas_dis, 10, 2);

% using feature selection for dissimilarity
% let's try to use 3-NN as the classifier
%featsel_dis_clas = knnc([],3);
%featnum = [1:1:250]; % based on which features to use
%mf = max(featnum) % max feature

%[trn_dis_cb, tst_dis_cb] = gendat(dataset_pixel_cityblock,0.5);
%[trn_dis_eu, tst_dis_eu] = gendat(dataset_pixel_euclidean,0.5);

% city block first
%trn_set = trn_dis_cb;
%tst_set = tst_dis_cb;
%[w,r] = featseli(trn_set,'eucl-s',mf);
%e1 = clevalf(trn_set*w,featsel_dis_clas,featnum,[],1,tst_set*w);
%[w,r] = featself(trn_set,'eucl-s',mf)
%e2 = clevalf(trn_set*w,featsel_dis_clas,featnum,[],1,tst_set*w);
%[w,r] = featselb(trn_set,'eucl-s',mf)
%e3 = clevalf(trn_set*w,featsel_dis_clas,featnum,[],1,tst_set*w);

% Screen Shot 2017-01-17 at 7.57.02 PM
% based on the plot for clevalf above, it's better to use all features
% plote({e1,e2,e3})
% legend({'i','f','b'})

% now let's try PCA in 3-NN,4-NN,5-NN
%featnum = [1:5:250];
% featnum = [1:10:250];
%res_3NN = zeros(size(featnum));
%res_4NN = zeros(size(featnum));
%res_5NN = zeros(size(featnum));

% now let's try PCA in 3-NN,4-NN,5-NN
%featnum = [1:5:250];
% featnum = [1:10:250];
%res_3NN = zeros(size(featnum));
%res_4NN = zeros(size(featnum));
%res_5NN = zeros(size(featnum));

%for c = featnum
%    pca_dis_3NN = knnc([],3);
%    pca_dis_4NN = knnc([],4);
%    pca_dis_5NN = knnc([],5);    
%    wp = pcam([],c); % find pca c-features
%    c
%    res_3NN(c) = prcrossval(dataset_pixel_cityblock,wp*pca_dis_3NN,10,2);
%    res_4NN(c) = prcrossval(dataset_pixel_cityblock,wp*pca_dis_4NN,10,2);
%    res_5NN(c) = prcrossval(dataset_pixel_cityblock,wp*pca_dis_5NN,10,2);
%end

% final verdict : feature reduction is not possible for diss representation

% next, let's try some combiner into 3-NN,4-NN,5-NN
% for scenario 2, it's better to use ldc,fisher,parzenc
w1 = parzenc([]);
w2 = fisherc([]);
%w3 = parzenc([]);
combinerProd = [w1 w2]*prodc;
combinerMean = [w1 w2]*meanc;
combinerMin = [w1 w2]*minc;
combinerMax = [w1 w2]*maxc;
combinerMedian = [w1 w2]*medianc;
combinerVote = [w1 w2]*votec;
combinerAll = {combinerProd, combinerMean, combinerMin, combinerMax, combinerMedian, combinerVote};
%[E_combiner_dis_cb, S_combiner_dis_cb] = prcrossval(dataset_pixel_cityblock, combinerAll, 10, 2);
[E_combiner_dis_cb_prod, S_combiner_dis_cb_prod] = prcrossval(dataset_pixel_cityblock, combinerProd, 10, 2);
[E_combiner_dis_cb_mean, S_combiner_dis_cb_mean] = prcrossval(dataset_pixel_cityblock, combinerMean, 10, 2);
[E_combiner_dis_cb_min, S_combiner_dis_min] = prcrossval(dataset_pixel_cityblock, combinerMin, 10, 2);
[E_combiner_dis_cb_max, S_combiner_dis_cb_max] = prcrossval(dataset_pixel_cityblock, combinerMax, 10, 2);
[E_combiner_dis_cb_median, S_combiner_dis_cb_median] = prcrossval(dataset_pixel_cityblock, combinerMedian, 10, 2);
[E_combiner_dis_cb_vote, S_combiner_dis_cb_vote] = prcrossval(dataset_pixel_cityblock, combinerProd, 10, 2);


