function f = frmpc(tr1, tr2, e1, e2, seq1, seq2, pStates1, pStates2, logL)
  %Not the original FriedmanMPC. This one looks at both sequences 
  %simultaneously. I don't know if that's dumb or not. 
  numParam = sum([numel(tr1), numel(tr2), numel(e1), numel(e2)]);
  numObs = length(pStates1);
  numBins = size(pStates1,2);
  f = 0;
  for i = 1:numBins
    f = f + sum((pStates1(:,i).*e1(:,seq1(i))).^2); %first seq
    f = f + sum((pStates2(:,i).*e2(:,seq2(i))).^2); %second seq
  end
  f = f/(numBins*2);
