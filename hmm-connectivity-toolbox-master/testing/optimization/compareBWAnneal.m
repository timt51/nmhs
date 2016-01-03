function [mn, vr] = compareBWAnneal(dir_name)
  logLs = [];
  files = dir([dir_name, '*.mat']);
  idx = 0;
  for file = files'
    try
      idx = idx+1;
      results = load([dir_name, file.name]);
      disp(['Now processing ', file.name])
      results = results.results;
      args = results('args');
      runtime = args('time_limit');
      md = results('model_data');
      ll_data = results('logL_data');
      logLs(:,idx) = [ll_data('BW2D_logL');ll_data('sa2D_logL')];
    catch exc
      display('WARNING: exception while operating on file')
      disp(getReport(exc))
      disp(exc)
      disp(exc.message)
      disp(exc.stack)
      disp(exc.identifier)
    end
  end
  diff = (logLs(1,:) - logLs(2,:))./logLs(1,:);
  mn = mean(diff);
  vr = var(diff);
