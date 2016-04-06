% Zoya Bylinskii and Phillip Isola, last modified: Apr. 2016

% Cite:
% Z. Bylinskii, P. Isola, C. Bainbridge, A. Torralba, A. Oliva
% "Intrinsic and extrinsic effects on image memorability"
% Vision research, 2015

% This file reproduces all the correlation plots in the paper and
% supplement.

%% load all prerequisites
clear all;

% replace with your own directory where you have downloaded the data files
% from http://figrim.mit.edu/
maindir = '../DATAFILES_forSharing'; 

addpath(genpath('toolbox'));
addpath(genpath('util'));

% files with memorability scores for all the images
load(fullfile(maindir,'image_data_targets.mat')); 
load(fullfile(maindir,'image_data_fillers.mat'));

% a list of all the scene category names and labels
load(fullfile(maindir,'sceneTypes'));

% image matrices
img_t = load(fullfile(maindir,'img_targets'));
img_f = load(fullfile(maindir,'img_fillers'));

% feature matrices
%gist_t = load(fullfile(maindir,'gist_targets'));
%gist_f = load(fullfile(maindir,'gist_fillers'));
%fc7_t = load(fullfile(maindir,'fc7_targets'));
%fc7_f = load(fullfile(maindir,'fc7_fillers'));
deep_scene_t = load(fullfile(maindir,'deep_scene_targets'));
deep_scene_f = load(fullfile(maindir,'deep_scene_fillers'));

ntargets = length(image_data_targets);

%% dimensionality reduction on features of all images at once

% ----- choose and load desired feature -----
%curfeature = 'gist';
%curfeature = 'fc7';
curfeature = 'deep_scene';
%allfeats = [gist_t.gist ; gist_f.gist]';
%allfeats = [fc7_t.fc7s' ; fc7_f.fc7s']';
allfeats = [deep_scene_t.deep_scene ; deep_scene_f.deep_scene]';
% ----------------------------------------

% dimensionality reduction and feature rescaling
K = 10;
allfeats = mat2gray(pca(allfeats',K));
allfeats_t = allfeats(1:ntargets,:);
allfeats_f = allfeats((ntargets+1:end),:);

%% contextual distinctiveness of image w.r.t. whole dataset

whichexp = 'amt2'; % [don't change this] to do this, need scores w.r.t. whole dataset
opts.kde.tol = 0.001; 
opts.kde.kernel_type = 'e'; 
opts.kde.bw_selection = 'lcv';

[target_inds,filler_inds] = getContext('all',image_data_targets,image_data_fillers);

data_t = image_data_targets(target_inds);
data_f = image_data_fillers(filler_inds);
feats_t = allfeats_t(target_inds,:);
feats_f = allfeats_f(filler_inds,:);

fprintf('Running analysis on: ntargets=%d, nfillers=%d\n',length(data_t),length(data_f));
scores = struct();
for i = 1:ntargets
   scores(i).hits = data_t(i).(whichexp).hits;
   scores(i).misses = data_t(i).(whichexp).misses;
   scores(i).false_alarms = data_t(i).(whichexp).false_alarms;
   scores(i).correct_rejections = data_t(i).(whichexp).correct_rejections;
end
[p_all, p_evaled_all, mem_measures, mem_measures_names] = evaluateImageDistinctiveness(scores,feats_t,feats_f,opts);
all_nll = -log(p_evaled_all);
all_mem_measures = mem_measures;

% plot the results
plotOpts = struct();
plotOpts.whichexp = whichexp;
plotOpts.feature = curfeature;
plotAllCorrsWithMem(all_nll,mem_measures,mem_measures_names,plotOpts);

%% entropy of each category

whichexp = 'amt1'; % [don't change this] since looking at each category, consider scores w.r.t category
opts.kde.tol = 0.001; 
opts.kde.kernel_type = 'e'; 
opts.kde.bw_selection = getBW(p_all,1);

category_nll = nan(1,length(cats));
p_evaled_inst = nan(1,length(image_data_targets));

category_scores = cell(1,length(mem_measures));
inst_mem_measures = cell(1,length(mem_measures));
for j = 1:length(mem_measures)
    category_scores{j} = nan(1,length(cats));
    inst_mem_measures{j} = nan(1,length(image_data_targets));
end

for i = 1:length(cats)
    [target_inds,filler_inds] = getContext(cats{i},image_data_targets,image_data_fillers);
    data_t = image_data_targets(target_inds);
    data_f = image_data_fillers(filler_inds);
    feats_t = allfeats_t(target_inds,:);
    feats_f = allfeats_f(filler_inds,:);
    
    scores = struct();
    for ii = 1:length(data_t)
       scores(ii).hits = data_t(ii).(whichexp).hits;
       scores(ii).misses = data_t(ii).(whichexp).misses;
       scores(ii).false_alarms = data_t(ii).(whichexp).false_alarms;
       scores(ii).correct_rejections = data_t(ii).(whichexp).correct_rejections;
    end
    
    fprintf('Running analysis on %s: ntargets=%d, nfillers=%d\n',cats{i},length(data_t),length(data_f));
    [p_inst_cur, p_evaled_inst_cur, mem_measures, mem_measures_names] = evaluateImageDistinctiveness(scores,feats_t,feats_f,opts);
    
    p_evaled_inst(target_inds) = p_evaled_inst_cur;
    category_nll(i) = mean(-log(p_evaled_inst_cur));
    
    for j = 1:length(mem_measures)
        category_scores{j}(i) = mean(mem_measures{j});
        inst_mem_measures{j}(target_inds) = mem_measures{j};
    end
end

% plot the results
plotOpts = struct();
plotOpts.cats = cats;
plotOpts.whichexp = whichexp;
plotOpts.feature = curfeature;

plotAllCorrsWithMem(category_nll,category_scores,mem_measures_names,plotOpts);

%% contextual distinctiveness of image w.r.t. its own category
temp = -log(p_evaled_inst);

% plot the results
plotOpts = struct();
plotOpts.whichexp = 'amt1';
plotOpts.feature = curfeature;
plotAllCorrsWithMem(temp,inst_mem_measures,mem_measures_names,plotOpts);

%% correlate change in image probability with change in memorability

nll_diff = -log(p_evaled_all) - -log(p_evaled_inst); % how much rarer are images under all context than under inst context

mem_measures_diff = cell(1,length(mem_measures));
for j = 1:length(mem_measures)
    mem_measures_diff{j} = all_mem_measures{j} - inst_mem_measures{j};
end

% plot the results
plotOpts = struct();
plotOpts.whichexp = 'amt2-amt1';
plotOpts.feature = curfeature;
plotAllCorrsWithMem(nll_diff,mem_measures_diff,mem_measures_names,plotOpts);


%% correlate change in category probability with change in memorability
% cluster all results by scene category

category_diff_nll = nan(1,length(cats));
mem_measures_cat_diff = cell(1,length(mem_measures));

for i = 1:length(cats)
   ind = find(strcmp({image_data_targets().category},cats{i})); 
   category_diff_nll(i) = mean(-log(p_evaled_all(ind))) - category_nll(i);
   for j = 1:length(mem_measures)
        mem_measures_cat_diff{j}(i) = mean(all_mem_measures{j}(ind)) - category_scores{j}(i);
    end
end

% plot the results
plotOpts = struct();
plotOpts.cats = cats;
plotOpts.whichexp = 'amt2 - amt1, by category';
plotOpts.feature = curfeature;

fig = plotAllCorrsWithMem(category_diff_nll,mem_measures_cat_diff,mem_measures_names,plotOpts);



