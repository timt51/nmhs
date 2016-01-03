function converged = logLChange(tr1, tr2, e1, e2, oldTR1, oldTR2, oldE1, oldE2, seq1, seq2)
  TOL = 1e-3; %amount by less than which tr and e must change for convergence
  oldlogL = hmm2dlikelihood(oldTR1, oldTR2, oldE1, oldE2, seq1, seq2);
  newlogL = hmm2dlikelihood(tr1, tr2, e1, e2, seq1, seq2);
  converged = (abs((newlogL-oldlogL)/oldlogL) < TOL);
  
