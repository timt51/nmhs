function frmpc = friedmanmpc(pStates, seq, e)
  % A possible goal function for determining the success of hmmtrain2d
  numBins = size(pStates,2);
  frmpc = 0;
  for i = 1:numBins
    frmpc = frmpc + sum((pStates(:,i).*e(:,seq(i))).^2);
  end
  frmpc = frmpc/numBins;
