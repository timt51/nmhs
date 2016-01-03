%see bottom of file for valid "name" inputs
%num_trials is the number of times the matrices will be reinitialized (with new noise) and training will be attempted
%noise_coeff is [roughly] the percentage variance in transition/emission parameters
%goal_function is the goal function that will be used
%chain_length is the number of samples in the generated markov chain
%filepath is the folder where the results will be saved
function runTrials(n1_name, n2_name, n1_guess_name, n2_guess_name, num_trials, noise_coeff, gf_name, chain_length, filepath, dimensionality)
  if (nargin < 10)
     dimensionality = 3;
  end
  goal_function = str2func(gf_name);
  n1_archetype = archetypeLookup(n1_name);
  n2_archetype = archetypeLookup(n2_name);

  n1_guess_archetype = archetypeLookup(n1_guess_name, dimensionality);
  n2_guess_archetype = archetypeLookup(n2_guess_name, dimensionality);

  
  data = containers.Map;
  initial_models = {};
  trained_models = {};
  true_models = {};
  generated_states = {};
  guessed_states = {};
  iterations = [];
  try_catches = [];
  training_histories = {};
  
  for trial=1:num_trials
      disp(strcat('PROGRESS: starting trial ', int2str(trial), ' of ', int2str(num_trials)))
      e1 = [initEMat(3, 20), initEMat(3, 20)];   e1 = bsxfun(@rdivide, e1, sum(e1')');
      e2 = [initEMat(3, 20), initEMat(3, 20)];   e2 = bsxfun(@rdivide, e2, sum(e2')');
      n1 = addNoiseToArchetype(n1_archetype, noise_coeff);
      n2 = addNoiseToArchetype(n2_archetype, noise_coeff);

      %generate and record chain of data being trained on
      [seq1, seq2, states1, states2] = hmmgenerate2d(chain_length, n1, n2, e1, e2);
      generated_states{trial} = containers.Map({'seq1', 'seq2', 'states1', 'states2'}, ...
                                               {seq1, seq2, states1, states2});

      logL = hmm2dlikelihood(n1, n2, e1, e2, seq1, seq2);
      true_models{trial} = containers.Map({'n1', 'e1', 'n2', 'e2', 'logL'}, {n1, e1, n2, e2, logL});

      e1_guess = zeros(dimensionality, 6) + 1/6;
      e2_guess = zeros(dimensionality, 6) + 1/6;
      n1_guess = addNoiseToArchetype(n1_guess_archetype, noise_coeff);
      n2_guess = addNoiseToArchetype(n2_guess_archetype, noise_coeff);
      logL = hmm2dlikelihood(n1_guess, n2_guess, e1_guess, e2_guess, seq1, seq2);      
      initial_models{trial} = containers.Map({'n1', 'e1', 'n2', 'e2', 'logL'}, ...
                                             {n1_guess, e1_guess, n2_guess, e2_guess, logL});

      %train guess models; record trained model and number of iterations taken
      catches = 0;
      while(catches < 100)
        try
           [n1_tr, n2_tr, e1_tr, e2_tr, estimatedStates1, estimatedStates2, num_iterations, hist] = ...
           hmmtrain2d(seq1, seq2, n1_guess, n2_guess, e1_guess, e2_guess, goal_function);
           break;
        catch exc
          disp(getReport(exc))
          disp(exc)
          disp(exc.message)
          disp(exc.stack)
          disp(exc.identifier)
          catches = catches + 1;
        end
      end
      if(catches >= 10)
        disp('WARNING: 100 exceptions; no data gathered')
        iterations(trial) = NaN;
        try_catches(trial) = catches;
        training_histories{trial} = {};
        trained_models{trial} = containers.Map();
        guessed_states{trial} = containers.Map();
      else
        iterations(trial) = num_iterations;
        try_catches(trial) = catches;
        training_histories{trial} = hist;
        logL = hmm2dlikelihood(n1_tr, n2_tr, e1_tr, e2_tr, seq1, seq2);      
        trained_models{trial} = containers.Map({'n1', 'e1',  'n2', 'e2', 'logL'}, ...
                                               {n1_tr, e1_tr, n2_tr, e2_tr, logL});
        guessed_states{trial} = containers.Map({'es1', 'es2'}, ...
                                               {estimatedStates1, estimatedStates2});
      end
  end

  data = containers.Map({'initial_models', 'trained_models', 'true_models',...
                         'generated_states', 'guessed_states', 'training_histories'}, ...
                        {initial_models, trained_models, true_models, ...
                         generated_states, guessed_states, training_histories});
  params = containers.Map({'n1_type', 'n2_type', 'num_trials', 'noise', 'goal function', ...
                           'data length'}, ...
                          {n1_name, n2_name, num_trials, noise_coeff, gf_name, ...
                           chain_length});
                          
  trials = containers.Map({'params', 'data'},{params, data});
  
  filename = strcat(n1_name, '; ', n2_name, ';', int2str(noise_coeff), '.mat')
  save(strcat(filepath, '/', filename), 'trials') ;




