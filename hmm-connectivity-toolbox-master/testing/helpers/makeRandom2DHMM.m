function mat = makeRandom2DHMM(N, M)
  mat = rand(N, N, M);
  mat = bsxfun(@rdivide, mat, sum(mat, 2));
end
