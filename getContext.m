% Zoya Bylinskii and Phillip Isola, last modified: Oct. 2015

% Cite:
% Z. Bylinskii, P. Isola, C. Bainbridge, A. Torralba, A. Oliva
% "Intrinsic and extrinsic effects on image memorability"
% Vision research, 2015

function [target_inds,filler_inds] = getContext(whichExp,image_data_targets,image_data_fillers)
% can be a category name (e.g. 'amusement_park') for AMT1 images 
% or 'all' for AMT2 images

load('amt2demo_filenames.mat');

target_inds = 1:length(image_data_targets);
filler_inds = 1:length(image_data_fillers);

if strcmp(whichExp,'all')
    indrem = [];
    for i = 1:length(image_data_fillers)
        if image_data_fillers(i).isdemo && ...
          ~ismember(image_data_fillers(i).filename,filenames)
            indrem = [indrem,i];
        end
    end
    filler_inds(indrem) = [];
    return
end

allcats = unique({image_data_targets().category});
assert(ismember(whichExp,allcats),'Must specify a valid category name.')

target_inds = find(strcmp({image_data_targets().category},whichExp));

filler_inds = find(strcmp({image_data_fillers().category},whichExp));
