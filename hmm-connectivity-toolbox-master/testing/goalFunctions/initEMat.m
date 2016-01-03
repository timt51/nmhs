%assume square matrix for testing
function e = initEMat(states, noise)
  e = diag(ones(states,1));
  e = e + rand(states) * noise/100;
  e = bsxfun(@rdivide, e, sum(e')'); %normalize so that rows sum to 1
