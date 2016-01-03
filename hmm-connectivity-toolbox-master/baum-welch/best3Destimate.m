function [logL, packed_trained] = best3Destimate(packed3DHMM, data)
  if size(packed3DHMM, 1) == 1
    num_states1 = packed3DHMM(1);
    num_emissions1 = packed3DHMM(2);
    num_states2 = packed3DHMM(3);
    num_emissions2 = packed3DHMM(4);
    num_states3 = packed3DHMM(5);
    num_emissions3 = packed3DHMM(6);
  else
    [tr1, tr2, tr3, em1, em2, em3] = unpack3DHMM(packed3DHMM);
    num_states1 = size(tr1, 1);
    num_emissions1 = size(em1, 2);
    num_states2 = size(tr2, 1);
    num_emissions2 = size(em2, 2);  
    num_states3 = size(tr3, 1);
    num_emissions3 = size(em3, 2);  
  end

  
  seq1 = data{1};, seq2 = data{2};, seq3 = data{3};


  tr1_guess = archetypeLookup3D('null hypothesis', num_states1);
  em1_guess = squeeze(rand(num_states1, num_emissions1));
  em1_guess = bsxfun(@rdivide, em1_guess, sum(em1_guess, 2));
  
  tr2_guess = archetypeLookup3D('null hypothesis', num_states2);
  em2_guess = squeeze(rand(num_states2, num_emissions2));
  em2_guess = bsxfun(@rdivide, em2_guess, sum(em2_guess, 2));

  tr3_guess = archetypeLookup3D('null hypothesis', num_states3);
  em3_guess = squeeze(rand(num_states3, num_emissions3));
  em3_guess = bsxfun(@rdivide, em3_guess, sum(em3_guess, 2));

  packed_guess = pack3DHMM(tr1_guess, tr2_guess, tr3_guess, em1_guess, em2_guess, em3_guess);
  
  %run 1d hmmtrain on the data
  [packed_trained, logLs] = ...
  baum_welch3d(packed_guess, seq1, seq2, seq3);
  logL = logLs(length(logLs));
end
