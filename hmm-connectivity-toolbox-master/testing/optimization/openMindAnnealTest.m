function results = openMindAnnealTest(tr1_name, tr2_name, seq_length, time_limit, varargin)
  global sa_trajectory;

  logDir = '/tmp';
  id_str = [];
  if isempty(varargin)
     states = 2;
  else
      states = varargin{1};
      if length(varargin) > 1
        logDir = varargin{2};
      end
      if length(varargin) > 2
        id = varargin{2};
        id_str = int2str(id_str);
      end
  end



  if logDir(length(logDir)) ~= '/'
     logDir = [logDir, '/'];
  end
  saLogFile = [logDir, tr1_name, tr2_name, int2str(seq_length), int2str(time_limit), id_str, '.mat']
  

  args = containers.Map({'tr1_name', 'tr2_name', 'seq_length', 'time_limit', 'states'}, ...
                           {tr1_name, tr2_name, seq_length, time_limit, states});

  addpath '../../'
  initPath();
  options = saoptimset('DataType', 'custom', 'AnnealingFcn', @permute2DHMM, ...
                       'MaxFunEvals', Inf, 'TimeLimit', time_limit);

  if(states == 3)
     options = saoptimset(options, 'ReannealInterval', 400);
  end

  tr1 = archetypeLookup(tr1_name, states);
  tr2 = archetypeLookup(tr2_name, states);

  tr_guess = archetypeLookup('null hypothesis', states);
  tr_guess = squeeze(tr_guess(:,:,1));
  em_guess = squeeze(zeros(states, states*2) + 1/(states*2));

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
  
  %run 1d hmmtrain on the data
  %[tr2_trained, em2_trained] = hmmtrain(seq2, tr_guess, em_guess);
  %[tr1_trained, em1_trained] = hmmtrain(seq1, tr_guess, em_guess);  

  em2_trained = em_guess;
  em1_trained = em_guess;
  tr2_trained = tr_guess;
  tr1_trained = tr_guess;
 
  model_data = containers.Map({'tr1', 'tr2', 'em1', 'em2', 'seq1', 'seq2', 'tr_guess', 'em_guess', 'em1_trained', 'em2_trained'},...
                              {tr1, tr2, em1, em2, seq1, seq2, tr_guess, em_guess, em1_trained, em2_trained});
  
  %compose a 2d hmm with the results
  tr1_1D = zeros(size(tr1));
  for k = 1:size(tr1, 3)
      tr1_1D(:,:,k) = tr1_trained;
  end
  tr2_1D = zeros(size(tr2));
  for k = 1:size(tr2, 3)
    tr2_1D(:,:,k) = tr2_trained;
  end
  
  %run simulated annealing on 1d trained model
  oneD_model = pack2DHMM(tr1_1D, tr2_1D, em1_trained, em2_trained);
  %log start time
  initSATrajectory();

  begin = cputime;
  try
    disp('beginning simulated annealing')
    sa_1D_model = simulannealbnd(@(model, data)hmm_fitness(model, {seq1, seq2}), oneD_model, [], [], options, saLogFile);
  catch err
    display('WARNING: simulated annealing on the 1d seed threw an exception')
    disp(err.message)
    disp(getReport(err, 'extended'))
    disp(err.identifier)
  end
  %log end time
  elapsed = cputime-begin;

  [~, ~, oneD_s] = forward_backward2d(tr1_1D, tr2_1D, em1_trained, em2_trained, seq1, seq2);  
  [~, ~, gt_s] = forward_backward2d(tr1, tr2, em1, em2, seq1, seq2);
  gt_logL = sum(log(gt_s));
  oneD_logL = sum(log(oneD_s));
  sa1D_logL = logLPacked(sa_1D_model, seq1, seq2);
  logLs = containers.Map({'gt_logL', 'oneD_logL', 'sa1D_logL'}, ...
                         {gt_logL, oneD_logL, sa1D_logL});

  display(strcat('gt_logL: ', num2str(gt_logL)));
  display(strcat('oneD_logL: ', num2str(oneD_logL)));
  display(strcat('sa1D_logL: ', num2str(sa1D_logL)));
  
  %save results
  results = containers.Map({'args', 'model_data', 'sa_1d_results', 'sa_1d_time'}, ...
                           {args, model_data, sa_1D_model, elapsed});
  results('logL_data') = logLs;
  results('sa_trajectory') = sa_trajectory;

  save(strcat('./', tr1_name, '_', tr2_name, '_', num2str(states),'-states_', num2str(seq_length), ...
              '_', num2str(time_limit)), 'results');

  %exit();
end

function L = logLPacked(packed_model, seq1, seq2)
  [tr1, tr2, em1, em2] = unpack2DHMM(packed_model);
  [~,~,s] = forward_backward2d(tr1, tr2, em1, em2, seq1, seq2);
  L = sum(log(s));
end
