function improvements = graphAccuracyTests(dir_name, show_graphs, varargin)
  if isempty(varargin)
     train_1d = false;
  else
    train_1d = varargin{1};
  end

  files = dir([dir_name, '*_.mat']);
  improvements = []
  THRESHOLD = 0.005;
  CONNECTIVITY_THRESH = 0.05;

  positives = 0; false_positives = 0;
  negatives = 0; false_negatives = 0;
  
  for file = files';
    try 
      results = load([dir_name, file.name]);
      results = results.results;
      args = results('args');
      runtime = args('time_limit');

      md = results('model_data');
      tr1 = md('tr1');
      tr2 = md('tr2');
      if size(tr1,1) < 3
        continue
      end
      ll_data = results('logL_data');
      if isnan(ll_data('gt_logL'))
        continue
      end
    

      disp('***********************************************************')
      disp([args('tr1_name'),'_',args('tr2_name')])
      mean_logL = ll_data('BWmean1D_logL');
      gt_logL = ll_data('gt_logL');
      bw_logL = ll_data('BW2D_logL');
      hmmtrain_logL = ll_data('hmmtrain_logL');
      anneal_logL = ll_data('anneal_logL');
       %check whether the two neurons have the same name, and determine bin based on that
      %both_unconnected = ~isempty(strfind(args('tr1_name'), 'unconnected')) && ...
      %                   ~isempty(strfind(args('tr2_name'), 'unconnected'))

      gt_logL
      mean_logL
      bw_logL
      best1D_logL = max([anneal_logL, hmmtrain_logL, mean_logL])
      oneD_improvement = -(best1D_logL - gt_logL) / gt_logL
      bw_improvement = -(bw_logL - best1D_logL) / best1D_logL
      gt_improvement = -(gt_logL - best1D_logL) / best1D_logL
      improvements = [improvements, gt_improvement];
     
      %both_unconnected = gt_improvement < CONNECTIVITY_THRESH
      both_unconnected = (danil_connectivity(tr1, tr2, false) < CONNECTIVITY_THRESH) && (danil_connectivity(tr2, tr1, false) < CONNECTIVITY_THRESH)
      if isnan(ll_data('gt_logL'))
         disp('gt ll is nan')
         continue
      end
      %both_unconnected = -((ll_data('gt_logL') - ll_data('oneD_logL')) / ll_data('oneD_logL')) < THRESHOLD
      if both_unconnected
        if bw_improvement > THRESHOLD
          false_positives = false_positives + 1;
          display('False positive!')
          display(file)       
        else
          negatives = negatives + 1;
        end
      else
        if bw_improvement > THRESHOLD
          positives = positives+1;
        else
          false_negatives = false_negatives+1;
          display('False negative!')
          display(file)
        end
      end
      if(show_graphs)
        %extract annealing data
        sa1d_traj = results('sa_trajectory');
        fitness_vals = [sa1d_traj(:).fval];

        %get GT logL
        gt = -ll_data('gt_logL')
        oneD = -ll_data('oneD_logL')
        x = [1:1:length(fitness_vals)];
        gt_y = repmat(gt, size(x));
        oneD_y = repmat(oneD, size(x));
        plot(x, fitness_vals, x, gt_y, x, oneD_y);
        legend('fitness', 'ground truth', 'oneD fitness');
        
        %title plot with the pair we're looking at
        title(['Fitness trajectory from file ', file.name]);
        uiwait();
      end
    catch err
      display(strcat('WARNING: exception thrown while evaluating data from file: ', file.name))
      disp(err.message)
      disp(getReport(err, 'extended'))
      disp(err.identifier)
    end
  end
  [positives, negatives, false_positives, false_negatives]
  bar([positives, negatives, false_positives, false_negatives]); 

end
