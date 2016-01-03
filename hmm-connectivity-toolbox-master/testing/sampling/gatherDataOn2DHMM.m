% num_events will generally be on the order of 4k-10k for the ephys experiements Alexander has been doing (as of 9-24-14)
function gatherDataOn2DHMM(n1_name, n2_name, num_trials, noise_coeff, gf_names, num_events, ...
                           num_samples1, num_samples2, filepath)
  % generate hmm's from archetype names and noise coefficient
  tr1 = archetypeLookup(n1_name);
  tr2 = archetypeLookup(n2_name);

  %simple emission matrix: two roughly diagonal matrices appended to each other with noise. Corresponds roughly to two primary emissions per state. 
  em1 = [initEMat(3, 20), initEMat(3, 20)];   em1 = bsxfun(@rdivide, em1, sum(em1')');
  em2 = [initEMat(3, 20), initEMat(3, 20)];   em2 = bsxfun(@rdivide, em2, sum(em2')');
  
  % generate sequences of events on which to evaluate the hmms
  [seq1, seq2, states1, states2] = hmmgenerate2d(num_events, tr1, tr2, em1, em2);
  markov_data = containers.Map({'seq1', 'seq2', 'states1', 'states2', 'tr1', ...
                                'tr2', 'em1', 'em2'}, ...
                               {seq1, seq2, states1, states2, tr1, ...
                                tr2, em1, em2});


  [vec, dims] = vectorize2Dhmm(tr1, em1);

  %dirty hack to get two orthogonal vectors skew to the default basis
  axis1 = (1-vec) / norm(1-vec);
  axis2 = rand(size(axis1));
  axis2 = axis2 - ((axis1'*axis2) / sum(axis1)); % force dot-product to zero
  axis2 = axis2/norm(axis2);
  
  [samples, scalars1, scalars2] = samplePlane(vec, dims, markov_data, axis1, ...
                                              axis2, num_samples1, ...
                                              num_samples2, gf_names);
  
  trial_parameters = containers.Map({'noise_coeff', 'gf_names', 'num_events',...
                                    'num_samples1', 'num_samples2', 'axis1',...
                                    'axis2', 'scalars1', 'scalars2'}, ...
                                    {noise_coeff, gf_names, num_events, ...
                                   num_samples1, num_samples2, axis1, ...
                                   axis2, scalars1, scalars2});
  
  data=containers.Map({'samples', 'markov data', 'trial parameters'}, ...
                      {samples, markov_data, trial_parameters});
  filename = strcat(n1_name, '; ', n2_name, ';', int2str(noise_coeff), '.mat')
  save(strcat(filepath, '/', filename), 'data');

