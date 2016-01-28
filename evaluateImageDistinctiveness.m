% This function takes in target and filler image features and a set of
% memorability scores for all the target images.
% It computes the negative log likelihood of each target image with respect
% to the other targets and fillers (in feature space). 
% We call this "contextual distinctiveness" (the distinctiveness of this image
% in the context of all the other targets and fillers).
% This distinctiveness is then correlated with a number of memorability
% measurements (hit rate, false alarm rate, accuracy, dprime, and mutual
% information).

% Zoya Bylinskii and Phillip Isola, last modified: Oct. 2015

% Cite:
% Z. Bylinskii, P. Isola, C. Bainbridge, A. Torralba, A. Oliva
% "Intrinsic and extrinsic effects on image memorability"
% Vision research, 2015

function [p_all, p_evaled_all] = evaluateImageDistinctiveness(feats_targets,feats_fillers,opts)
% feats_targets should be an (ntargets x feature_dim) matrix (note, you can
% specify one target at a time by passing in feats_targets as a 1 x feature_dim vector)
% feats_fillers should be an (nfillers x feature_dim) matrix

% PARAMETERS
if nargin < 4
    % kde params
    opts.kde.tol = 0.001; % tolerance for kd-tree approximation (lower means better approximation)
    opts.kde.kernel_type = 'e'; % 'e' = epanechnikov, 'g' = gaussian
    opts.kde.bw_selection = 'lcv'; % 'lcv' = leave-one-out cross validation (bandwidth selected to maximize probability of left out data)
end
% ------------

% compute features using only the filler images:
allfeats = feats_fillers;
% or using the features of both targets and fillers:
% allfeats = [feats_targets ; feats_fillers];

% probability model under all context
fprintf('Estimating kernel density...'); tic;
p_all = kde(allfeats',opts.kde.bw_selection,[],opts.kde.kernel_type);       
fprintf('%2.2f sec\n',toc);

% evaluated probabilities under p_all
fprintf('Evaluating probabilities...'); tic
p_evaled_all = evaluate(p_all,feats_targets',opts.kde.tol);            
fprintf('%2.2f sec\n',toc);

fprintf('Done everything.\n');
