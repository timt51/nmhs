function [trainingset1, trainingset2] = ...
    aggregateStates(states1, states2, obs1, obs2, numstates1, numstates2)
% Creates training subsets for the 1D part of hmmtrain2d based on the state
% of the *other* neuron
%
% states1 and 2 are sequences of states, obs1 and 2 are their corresponding 
% observation sequences
% trainingset1 and 2 are sets of sequences re-shuffled from observations
% based on the state sequences

% TODO: check obs and states are all same length
% TODO: can maybe optimize to not iterate over the entire states sequence
% numstates times
% TODO: pre-allocate worst-case-scenario size for trainingset and
% workingseq and then trim it down (will this actually make it faster?)


if ~exist('numstates1', 'var') || ~exist('numstates2', 'var')
    numstates1 = numel(unique(states1));
    numstates2 = numel(unique(states2));
end

%break up states1 into chunks based on states2
trainingseq = [];
trainingset1 = {};
for s = 1:numstates2
    trainingsubset = {};
    for i = 2:size(states2,2) %CHANGED THIS TO START INDEXING AT 2
        if states2(i-1) == s %CHANGED FROM i to i-1
            trainingseq = [trainingseq, obs1(i)];
        else
            if size(trainingseq,2) > 0
                trainingsubset{end+1} = trainingseq;
                trainingseq = [];
            end
        end 
    end
    if size(trainingseq,2) > 0
        trainingsubset{end+1} = trainingseq;
        trainingseq = [];
    end
    trainingset1{end+1} = trainingsubset;
end

%break up states2 into chunks based on states1
trainingseq = [];
trainingset2 = {};
for s = 1:numstates1
    trainingsubset = {};
    for i = 2:size(states1,2)  %CHANGED THIS TO START INDEXING AT 2
        if states1(i-1) == s %CHANGED FROM i to i-1
            trainingseq = [trainingseq, obs2(i)];
        else
            if size(trainingseq,2) > 0
                trainingsubset{end+1} = trainingseq;
                trainingseq = [];
            end
        end 
    end
    if size(trainingseq,2) > 0
        trainingsubset{end+1} = trainingseq;
        trainingseq = [];
    end
    trainingset2{end+1} = trainingsubset;
end
            
            

