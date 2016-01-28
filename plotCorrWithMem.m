% Zoya Bylinskii and Phillip Isola, last modified: Oct. 2015

% Cite:
% Z. Bylinskii, P. Isola, C. Bainbridge, A. Torralba, A. Oliva
% "Intrinsic and extrinsic effects on image memorability"
% Vision research, 2015

function [] = plotCorrWithMem(x,y,which_expt,feature_types,mem_measure,pre_string)

    [r,pval_r] = corr(x',y','Type','Pearson');
    %[rho,pval_rho] = corr(x',y','Type','Spearman');
    B = polyfit(x,y,1);
    scatplot(x,y,[],[],[],[],[],10); hold on; plot(x,B(1)*x+B(2),'k'); colormap('hot'); colorbar off;

    title(sprintf('%s\nFeatures = %s\nPearson corr = %1.2f (p = %1.2f)',...
        which_expt,feature_types,r,pval_r),'interpreter','none');
    xlabel(sprintf('%s-log P(Image)',pre_string));
    ylabel(sprintf('%s%s(Image)',pre_string,mem_measure));
    %set(gca,'ylim',[0,1]);
    axis('square');
end