function f = hmm1D_fitness(model, data)
  [tr1, tr2, em1, em2] = unpack1DHMM(model);
  seq1 = data{1};
  seq2 = data{2};
  [~, logL1] = hmmdecode(seq1, tr1, em1);
  [~, logL2] = hmmdecode(seq2, tr2, em2);
  f = -(logL1+logL2);
