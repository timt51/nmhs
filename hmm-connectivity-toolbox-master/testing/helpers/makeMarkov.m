function markov = makeMarkov(N, M)
%Returns a random NxM Markov matrix (rows sum to 1)

markov = rand(N, M);
rowSums = sum(markov,2);
normalizingMatrix = repmat(rowSums,1,M);
markov = markov./normalizingMatrix;
    
end