function [samples, scalars] = sampleAxis(vec, dims, markov_data, axis, num_samples, goal_function_namelist)
  [mn, mx] = scalarBounds(vec, dims, axis);
  scalars = (((1:num_samples)-1) *(mx-mn)/(num_samples-1)) + mn;
  samples = cellfun(@(x){[]}, goal_function_namelist);
  goal_functions = cellfun(@(x){str2func(x)}, goal_function_namelist);

  tr1 = markov_data('tr1');
  tr2 = markov_data('tr2');
  em1 = markov_data('em1');
  em2 = markov_data('em2');
  seq1 = markov_data('seq1');
  seq2 = markov_data('seq2');
  [states2, pStates2] = hmmdecode2d(seq2, tr2, em2);
  
  for j = 1:num_samples
      [t,em] = hmmVector2Mat(vec+axis*scalars(j), dims);
      [states1, pStates1] = hmmdecode2d(seq1, t, em);
      logL = hmm2dlikelihood(t, tr2, em, em2, seq1, seq2);
      for f = 1:length(goal_function_namelist)
        gf_samples = samples{f};
        gf = goal_functions{f};
        gf_samples(j) = gf(t, tr2, em, em2, seq1, seq2, pStates1, pStates2, logL);
        samples{f} = gf_samples;          
      end
  end
  samples = containers.Map(goal_function_namelist, samples);
end
