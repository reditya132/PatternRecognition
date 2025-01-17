% Dissimilarity representation
% Classifier evaluation for dissimilarity

% Dataset initialization
% For scenario 1, use dp_cb and dp_euc
% For scenario 2, use dp_cb_small and dp_euc_small
% For scenario 2, can also _dk (deskew)
tst_dis_cb = dp_cb_small_dk;
tst_dis_euc = dp_euc_small_dk;

% Parametric classifier : ldc, qdc, loglc, fisherc, svc
par_clas_dis = {ldc([]),qdc([]),nmc([]),fisherc([]),loglc([])};
[E_par_dis_cb, S_par_dis_cb] = prcrossval(tst_dis_cb, par_clas_dis, 10, 2);
[E_par_dis_eu, S_par_dis_eu] = prcrossval(tst_dis_euc, par_clas_dis, 10, 2);

% non parametric classifier : knnc, parzenc
nonpar_clas_dis = {knnc([],2),knnc([],3),knnc([],4),knnc([],5),parzenc([])};
[E_nonpar_dis_cb, S_nonpar_dis_cb] = prcrossval(tst_dis_cb, nonpar_clas_dis, 10, 2);
[E_nonpar_dis_eu, S_nonpar_dis_eu] = prcrossval(tst_dis_euc, nonpar_clas_dis, 10, 2);

% neural network (bpxnc)
neural_clas_dis = {bpxnc([])};
[E_neural_dis_cb, S_neural_dis_cb] = prcrossval(tst_dis_cb, neural_clas_dis, 10, 2);
[E_neural_dis_eu, S_neural_dis_eu] = prcrossval(tst_dis_euc, neural_clas_dis, 10, 2);

% neural network (lmnc)
lneural_clas_dis = {lmnc([])};
[E_lneural_dis_cb, S_lneural_dis_cb] = prcrossval(tst_dis_cb, lneural_clas_dis, 10, 2);
[E_lneural_dis_eu, S_lneural_dis_eu] = prcrossval(tst_dis_euc, lneural_clas_dis, 10, 2);

% using feature selection for dissimilarity
% let's try to use 3-NN as the classifier as 3-NN is the best classifier
% for dissimilarity, based on prcrossval result above
% for scenario 2, change into ldc([]) with 10 featnum
featsel_dis_clas = ldc([]);
featnum = [1:1:10]; % For scenario 1, it's 250, scenario 2, it's 10
mf = max(featnum) % max feature

[trn_cb, tst_cb] = gendat(tst_dis_cb,0.5);
[trn_eu, tst_eu] = gendat(tst_dis_euc,0.5);

% city block first
trn_set = trn_cb;
tst_set = tst_cb;
[w,r] = featseli(trn_set,'eucl-s',mf);
e1 = clevalf(trn_set*w,featsel_dis_clas,featnum,[],1,tst_set*w);
[w,r] = featself(trn_set,'eucl-s',mf)
e2 = clevalf(trn_set*w,featsel_dis_clas,featnum,[],1,tst_set*w);
[w,r] = featselb(trn_set,'eucl-s',mf)
e3 = clevalf(trn_set*w,featsel_dis_clas,featnum,[],1,tst_set*w);

% Screen Shot 2017-01-17 at 7.57.02 PM
% based on the plot for clevalf above, it's better to use all features
plote({e1,e2,e3})
legend({'i','f','b'})

% now let's try PCA in 3-NN,4-NN,5-NN
%featnum = [1:5:250];
% featnum = [1:10:250];
%res_3NN = zeros(size(featnum));
%res_4NN = zeros(size(featnum));
%res_5NN = zeros(size(featnum));

% now let's try PCA in 3-NN,4-NN,5-NN
featnum = [1:5:250];
%featnum = [1:10:250];
res_3NN = zeros(size(featnum));
%res_4NN = zeros(size(featnum));
%res_5NN = zeros(size(featnum));

for c = featnum
    pca_dis_3NN = knnc([],3);
%    pca_dis_4NN = knnc([],4);
%    pca_dis_5NN = knnc([],5);    
    wp = pcam([],c); % find pca c-features
    c
    res_3NN(c) = prcrossval(tst_dis_cb,wp*pca_dis_3NN,10,2);
%    res_4NN(c) = prcrossval(tst_dis_cb,wp*pca_dis_4NN,10,2);
%    res_5NN(c) = prcrossval(tst_dis_cb,wp*pca_dis_5NN,10,2);
end

% final verdict : feature reduction is not possible for diss representation

% next, let's try some combiner into 3-NN,4-NN,5-NN
% for scenario 2, it's better to use ldc,fisher,parzenc
%w1 = knnc([],3);
%w2 = knnc([],4);
%w3 = knnc([],5);
w1 = ldc([]);
w2 = fisherc([]);
combElements = [w1 ; w2];
combinerProd = combElements*prodc;
combinerMean = combElements*meanc;
combinerMin = combElements*minc;
combinerMax = combElements*maxc;
combinerMedian = combElements*medianc;
combinerVote = combElements*votec;
combinerAll = {combinerProd, combinerMean, combinerMin, combinerMax, combinerMedian, combinerVote};
%[E_combiner_dis_cb, S_combiner_dis_cb] = prcrossval(tst_dis_cb, combinerAll, 10, 2);
%tst_dis_cb = dataset_deskew_small;
tst_dis_cb = [tst_dis_euc tst_dis_euc];
[E_combiner_dis_cb_prod, S_combiner_dis_cb_prod] = prcrossval(tst_dis_cb, combinerProd, 10, 2);
[E_combiner_dis_cb_mean, S_combiner_dis_cb_mean] = prcrossval(tst_dis_cb, combinerMean, 10, 2);
[E_combiner_dis_cb_min, S_combiner_dis_cb_min] = prcrossval(tst_dis_cb, combinerMin, 10, 2);
[E_combiner_dis_cb_max, S_combiner_dis_cb_max] = prcrossval(tst_dis_cb, combinerMax, 10, 2);
[E_combiner_dis_cb_median, S_combiner_dis_cb_median] = prcrossval(tst_dis_cb, combinerMedian, 10, 2);
[E_combiner_dis_cb_vote, S_combiner_dis_cb_vote] = prcrossval(tst_dis_cb, combinerProd, 10, 2);
