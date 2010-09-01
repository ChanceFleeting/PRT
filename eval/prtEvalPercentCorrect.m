function percentCorrect = prtEvalPercentCorrect(classifier,dataSet,nFolds)
% PERCENTCORRECT    Calculate percent correct of a classification operation
% 
%   PERCENTCORRECT = prtEvalPercentCorrect(CLASSIFIER, DATASET) returns the percentage
%   of correctly classified elements of DATASET when classifier by
%   CLASSIFIER. DATASET must be a labeled, prtDataSetStandard
%   object. CLASSIFIER must be a prtClass object. 
%
%   PF = prtScorePercentCorrect(CLASSIFIER, DATASET, NFOLDS)  returns the
%   percentage of correctly classified elements of DATASET when classifier
%   by CLASSIFIER with K-fold cross-validation. DATASET must be a labeled,
%   prtDataSetStandard object. CLASSIFIER must be a prtClass object.
%   NFOLDS is the number of folds in the K-fold cross-validation.
%
%   Example:
%   dataSet = prtDataGenSpiral;
%   classifier = prtClassDlrt;
%   pc =  prtEvalPercentCorrect(classifier, dataSet)
%
%   See Also: prtEvalPdAtPf, prtEvalPfAtPd, prtEvalAuc,
%   prtEvalMinCost



% Copyright 2010, New Folder Consulting, L.L.C.

assert(nargin >= 2,'prt:prtEvalPercentCorrect:BadInputs','prtEvalPercentCorrect requires two input arguments');
assert(isa(classifier,'prtClass') && isa(dataSet,'prtDataSetBase'),'prt:prtEvalPercentCorrect:BadInputs','prtEvalPercentCorrect inputs must be sublcasses of prtClass and prtDataSetBase, but input one was a %s, and input 2 was a %s',class(classifier),class(dataSet));

if nargin < 3 || isempty(nFolds)
    nFolds = 1;
end
results = classifier.kfolds(dataSet,nFolds);

if results.nFeatures == 1 %binary classifier
    [pf,pd] = prtUtilScoreRoc(results.getObservations,dataSet.getTargets);
    pe = prtUtilPfPd2Pe(pf,pd);
    minPe = min(pe);
    percentCorrect = 1-minPe;
else
    [~,guess] = max(results.getObservations,[],2);
    confusionMatrix = prtScoreConfusionMatrix(guess,dataSet.getTargets);
    percentCorrect = prtUtilConfusion2PercentCorrect(confusionMatrix);
end
  