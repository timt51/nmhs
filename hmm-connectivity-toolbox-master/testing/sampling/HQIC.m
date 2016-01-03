function h = hqic(tr1, tr2, e1, e2, seq1, seq2, pStates1, pStates2, logL)
  %Calculate inputs for goal functions
  numParam = sum([numel(tr1), numel(tr2), numel(e1), numel(e2)]);
  numObs = length(pStates1);
  h = 2*numParam*log(log(numObs)) -2 * logL;
