function fits = plotRunningTimeVsFit(dir_name)
  runtimes = [7500, 15000, 30000, 60000, 90000];
  fits = zeros(2, length(runtimes));
  
  
  files = dir([dir_name, '*.mat']);
  for file = files'
    results = load([dir_name, file.name]);
    results = results.results;
    args = results('args');
    runtime = args('time_limit');
    ll_data = results('logL_data');
    fit = 100*(ll_data('sa1D_logL') - ll_data('gt_logL')) / ll_data('gt_logL')
    idx = find(runtimes == runtime)
    if isempty(idx)
       display(['Warning: unrecognized runtime: ', num2str(runtime)])
       continue
    end
    fits(1, idx) = (fits(1,idx)*fits(2,idx) + fit)/(fits(2,idx) + 1)
    fits(2, idx) = fits(2,idx) + 1
  end
  figure;
  hold all;
  %label axis
  xlabel('running time in seconds of the simulated annealing algorithm')
  ylabel('Percentage increase in log-likelihood of SA versus ground-truth')

  figure
  hold all
  title('Comparison of running time versus goodness of fit for simulated annealing on training 2D hidden markov models')
  plot(runtimes, fits(1,:));
  
