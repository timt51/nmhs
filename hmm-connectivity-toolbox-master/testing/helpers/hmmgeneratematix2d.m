function [tr1, tr2, e1, e2] = hmmgeneratematix2d(N, M, J, K, noise)
% Randomly generates a set of Markov matrices that are used to create an
% HMM. Each row sums to 1.
% - N is the number of states in tr1
% - M is the number of states in tr2
% - J is the number of emissionsin e1
% - K is the number of emissions in e2
% Therefore: tr1 is NxNxM, tr2 is MxMxN, e1 is NxJ, e2 is MxK

if N > J || M > K
    error('Should not have more states than emissions.')
    %TODO: or is this actually ok?
end

% each matrix is uniformly random
if nargin == 4
    e1 = makeMarkov(N, J);
    e2 = makeMarkov(M, K);
    tr1 = zeros(N,N,M);
    for i = 1:M
        tr1(:,:,i) = makeMarkov(N, N);
    end
    tr2 = zeros(M,M,N);
    for i = 1:N
        tr2(:,:,i) = makeMarkov(M,M);
    end
end

% each matrix is an identity matrix plus noise
if nargin == 5
    e1 = addNoise(eye(N, J), noise);
    e2 = addNoise(eye(M, K), noise);
    
    tr1 = zeros(N,N,M);
    for i = 1:M
        tr1(:,:,i) = addNoise(eye(N), noise);
    end
    tr2 = zeros(M,M,N);
    for i = 1:N
        tr2(:,:,i) = addNoise(eye(M), noise);
    end
end
    

%Make sure I didn't mess everything up
mtxs = {tr1, tr2, e1, e2};
sizes = [M, N, 1, 1];
for m=1:4
  mtx = mtxs{m};
  for i=1:sizes(m)
    if ~isMarkov(mtx(:,:,i))
      error('Fatal: Something went wrong generating the matrix. Not Markovian')
    end
  end
end





