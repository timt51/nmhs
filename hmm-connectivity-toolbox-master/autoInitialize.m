function [tr1, tr2, e1, e2] = autoInitialize(seq1, seq2, nStates1, nStates2, nEmissons1, nEmissions2)
% Attempts to create a good initial guess for hmmtrain2d to use. nStates and
% nEmissions arguments are optional

if nargin > 2
% if we happen to have some information about the number of states or emissions
% TODO: parse arguments to specify a subset of N, M, J, K
    N = nStates1;
    M = nStates2;
    J = nEmissions1;
    K = nEmission2;
end

tr1 = zeros(N,N,M);
tr2 = zeros(M,M,N);
e1 = zeros(N, J);
e2 = zeros(M, K);


[tr1, tr2, e1, e2] = hmmgeneratematix2d(N, M, J, K, noise)

