function bool = isGoodTrainingSet(seqs)
% Helper function for hmmtrain2d. Checks to see if the training set that
% was created by aggregateStates is valid (i.e. not empty and large enough)
% - seqs is a set of training sequences from aggregatestates (1xN cell)

MIN_NUMBER_OF_TRANSITIONS = 300;

bool = true;

if isempty(seqs)
    bool = false;
    warning('Empty training set')
    return
else
    numSeqs = size(seqs, 2);
    numTransitions = 0;
    for i = 1:numSeqs
        nTransInSeq = size(seqs{i}, 2) - 1;
        if nTransInSeq > 0 
            numTransitions = numTransitions + nTransInSeq;
        end
    end
    if numTransitions < MIN_NUMBER_OF_TRANSITIONS
        bool = false;
        warning('Training set too small. Size = %d', numTransitions)
    end
end
    

    

