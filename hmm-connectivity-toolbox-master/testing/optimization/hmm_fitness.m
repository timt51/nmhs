function f = hmm_fitness(model, data)
  [tr1, tr2, em1, em2] = unpack2DHMM(model);
  seq1 = data{1};
  seq2 = data{2};
  [~,~,s] = forward_backward2d(tr1, tr2, em1, em2, seq1, seq2);
  f = -sum(log(s));
