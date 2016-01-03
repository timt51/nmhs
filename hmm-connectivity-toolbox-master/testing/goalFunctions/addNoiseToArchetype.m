%noise is roughly the number of percentage points by which each factor may vary
function mat = addNoiseToArchetype(mat, variability)
  noise = rand(size(mat)).*mat * variability / 100;
  mat = mat + noise;
  mat = bsxfun(@rdivide, mat, sum(mat,2)); %renormalize
