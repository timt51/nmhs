% num_events will generally be on the order of 4k-10k for the ephys experiements
% Alexander has been doing (as of 9-24-14)
function make1DGraph(n1_name, n2_name, false_archetype_name, num_trials,...
                     noise_coeff, gf_names, num_events, num_samples, ...
                     fpath, normalize_plot)
  % generate hmm's from archetype names and noise coefficient
  tr1 = archetypeLookup(n1_name);
  tr2 = archetypeLookup(n2_name);
  tr_false = archetypeLookup(false_archetype_name);
  
  %simple emission matrix: two roughly diagonal matrices appended to each other with noise. Corresponds roughly to two primary emissions per state. 
  em1 = [initEMat(3, 20), initEMat(3, 20)];
  em1 = bsxfun(@rdivide, em1, sum(em1')');

  em2 = [initEMat(3, 20), initEMat(3, 20)];
  em2 = bsxfun(@rdivide, em2, sum(em2')');

  em_false = [initEMat(3, 20), initEMat(3, 20)];
  em_false = bsxfun(@rdivide, em_false, sum(em_false')');

  
  % generate sequences of events on which to evaluate the hmms
  [seq1, seq2, states1, states2] = hmmgenerate2d(num_events, tr1, tr2, em1, em2);
  markov_data = containers.Map({'seq1', 'seq2', 'states1', 'states2', 'tr1', ...
                                'tr2', 'em1', 'em2', 'tr_false', 'em_false'}, ...
                               {seq1, seq2, states1, states2, tr1, ...
                                tr2, em1, em2, tr_false, em_false});


  [vec, dims] = vectorize2Dhmm(tr1, em1);
  [vec_false, dims] = vectorize2Dhmm(tr_false, em_false);
  %dirty hack to get two orthogonal vectors skew to the default basis
  axis = (vec_false-vec) / norm(vec_false-vec);
  
  [samples, scalars] = sampleAxis(vec, dims, markov_data, axis, ...
                                              num_samples, gf_names);
  
  trial_parameters = containers.Map({'noise_coeff', 'gf_names', 'num_events',...
                                     'num_samples', 'axis', 'scalars'}, ...
                                    {noise_coeff, gf_names, num_events, ...
                                   num_samples, axis, scalars});
  
  data=containers.Map({'samples', 'markov data', 'trial parameters', 'names'}, ...
                      {samples, markov_data, trial_parameters, ...
                     {n1_name, n2_name, false_archetype_name}});
  filename = strcat(n1_name, '; ', n2_name, ';', int2str(noise_coeff), '.mat')
  save(strcat(fpath, '/', filename), 'data');

  graphHMMGoalFunctions1D(samples, scalars, n1_name, n2_name, false_archetype_name, ...
                          num_trials, data, normalize_plot);
  
  
