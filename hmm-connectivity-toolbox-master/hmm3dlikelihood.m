function logL = hmm3dlikelihood(tr1,tr2,tr3,em1,em2,em3,seq1,seq2,seq3)
  [~, ~, gt_s] = forward_backward3d(tr1, tr2, tr3, em1, em2, em3, seq1, seq2, seq3);
  logL = sum(log(gt_s));
