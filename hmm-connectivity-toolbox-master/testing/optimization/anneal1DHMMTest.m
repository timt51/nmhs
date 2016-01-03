function results = openMindResumeAnnealTest(tr1_name, tr2_name, seq_length, time_limit,  varargin)
  global sa_trajectory;

  logDir = './tmp';
  if ~exist(logDir, 'dir')
    mkdir(logDir);
  end
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
  
  saLogFile = [logDir, tr1_name, tr2_name, '_', int2str(states), '_states_', int2str(seq_length), int2str(time_limit), id_str, '.mat']
  

  args = containers.Map({'tr1_name', 'tr2_name', 'seq_length', 'time_limit', 'states'}, ...
                        {tr1_name,    tr2_name,   seq_length,   time_limit,   states});

  addpath '../../'
  initPath();
  options = saoptimset('DataType', 'custom', 'AnnealingFcn', @permute1DHMM, ...
                          'MaxFunEvals', Inf, 'TimeLimit', time_limit);

  
  if(states == 3)
     options = saoptimset(options, 'ReannealInterval', 400);
  end

  tr2 = archetypeLookup(tr2_name, states);
  tr2 = squeeze(tr2(:,:,1));  
  tr1 = archetypeLookup(tr1_name, states);
  tr1 = squeeze(tr1(:,:,1));  
  
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
  [seq1, states1] = hmmgenerate(seq_length, tr1, em1);
  [seq2, states2] = hmmgenerate(seq_length, tr2, em2);
  
  %run 1d hmmtrain on the data
  [tr2_trained, em2_trained] = hmmtrain(seq2, tr_guess, em_guess);
  [tr1_trained, em1_trained] = hmmtrain(seq1, tr_guess, em_guess);

  

  
  model_data = containers.Map({'tr1', 'tr2', 'em1', 'em2', 'seq1', 'seq2', 'tr_guess', 'em_guess', 'em1_trained', 'em2_trained', 'tr1_trained', 'tr2_trained'},...
                              { tr1,   tr2,   em1,   em2,   seq1,   seq2,   tr_guess,   em_guess,   em1_trained,   em2_trained,   tr1_trained,   tr2_trained});
  
  %run simulated annealing on 1d trained model
  trained_model = pack1DHMM(tr1_trained, tr2_trained, em1_trained, em2_trained);
  %log start time
  initSATrajectory();

  begin = cputime;
  try
    disp('beginning simulated annealing')
    annealed_model = simulannealbnd(@(model, data)hmm1D_fitness(model, {seq1, seq2}), trained_model, [], [], options, saLogFile);
  catch err
    display('WARNING: simulated annealing on the 1d seed threw an exception')
    disp(err.message)
    disp(getReport(err, 'extended'))
    disp(err.identifier)
  end
  %log end time
  elapsed = cputime-begin;

  [tr1_annealed, tr2_annealed, em1_annealed, em2annealed] = unpack1DHMM(annealed_model);
  annealing_results = containers.Map({'tr1_annealed', 'tr2_annealed', 'em1_annealed', 'em2annealed'}, ...
                                     { tr1_annealed,   tr2_annealed,   em1_annealed,   em2annealed});
  
  
  gt_logL = -hmm1D_fitness(pack1DHMM(tr1, tr2, em1, em2), {seq1, seq1});
  hmmtrain_logL = -hmm1D_fitness(pack1DHMM(tr1_trained, tr2_trained, em1_trained, em2_trained), {seq1, seq1});
  anneal_logL = -hmm1D_fitness(annealed_model, {seq1, seq1});
  logLs = containers.Map({'gt_logL', 'hmmtrain_logL', 'anneal_logL'}, ...
                         {gt_logL, hmmtrain_logL, anneal_logL});

  display(strcat('gt_logL: ', num2str(gt_logL)));
  display(strcat('hmmtrain_logL: ', num2str(hmmtrain_logL)));
  display(strcat('anneal_logL: ', num2str(anneal_logL)));
  
  [tr1_annealed, tr2_annealed, em1_annealed, em2annealed] = unpack1DHMM(annealed_model);
  annealing_results = containers.Map({'tr1_annealed', 'tr2_annealed', 'em1_annealed', 'em2annealed'}, ...
                                     { tr1_annealed,   tr2_annealed,   em1_annealed,   em2annealed});
  

  %save results
  results = containers.Map({'args', 'model_data', 'annealing_results', 'annealing_time'}, ...
                           {args, model_data, annealing_results, elapsed});
  results('logL_data') = logLs;
  results('sa_trajectory') = sa_trajectory;

  save(strcat('./', 'OneDAnnealing_', tr1_name, '_', tr2_name, '_', num2str(states),'-states_', num2str(seq_length), ...
              '_', num2str(time_limit), '_'), 'results');

end

function L = logLPacked(packed_model, seq1, seq2)
  [tr1, tr2, em1, em2] = unpack2DHMM(packed_model);
  [~,~,s] = forward_backward2d(tr1, tr2, em1, em2, seq1, seq2);
  L = sum(log(s));
end

