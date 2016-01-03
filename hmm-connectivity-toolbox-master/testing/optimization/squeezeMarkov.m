function mat = squeezeMarkov(mat)
  %ensures that mat satisfies the markov property
  mat(mat > 1) = 0.9999999;
  mat(mat < 0) = 0.0000001;
  mat = bsxfun(@rdivide, mat, sum(mat, 2));
