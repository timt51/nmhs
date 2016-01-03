function add2DBaumWelch(dir_name, save_dir_name)
  files = dir([dir_name, '*.mat']);
  for file = files'
    try 
      results = load([dir_name, file.name]);
      disp(['Now processing ', file.name])
      results = results.results;
      args = results('args');
      runtime = args('time_limit');
      md = results('model_data');


      ll_data = results('logL_data');
      if isnan(ll_data('gt_logL'))
        disp('WARNING: logL is NAN for file; skipping')
      end

      
      %get data sequences and grount truth
      seq1 = md('seq1');
      seq2 = md('seq2');      
      tr1 = md('tr1');
      tr2 = md('tr2');      
      em1 = md('em1');
      em2 = md('em2');      
      num_states1 = size(tr1, 1);
      num_states2 = size(tr2, 1);
      num_emissions1 = size(em1, 2);
      num_emissions2 = size(em2, 2);
      
      %get guess used to train 1D
      tr_guess = md('tr_guess');
      em1_guess = squeeze(rand(num_states1, num_emissions1) + 1/(num_emissions1));
      em2_guess = squeeze(rand(num_states2, num_emissions2) + 1/(num_emissions2));
      
      %train 2D with BW
      tr1_guess = zeros(num_states1);
      for k = 1:size(tr1, num_states2)
        tr1_guess(:,:,k) = tr_guess;
      end
      tr2_guess = zeros(num_states2);
      for k = 1:size(tr2, num_states1)
        tr2_guess(:,:,k) = tr_guess;
      end
      
      %calculade 2DBW LL
      [tr1_trained, tr2_trained, em1_trained, em2_trained, logLs] = ...
      baum_welch2d(tr1_guess, tr2_guess, em1_guess, em2_guess, seq1, seq2);

      BW2D_logL = logLs(length(logLs));
      
      %calculate LL of 1D with averaged 2D matrices
      tr1_trained
      tr1_mean = mean(tr1_trained, 3)
      tr2_trained
      tr2_mean = mean(tr2_trained, 3)
      BWmean1D_logL = -hmm1D_fitness(pack1DHMM(tr1_mean, tr2_mean, em1_trained, em2_trained), {seq1, seq2});

      sa_2D_model = results('sa_2D_model');
      [tr1_sa, tr2_sa, em1_sa, em2_sa] = unpack2DHMM(sa_2D_model);
      tr1_sa_mean = mean(tr1_sa, 3);
      tr2_sa_mean = mean(tr2_sa, 3);
      SAmean1D_logL = -hmm1D_fitness(pack1DHMM(tr1_sa_mean, tr2_sa_mean, em1_sa, em2_sa), {seq1, seq2}); 

      
      %add new ll_data for 2
      ll_data('BW2D_logL') = BW2D_logL;
      ll_data('BWmean1D_logL') = BWmean1D_logL;
      ll_data('SA_mean1D_logL') = SAmean1D_logL
      
      gt_logL = ll_data('gt_logL')
      BW2D_logL = ll_data('BW2D_logL')
      sa2D_logL = ll_data('sa2D_logL')
      hmmtrain_logL = ll_data('hmmtrain_logL')
      anneal_logL = ll_data('anneal_logL')
      BWmean1D_logL = ll_data('BWmean1D_logL')
      SAmean1D_logL = ll_data('SA_mean1D_logL')

      %add ll_data to results
      results('logL_data') = ll_data;
      %save new results
      save([save_dir_name, file.name], 'results');
    catch exc
      display('WARNING: exception while operating on file')
      disp(getReport(exc))
      disp(exc)
      disp(exc.message)
      disp(exc.stack)
      disp(exc.identifier)
    end
  end
end
