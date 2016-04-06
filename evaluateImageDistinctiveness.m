% This function takes in target and filler image features and a set of
% memorability scores for all the target images.
% It computes the negative log likelihood of each target image with respect
% to the other targets and fillers (in feature space). 
% We call this "contextual distinctiveness" (the distinctiveness of this image
% in the context of all the other targets and fillers).
% This distinctiveness is then correlated with a number of memorability
% measurements (hit rate, false alarm rate, accuracy, dprime, and mutual
% information).

% Zoya Bylinskii and Phillip Isola, last modified: Oct. 15

function [p_all, p_evaled_all, mem_measures, mem_measures_names] = evaluateImageDistinctiveness(scores,feats_targets,feats_fillers,opts)
% scores should be a structure with the following fields: 
%    hits, false_alarms, misses, correct_rejections
%    length(scores) should be equal to the number of target images
% so for example, scores(i).hits should be the number of hits for target image i
% feats_targets should be an (ntargets x feature_dim) matrix
% feats_fillers should be an (nfillers x feature_dim) matrix

% PARAMETERS
if nargin < 4
    % kde params
    opts.kde.tol = 0.001; % tolerance for kd-tree approximation (lower means better approximation)
    opts.kde.kernel_type = 'e'; % 'e' = epanechnikov, 'g' = gaussian
    opts.kde.bw_selection = 'lcv'; % 'lcv' = leave-one-out cross validation (bandwidth selected to maximize probability of left out data)
end
% ------------

ntargets = length(scores);
assert(ntargets==size(feats_targets,1));

fprintf('Calculating scores...'); tic

[mem_measures,mem_measures_names] = calculateScores(scores);

fprintf('%2.2f sec\n',toc);


allfeats = [feats_targets ; feats_fillers];

% probability model under all context
fprintf('Estimating kernel density...'); tic;
p_all = kde(allfeats',opts.kde.bw_selection,[],opts.kde.kernel_type);       
fprintf('%2.2f sec\n',toc);

% evaluated probabilities under p_all
fprintf('Evaluating probabilities...'); tic
p_evaled_all = evaluate(p_all,feats_targets',opts.kde.tol);            
fprintf('%2.2f sec\n',toc);

fprintf('Done everything.\n');
