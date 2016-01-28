% Zoya Bylinskii and Phillip Isola, last modified: Oct. 2015

% Cite:
% Z. Bylinskii, P. Isola, C. Bainbridge, A. Torralba, A. Oliva
% "Intrinsic and extrinsic effects on image memorability"
% Vision research, 2015

function [MI] = calcMI(pmf)
    
    assert(length(size(pmf))==2); % pdf needs to be a 2D pmf
    
    pmf_1 = sum(pmf,2); % marginal over first variable
    pmf_2 = sum(pmf,1); % marginal over second variable
    
    MI = 0;
    for i=1:size(pmf,1)
        for j=1:size(pmf,2)
            MI = MI+ pmf(i,j)*log(pmf(i,j)/(pmf_1(i)*pmf_2(j)));
        end
    end
end