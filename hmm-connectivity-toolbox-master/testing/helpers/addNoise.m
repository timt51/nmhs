function randomized = addNoise(matrix, noise)
% Adds uniform noise to a Markov matrix 
% - matrix must be a Markov matrix
% - noise is a number greater than zero. A higher value means more noise.
% When setting this option, remember that the input matrix has no entries
% greater than 1, so noise = 1 would result in an SNR of 1 (50% noise)

if noise < 0
    error('Value for noise must be greater than zero')
end

if ~isMarkov(matrix)
    error('Input matrix must be Markovian (rows sum to 1)')
end


noiseMatrix = noise * rand(size(matrix));
randomized = matrix + noiseMatrix;
rowSums = sum(randomized,2);
normalizingMatrix = repmat(rowSums,1,size(randomized,2));
randomized = randomized./normalizingMatrix;

%sanity check
if ~isMarkov(randomized)
    error('Fatal: Something went wrong randomizing the matrix. Not Markovian')
end