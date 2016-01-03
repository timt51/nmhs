function [logL, model] = best1DestimateOf3D(packed3DHMM, data)

  [tr1, tr2, tr3, em1, em2, em3] = unpack3DHMM(packed3DHMM);
  seq1 = data{1};, seq2 = data{2};, seq3 = data{3};
  
  num_states1 = size(tr1, 1);
  num_emissions1 = size(em1, 2);
  tr1_guess = archetypeLookup('null hypothesis', num_states1);
  tr1_guess = squeeze(tr1_guess(:,:,1));
  em1_guess = squeeze(rand(num_states1, num_emissions1));
  em1_guess = bsxfun(@rdivide, em1_guess, sum(em1_guess, 2));

  num_states2 = size(tr2, 1);
  num_emissions2 = size(em2, 2);  
  tr2_guess = archetypeLookup('null hypothesis', num_states2);
  tr2_guess = squeeze(tr2_guess(:,:,1));
  em2_guess = squeeze(rand(num_states1, num_emissions1));
  em2_guess = bsxfun(@rdivide, em2_guess, sum(em2_guess, 2));


  num_states3 = size(tr3, 1);
  num_emissions3 = size(em3, 2);  
  tr3_guess = archetypeLookup('null hypothesis', num_states3);
  tr3_guess = squeeze(tr3_guess(:,:,1));
  em3_guess = squeeze(rand(num_states1, num_emissions1));
  em3_guess = bsxfun(@rdivide, em3_guess, sum(em3_guess, 2));

  
  
  %run 1d hmmtrain on the data
  [tr3_trained, em3_trained] = hmmtrain(seq3, tr3_guess, em3_guess);
  [tr2_trained, em2_trained] = hmmtrain(seq2, tr2_guess, em2_guess);
  [tr1_trained, em1_trained] = hmmtrain(seq1, tr1_guess, em1_guess);  

  [~, logL1] = hmmdecode(seq1, tr1_trained, em1_trained);
  [~, logL2] = hmmdecode(seq2, tr2_trained, em2_trained);
  [~, logL3] = hmmdecode(seq3, tr3_trained, em3_trained);

  model = {tr1_trained, tr2_trained, tr3_trained, em1_trained, em2_trained, em3_trained};
  
  logL = logL1 + logL2 + logL3;  
end
