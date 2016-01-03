function converged = modelChange(tr1, tr2, e1, e2, oldTR1, oldTR2, oldE1, oldE2, seq1, seq2)
  numStates1 = size(tr1, 2); %number of states neuron 1 can be in (N)
  numStates2 = size(tr2, 2); %number of states neuron 2 can be in (M)
  numEmissions1 = size(e1, 2); %number of possible emissions by neuron 1
  numEmissions2 = size(e2, 2); %number of possible emissions by neuron 2
  TOL = 1e-6; %amount by less than which tr and e must change for convergence
  converged = false;
  % check convergence
  if sum(sum(sum(abs(tr1 - oldTR1)))) / numStates1 < TOL
    if sum(sum(sum(abs(tr2 - oldTR2)))) / numStates2 < TOL
      if sum(sum(abs(e1 - oldE1)))/numEmissions1 < TOL
        if sum(sum(abs(e2 - oldE2)))/numEmissions2 < TOL
          converged = true;
        end
      end
    end
  end
