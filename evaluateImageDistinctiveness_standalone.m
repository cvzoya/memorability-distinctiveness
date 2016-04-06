% This function takes in target and filler (optional) image features.
% It computes the negative log likelihood of each target image with respect
% to the other targets (and fillers) in feature space. 
% We call this "contextual distinctiveness": the distinctiveness of this image
% in the context of all the other targets (and fillers).
% This distinctiveness can then be correlated with image scores (like
% memorability).

% Unlike evaluateImageDistinctiveness.m, this function can be run
% independently of any other function. This function does not compute or 
% output any memorability scores. It is only for distinctiveness
% calculation. Also, this function does not assume that the features have 
% already undergone dimensionality reduction or rescaling.  

% Zoya Bylinskii and Phillip Isola, last modified: Apr. 2016

% Cite:
% Z. Bylinskii, P. Isola, C. Bainbridge, A. Torralba, A. Oliva
% "Intrinsic and extrinsic effects on image memorability"
% Vision research, 2015

function [p_all, p_evaled_all] = evaluateImageDistinctiveness_standalone(feats_targets,feats_fillers,opts,postproc)
% feats_targets should be an (ntargets x feature_dim) matrix (note, you can
% specify one target at a time by passing in feats_targets as a 1 x feature_dim vector)
% feats_fillers should be an (nfillers x feature_dim) matrix if provided,
% but can be left out entirely; in this case, the likelihood of all the
% target features will be calculated in the context of all the other targets

% PARAMETERS
if nargin < 3
    % kde params
    opts.kde.tol = 0.001; % tolerance for kd-tree approximation (lower means better approximation)
    opts.kde.kernel_type = 'e'; % 'e' = epanechnikov, 'g' = gaussian
    opts.kde.bw_selection = 'lcv'; % 'lcv' = leave-one-out cross validation (bandwidth selected to maximize probability of left out data)
end
if nargin < 4
    postproc = 1;
end
% ------------

if nargin < 2 % only target features provided
    allfeats = feats_targets;  
else
    if size(feats_targets,2)~=size(feats_fillers,2)
        error('Target and filler features should have the same feature dimensions.'); 
    end
    % combine target and filler features for joint dimensionality reduction and
    % rescaling
    allfeats = [feats_targets ; feats_fillers];
    ntargets = size(feats_targets,1);
    nfillers = size(feats_fillers,1);
end

if postproc
    % dimensionality reduction is performed for computational efficiency
    % (choose a number of dimensions that makes sense for your problem), or 
    % comment out this line
    allfeats = pca(allfeats,10);
    % this rescales the feature values into a valid range:
    allfeats_rescaled = mat2gray(allfeats);
else
    allfeats_rescaled = allfeats; 
end

if nargin < 2
    feats_targets_rescaled = allfeats_rescaled;
else
    % separate the processed features back into targets and fillers
    feats_targets_rescaled = allfeats_rescaled(1:ntargets,:);
    feats_fillers_rescaled = allfeats_rescaled((ntargets+1):end,:);
end

% probability model under all context
fprintf('Estimating kernel density...'); tic;
% can choose to estimate density using all features, or only filler features
p_all = kde(allfeats_rescaled',opts.kde.bw_selection,[],opts.kde.kernel_type);   
%p_all = kde(feats_fillers_rescaled',opts.kde.bw_selection,[],opts.kde.kernel_type);  
fprintf('%2.2f sec\n',toc);

% evaluated probabilities under p_all
fprintf('Evaluating probabilities...'); tic
p_evaled_all = evaluate(p_all,feats_targets_rescaled',opts.kde.tol);            
fprintf('%2.2f sec\n',toc);

fprintf('Done everything.\n');
