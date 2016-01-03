function [logL, tr1_trained, tr2_trained, em1_trained, em2_trained] = best1Destimate(tr1, tr2, em1, em2, seq1, seq2)

  num_states1 = size(tr1, 1);
  num_emissions1 = size(em1, 2);
  tr1_guess = archetypeLookup('null hypothesis', num_states1);
  tr1_guess = squeeze(tr1_guess(:,:,1));
  em1_guess = squeeze(zeros(num_states1, num_emissions1) + 1/(num_emissions1));

  num_states2 = size(tr2, 1);
  num_emissions2 = size(em2, 2);  
  tr2_guess = archetypeLookup('null hypothesis', num_states2);
  tr2_guess = squeeze(tr2_guess(:,:,1));
  em2_guess = squeeze(zeros(num_states2, num_emissions2) + 1/(num_emissions2));

  
  
  %run 1d hmmtrain on the data
  [tr2_trained, em2_trained] = hmmtrain(seq2, tr2_guess, em2_guess);
  [tr1_trained, em1_trained] = hmmtrain(seq1, tr1_guess, em1_guess);  
  logL = -hmm1D_fitness(pack1DHMM(tr1_trained, tr2_trained, em1_trained, em2_trained), {seq1, seq1});
end
