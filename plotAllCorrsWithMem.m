% Zoya Bylinskii and Phillip Isola, last modified: Oct. 2015

% Cite:
% Z. Bylinskii, P. Isola, C. Bainbridge, A. Torralba, A. Oliva
% "Intrinsic and extrinsic effects on image memorability"
% Vision research, 2015

function fig = plotAllCorrsWithMem(p_evaled_all,mem_measures,mem_measures_names,plotOpts)

if nargin < 4 || ~isfield(plotOpts, 'whichexp')
    plotOpts.whichexp = '';
end
if nargin < 4 || ~isfield(plotOpts, 'feature')
    plotOpts.feature = '';
end

fig = figure(); colormap('hot');
fig_main = figure('units','normalized','outerposition',[0 0 1 1]); colormap('hot');
for i = 1:length(mem_measures)
    x = p_evaled_all;
    y = mem_measures{i};
    figure(fig_main);
    subplot(1,length(mem_measures),i);
    if isfield(plotOpts, 'cats')
        plotCatCorrWithMem(x,y,plotOpts.cats,plotOpts.whichexp,plotOpts.feature,mem_measures_names{i},'');
    else
        plotCorrWithMem(x,y,plotOpts.whichexp,plotOpts.feature,mem_measures_names{i},'');
    end
    if i == 1
        figure(fig);
        if isfield(plotOpts, 'cats')
            plotCatCorrWithMem(x,y,plotOpts.cats,plotOpts.whichexp,plotOpts.feature,mem_measures_names{i},'');
        else
            plotCorrWithMem(x,y,plotOpts.whichexp,plotOpts.feature,mem_measures_names{i},'');
        end
    end
end
set(gca,'color','w');



