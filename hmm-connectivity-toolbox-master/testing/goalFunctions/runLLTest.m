%see bottom of file for valid "name" inputs
%num_trials is the number of times the matrices will be reinitialized (with new noise) and training will be attempted
%noise_coeff is [roughly] the percentage variance in transition/emission parameters
%goal_function is the goal function that will be used
%chain_length is the number of samples in the generated markov chain
%filepath is the folder where the results will be saved
function [true_models, initial_models, trained_models] = runLLTest(n1_name, n2_name, n1_guess_name, n2_guess_name, noise_coeff, chain_length, dimensionality)
  if (nargin < 7)
     dimensionality = 3;
  end
  n1_archetype = archetypeLookup(n1_name);
  n2_archetype = archetypeLookup(n2_name);

  n1_guess_archetype = archetypeLookup(n1_guess_name, dimensionality);
  n2_guess_archetype = archetypeLookup(n2_guess_name, dimensionality);

  
  data = containers.Map;

  e1 = [initEMat(3, 20), initEMat(3, 20)];   e1 = bsxfun(@rdivide, e1, sum(e1')');
  e2 = [initEMat(3, 20), initEMat(3, 20)];   e2 = bsxfun(@rdivide, e2, sum(e2')');
  n1 = addNoiseToArchetype(n1_archetype, noise_coeff);
  n2 = addNoiseToArchetype(n2_archetype, noise_coeff);

  %generate and record chain of data being trained on
  [seq1, seq2, states1, states2] = hmmgenerate2d(chain_length, n1, n2, e1, e2);

  gt_logL = hmm2dlikelihood(n1, n2, e1, e2, seq1, seq2);
  true_models = containers.Map({'n1', 'e1', 'n2', 'e2', 'logL'}, {n1, e1, n2, e2, gt_logL});

  e1_guess = zeros(dimensionality, 6) + 1/6;
  e2_guess = zeros(dimensionality, 6) + 1/6;
  n1_guess = addNoiseToArchetype(n1_guess_archetype, noise_coeff);
  n2_guess = addNoiseToArchetype(n2_guess_archetype, noise_coeff);
  guess_logL = hmm2dlikelihood(n1_guess, n2_guess, e1_guess, e2_guess, seq1, seq2);      
  initial_models = containers.Map({'n1', 'e1', 'n2', 'e2', 'logL'}, ...
                                         {n1_guess, e1_guess, n2_guess, e2_guess, guess_logL});
  [n1_tr, n2_tr, e1_tr, e2_tr, estimatedStates1, estimatedStates2, num_iterations, hist] = ...
  hmmtrain2d(seq1, seq2, n1_guess, n2_guess, e1_guess, e2_guess, @logLChange);
  tr_logL = hmm2dlikelihood(n1_tr, n2_tr, e1_tr, e2_tr, seq1, seq2);      
  trained_models = containers.Map({'n1', 'e1',  'n2', 'e2', 'logL'}, ...
                                         {n1_tr, e1_tr, n2_tr, e2_tr, tr_logL});

  disp(strcat('Ground truth logL: ', int2str(gt_logL)))
  disp(strcat('trained logL: ', int2str(tr_logL)))
  disp(strcat('guess logL: ', int2str(guess_logL)))    




