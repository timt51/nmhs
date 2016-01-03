function results = openMindResumeAnnealTest(tr1_name, tr2_name, seq_length, time_limit, negative, varargin)
  global sa_trajectory;

  [logDir, states, id_str, n_str] = handleArgs(negative, varargin);
  
  saLogFile = [logDir, tr1_name, tr2_name, '_', int2str(states), '_states_', int2str(seq_length), '_', int2str(time_limit), id_str, n_str, '.mat']
  sa1DLogFile = [logDir, 'oneD_', tr1_name, tr2_name, '_', int2str(states), '_states_', int2str(seq_length), int2str(time_limit), id_str, n_str, '.mat']
  

  addpath '../../'
  initPath();

  [tr1, tr2, em1, em2, seq1, seq2, gt_logL] = setupHMM(tr1_name, tr2_name, states, seq_length, negative);

  [tr1_trained, tr2_trained, em1_trained, em2_trained, tr_guess, em_guess, hmmtrain_logL] = ...
     trainHMM(seq1, seq2, states);


  %do annealing on the 1D model to make sure we've squozen as much as possible out of it
  %The /4 is a hack - it shouldn't need as much time as the full 2D model, but I'm not actually sure what is a good amount. 
  [tr1_annealed, tr2_annealed, em1_annealed, em2annealed, anneal_logL] = ...
      anneal1DHMM(tr1_trained, tr2_trained, em1_trained, em2_trained, seq1, seq2, ...
                  sa1DLogFile, time_limit*2);
  oneD_annealing_results = pack1DHMM(tr1_annealed,   tr2_annealed,   em1_annealed,   em2annealed);
  

  %select the best 1D model and prepare it for use as seed for the 2D SA
  if hmmtrain_logL < anneal_logL
    tr1_1DBest = tr1_annealed;
    tr2_1DBest = tr2_annealed;
    em1_best = em1_annealed;
    em2_best = em2_annealed;    
  else
    tr1_1DBest = tr1_trained;
    tr2_1DBest = tr2_trained;
    em1_best = em1_trained;
    em2_best = em2_trained;    
  end
  
  tr1_1D = zeros(size(tr1));
  for k = 1:size(tr1, 3)
      tr1_1D(:,:,k) = tr1_1DBest;
  end
  tr2_1D = zeros(size(tr2));
  for k = 1:size(tr2, 3)
    tr2_1D(:,:,k) = tr2_1DBest;
  end
  

  %Run 2D simulated annealing
  for i = 1:8
    initSATrajectory();
    [tr1_2Dtrained, tr2_2Dtrained, em1_2Dtrained, em2_2Dtrained, sa2D_logL] = ...
    anneal2DHMM(tr1_1D, tr2_1D, em1_best, em2_best, seq1, seq2, saLogFile, false, time_limit*i, time_limit*i, true);
  end
  sa_2D_model = pack2DHMM(tr1_2Dtrained, tr2_2Dtrained, em1_2Dtrained, em2_2Dtrained);
  
  display(strcat('gt_logL: ', num2str(gt_logL)));
  display(strcat('hmmtrain_logL: ', num2str(hmmtrain_logL)));
  display(strcat('anneal_logL: ', num2str(anneal_logL)));
  display(strcat('sa2D_logL: ', num2str(sa2D_logL)));

  
  %save results
  logLs = containers.Map({'gt_logL', 'hmmtrain_logL', 'anneal_logL', 'sa2D_logL'}, ...
                         { gt_logL,   hmmtrain_logL,   anneal_logL,   sa2D_logL});


  model_data = containers.Map({'tr1', 'tr2', 'em1', 'em2', 'seq1', 'seq2', 'tr_guess', 'em_guess', 'em1_trained', 'em2_trained', 'tr1_trained', 'tr2_trained'},...
                              { tr1,   tr2,   em1,   em2,   seq1,   seq2,   tr_guess,   em_guess,   em1_trained,   em2_trained,   tr1_trained,   tr2_trained});

  args = containers.Map({'tr1_name', 'tr2_name', 'seq_length', 'time_limit', 'states'}, ...
                        { tr1_name,   tr2_name,   seq_length,   time_limit,   states});

  results = containers.Map({'args', 'model_data', 'oneD_annealing_results', 'sa_2D_model'}, ...
                           { args,   model_data,   oneD_annealing_results,   sa_2D_model});
  results('logL_data') = logLs;
  results('sa_trajectory') = sa_trajectory;

  save(strcat('./', tr1_name, '_', tr2_name, '_', num2str(states),'-states_', num2str(seq_length), ...
              '_', num2str(time_limit), n_str, '_'), 'results');

  exit();
end





function L = logLPacked(packed_model, seq1, seq2)
  [tr1, tr2, em1, em2] = unpack2DHMM(packed_model);
  [~,~,s] = forward_backward2d(tr1, tr2, em1, em2, seq1, seq2);
  L = sum(log(s));
end

function [logDir, states, id_str, n_str] = handleArgs(negative, varargin)
  varargin = varargin{1};
  logDir = './tmp';
  id_str = [];
  if isempty(varargin)
    states = 2;
  else
    states = varargin{1};
    if length(varargin) > 1
      logDir = varargin{2};
    end
    if length(varargin) > 2
      id = varargin{3};
      id_str = int2str(id_str);
    end
  end
  if logDir(length(logDir)) ~= '/'
    logDir = [logDir, '/'];
  end
  if ~exist(logDir, 'dir')
    mkdir(logDir);
  end
  if negative
    n_str = '_negative';
  else
    n_str = '_positive';  
  end
end



function [tr1, tr2, em1, em2, seq1, seq2, gt_logL] = setupHMM(tr1_name, tr2_name, states, seq_length, negative)
  tr1 = archetypeLookup(tr1_name, states);
  tr2 = archetypeLookup(tr2_name, states);
  if negative
     for j=2:states
         tr1(:,:,j) = tr1(:,:,1);
         tr2(:,:,j) = tr2(:,:,1);
     end
  end

  switch states
         case 2
           em1 = [0.45, 0.45, 0.05, 0.05; 0.05, 0.05, 0.45, 0.45];
         case 3
           em1 = [0.44, 0.44, 0.03, 0.03, 0.03, 0.03 ...
                  ; 0.03, 0.03, 0.44, 0.44, 0.03, 0.03 ...
                  ; 0.03, 0.03, 0.03, 0.03, 0.44, 0.44];
  end
  em2 = em1;
  [seq1, seq2, states1, states2] = hmmgenerate2d(seq_length, tr1, tr2, em1, em2);
  %display comparison of results
  [~, ~, gt_s] = forward_backward2d(tr1, tr2, em1, em2, seq1, seq2);
  gt_logL = sum(log(gt_s));
end



function [tr1_trained, tr2_trained, em1_trained, em2_trained, tr_guess, em_guess, hmmtrain_logL] = trainHMM(seq1, seq2, states)
  tr_guess = archetypeLookup('null hypothesis', states);
  tr_guess = squeeze(tr_guess(:,:,1));
  em_guess = squeeze(zeros(states, states*2) + 1/(states*2));

  
  %run 1d hmmtrain on the data
  [tr2_trained, em2_trained] = hmmtrain(seq2, tr_guess, em_guess);
  [tr1_trained, em1_trained] = hmmtrain(seq1, tr_guess, em_guess);  
  hmmtrain_logL = -hmm1D_fitness(pack1DHMM(tr1_trained, tr2_trained, em1_trained, em2_trained), {seq1, seq1});
end
