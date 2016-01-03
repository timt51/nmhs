function bool = isMarkov(matrix)
% Returns true if matrix satisfies the Markov property (every row must sum
% to 1, within a margin of error of eps(1)). Returns false otherwise. Meant
% for matrices as defined in the MATLAB HMM suite of functions (hmmtrain, 
% hmmdecode, etc), where the rows (not columns) of TR and E matrices must
% sum to 1.

bool = false;

shouldBeOnes = sum(matrix,2);
areEqual = shouldBeOnes == ones(size(shouldBeOnes));


for i = 1:length(areEqual)
    if areEqual(i) == false
        if (shouldBeOnes(i) - eps(1) == 1) || (shouldBeOnes(i) + eps(1) == 1)
            areEqual(i) = true;
        end
    end
end

if areEqual
    bool = true;
end

