function [ground_truth, guess, data, gt_logL, guess_logL] = generate3DModel(archetypes, seq_length)
  num_states1 = 2; num_states2 = 2; num_states3 = 2;
  num_emissions1 = 4; num_emissions2 = 4; num_emissions3 = 4;  
  tr1 = archetypeLookup3D(archetypes{1});
  tr2 = archetypeLookup3D(archetypes{2});         
  tr3 = archetypeLookup3D(archetypes{3});
  em1 = [0.45, 0.45, 0.05, 0.05; 0.05, 0.05, 0.45, 0.45];
  em2 = em1;
  em3 = em2;

  ground_truth = pack3DHMM(tr1,tr2,tr3,em1,em2,em3);
  
  [seq1, seq2, seq3] = hmmgenerate3d(seq_length, tr1,tr2,tr3,em1,em2,em3);
  data = {seq1, seq2, seq3};
  
  tr1_guess = archetypeLookup3D('null hypothesis', num_states1);
  tr2_guess = archetypeLookup3D('null hypothesis', num_states2);
  tr3_guess = archetypeLookup3D('null hypothesis', num_states3);  
  em1_guess = squeeze(rand(num_states1, num_emissions1));
  em1_guess = bsxfun(@rdivide, em1_guess, sum(em1_guess, 2));
  em2_guess = squeeze(rand(num_states1, num_emissions1));
  em2_guess = bsxfun(@rdivide, em2_guess, sum(em2_guess, 2));
  em3_guess = squeeze(rand(num_states1, num_emissions1));
  em3_guess = bsxfun(@rdivide, em3_guess, sum(em3_guess, 2));

  guess = pack3DHMM(tr1_guess,tr2_guess,tr3_guess,em1_guess,em2_guess,em3_guess);

  if (nargout > 3)
    gt_logL = hmmLogL3D(ground_truth, data);
  end
  if (nargout > 4)
    guess_logL = hmmLogL3D(guess, data);
  end
