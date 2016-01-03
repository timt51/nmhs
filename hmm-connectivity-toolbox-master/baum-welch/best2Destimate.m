function [logL, tr1_trained, tr2_trained, em1_trained, em2_trained] = best2Destimate(tr1, tr2, em1, em2, seq1, seq2)

  if((size(tr1,1) == size(tr1,2)) && (size(tr1,1) ~= 1))
    num_states1 = size(tr1, 1);
    num_emissions1 = size(em1, 2);
    num_states2 = size(tr2, 1);
    num_emissions2 = size(em2, 2);  
  else
    num_states1 = tr1;
    num_emissions1 = em1;
    num_states2 = tr2;
    num_emissions2 = em2;  
  end
  tr1_guess = archetypeLookup('null hypothesis', num_states1);
  em1_guess = squeeze(rand(num_states1, num_emissions1));
  em1_guess = bsxfun(@rdivide, em1_guess, sum(em1_guess, 2));
  
  tr2_guess = archetypeLookup('null hypothesis', num_states2);
  em2_guess = squeeze(rand(num_states2, num_emissions2));
  em2_guess = bsxfun(@rdivide, em2_guess, sum(em2_guess, 2));
  
  %run 1d hmmtrain on the data
  [tr1_trained, tr2_trained, em1_trained, em2_trained, logLs] = ...
  baum_welch2d(tr1_guess, tr2_guess, em1_guess, em2_guess, seq1, seq2);
  logL = logLs(length(logLs));
end
