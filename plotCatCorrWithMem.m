% Zoya Bylinskii and Phillip Isola, last modified: Oct. 2015

% Cite:
% Z. Bylinskii, P. Isola, C. Bainbridge, A. Torralba, A. Oliva
% "Intrinsic and extrinsic effects on image memorability"
% Vision research, 2015

function plotCatCorrWithMem(x,y,cats,which_expt,feature_types,mem_measure,pre_string)

    h = plot(x,y,'.');
    [r,pval_r] = corr(x',y','Type','Pearson');
    %[rho,pval_rho] = corr(x',y','Type','Spearman');
    xlabel(sprintf('%sE[-log P(Image)]',pre_string));
    ylabel(sprintf('%sE[%s(Image)]',pre_string,mem_measure));
    B = polyfit(x,y,1);
    hold on; plot(x,B(1)*x+B(2),'k'); colorbar off;
    title(sprintf('%s\nFeatures = %s\nPearson corr = %1.2f (p = %1.2f)',...
        which_expt,feature_types,r,pval_r),'interpreter','none');
    set(gca,'ylim',[min(y),max(y)]);

    x = get(h,'Xdata'); y = get(h,'Ydata');
    cat_full = cellfun(@(x) ['  ',x],cats,'UniformOutput',false);
    text(x,y,cat_full,'Interpreter','none');
    axis('square');
end