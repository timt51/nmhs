function results = runTest(N, M, J, K, noise, seq_length)
  present_directory = pwd;
  cleanupObj = onCleanup(cd(present_directory));
  cd testing/helpers
  [tr1_true, tr2_true, e1_true, e2_true] = hmmgeneratematix2d(N, M, J, K, noise);
  [tr1_guess, tr2_guess, e1_guess, e2_guess] = hmmgeneratematix2d(N, M, J, K, noise);
  [seq1, seq2, states1, states2] = hmmgenerate2d(seq_length, tr1_true, tr2_true, e1_true, e2_true);
  cd(present_directory)
  [tr1_trained, tr2_trained, e1_trained, e2_trained, estimatedStates1, estimatedStates2] = hmmtrain2d(seq1, seq2, tr1_guess, tr2_guess, e1_guess, e2_guess);

  results = containers.Map;
  results('tr1_true') = tr1_true;
  results('tr1_guess') = tr1_guess;
  results('tr1_trained') = tr1_trained;
  results('seq1') = seq1;
  results('states1') = states1;
  results('e1_true') = e1_true;
  results('e1_guess') = e1_guess;
  results('e1_trained') = e1_trained;      

  results('tr2_true') = tr2_true;
  results('tr2_guess') = tr2_guess;
  results('tr2_trained') = tr2_trained;
  results('seq2') = seq2;
  results('states2') = states2;
  results('e2_true') = e2_true;
  results('e2_guess') = e2_guess;
  results('e2_trained') = e2_trained;

