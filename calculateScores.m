% Zoya Bylinskii and Phillip Isola, last modified: Oct. 2015

% Cite:
% Z. Bylinskii, P. Isola, C. Bainbridge, A. Torralba, A. Oliva
% "Intrinsic and extrinsic effects on image memorability"
% Vision research, 2015

function [mem_measures,mem_measures_names] = calculateScores(measurements)
% measurements should be a structure with the following fields: 
%    hits, false_alarms, misses, correct_rejections
%    length(measurements) should be equal to the number of target images
% so for example, measurements(i).hits should be the number of hits for target image i

% this function computes and returns the following 5 scores:
% HR (hit rate), FAR (false alarm rate), ACC (accuracy), DPRIME (d-prime),
% MI (mutual information)

% mem_measures is a cell with 5 vectors, one corresponding to each of the
% above 5 scores; and mem_measures_names is just a cell with 5 strings,
% with the corresponding name of each of the score vectors in mem_measures

reg = 0.1; % regularization for MI calculation

ntargets = length(measurements);

hm = [measurements().hits]+[measurements().misses];
fc = [measurements().false_alarms]+[measurements().correct_rejections];

hrs = [measurements().hits]./(hm);
fars = [measurements().false_alarms]./(fc);
accs = ([measurements().hits]+[measurements().correct_rejections])./(hm+fc);

dp = nan(1,ntargets);
mis = nan(1,ntargets);
for i = 1:ntargets
   dp(i) = dprime(hrs(i),fars(i),hm(i),fc(i)); 
   pmf = [measurements(i).correct_rejections, measurements(i).misses; measurements(i).false_alarms, measurements(i).hits] + reg;
   pmf = pmf./sum(pmf(:));
   mis(i) = calcMI(pmf);
end

mem_measures = {hrs,fars,accs,dp,mis};
mem_measures_names = {'HR','FAR','ACC','DPRIME','MI'};