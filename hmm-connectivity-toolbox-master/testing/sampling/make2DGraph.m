% num_events will generally be on the order of 4k-10k for the ephys experiements
% Alexander has been doing (as of 9-24-14)
function make2DGraph(n1_name, n2_name, false_archetype_name1, ...
                     false_archetype_name2, num_trials,...
                     noise_coeff, gf_names, num_events, num_samples, fpath,...
                     normalize)
  % generate hmm's from archetype names and noise coefficient
  tr1 = archetypeLookup(n1_name);
  tr2 = archetypeLookup(n2_name);

  tr_false1 = archetypeLookup(false_archetype_name1);
  tr_false2 = archetypeLookup(false_archetype_name2);
  
  %simple emission matrix: two roughly diagonal matrices appended to each other with noise. Corresponds roughly to two primary emissions per state. 
  em1 = [initEMat(3, 20), initEMat(3, 20)];
  em1 = bsxfun(@rdivide, em1, sum(em1')');

  em2 = [initEMat(3, 20), initEMat(3, 20)];
  em2 = bsxfun(@rdivide, em2, sum(em2')');

  em_false1 = [initEMat(3, 20), initEMat(3, 20)];
  em_false1 = bsxfun(@rdivide, em_false1, sum(em_false1')');
  em_false2 = [initEMat(3, 20), initEMat(3, 20)];
  em_false2 = bsxfun(@rdivide, em_false2, sum(em_false2')');

  
  % generate sequences of events on which to evaluate the hmms
  [seq1, seq2, states1, states2] = hmmgenerate2d(num_events, tr1, tr2, em1, em2);
  markov_data = containers.Map({'seq1', 'seq2', 'states1', 'states2', 'tr1', ...
                                'tr2', 'em1', 'em2', 'tr_false1', 'em_false1',...
                               'tr_false2', 'em_false2'}, ...
                               {seq1, seq2, states1, states2, tr1, ...
                                tr2, em1, em2, tr_false1, em_false1,...
                                tr_false2, em_false2});


  [vec, dims] = vectorize2Dhmm(tr1, em1);
  [vec_false1, dims] = vectorize2Dhmm(tr_false1, em_false1);
  [vec_false2, dims] = vectorize2Dhmm(tr_false2, em_false2);  
  %dirty hack to get two orthogonal vectors skew to the default basis
  axis1 = (vec_false1-vec) / norm(vec_false1-vec);
  axis2 = (vec_false2-vec) / norm(vec_false2-vec);  
  
  [samples, scalars1, scalars2] = samplePlane(vec, dims, markov_data, axis1, axis2,...
                                              num_samples, num_samples, gf_names);
  
  trial_parameters = containers.Map({'noise_coeff', 'gf_names', 'num_events',...
                                     'num_samples', 'axis', 'scalars1', 'scalars2'}, ...
                                    {noise_coeff, gf_names, num_events, ...
                                   num_samples, axis, scalars1, scalars2});
  
  data=containers.Map({'samples', 'markov data', 'trial parameters', 'names'}, ...
                      {samples, markov_data, trial_parameters, ...
                     {n1_name, n2_name, false_archetype_name1, false_archetype_name2}});
  filename = strcat(n1_name, '; ', n2_name, ';', int2str(noise_coeff), '2D.mat')
  save(strcat(fpath, '/', filename), 'data');
  
  graphHMMGoalFunctions2D(samples, scalars1, scalars2, n1_name, n2_name,...
                          false_archetype_name1, false_archetype_name2, ...
                          num_trials, data, normalize);
  
  
