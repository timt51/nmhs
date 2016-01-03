%markov_data is a cell that contains the original hmm, the hmm's neighbor, and the observed sequence
function [samples, scalars1, scalars2] = samplePlane(vec, dims, markov_data, axis1, axis2, num_samples1, num_samples2, goal_function_namelist)
  [mn1, mx1] = scalarBounds(vec, dims, axis1);
  [mn2, mx2] = scalarBounds(vec, dims, axis2);  
  scalars1 = (((1:num_samples1)-1) *(mx1-mn1)/(num_samples1-1)) + mn1;
  scalars2 = (((1:num_samples2)-1) *(mx2-mn2)/(num_samples2-1)) + mn2;
  samples = cellfun(@(x){[]}, goal_function_namelist);

  tr1 = markov_data('tr1');
  tr2 = markov_data('tr2');
  em1 = markov_data('em1');
  em2 = markov_data('em2');
  seq1 = markov_data('seq1');
  seq2 = markov_data('seq2');
  [states1, pStates1] = hmmdecode2d(seq1, tr1, em1);
  [states2, pStates2] = hmmdecode2d(seq2, tr2, em2);
  
  goal_functions = cellfun(@(x){str2func(x)}, goal_function_namelist);
  for j = 1:num_samples1
      for i =1:num_samples2
        [t,em] = hmmVector2Mat(vec+axis1*scalars1(j)+axis2*scalars2(i), dims);
        %[states, pStates]
        [states1, pStates1] = hmmdecode2d(seq1, t, em);
        logL = hmm2dlikelihood(t, tr2, em, em2, seq1, seq2);
        for f = 1:length(goal_function_namelist)
          gf_samples = samples{f};
          gf = goal_functions{f};
          gf_samples(i, j) = gf(t, tr2, em, em2, seq1, seq2, pStates1, pStates2, logL);
          samples{f} = gf_samples;          
        end
      end
  end
  samples = containers.Map(goal_function_namelist, samples);
end


         
