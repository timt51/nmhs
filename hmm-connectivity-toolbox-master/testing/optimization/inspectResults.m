function inspectResults(directory)
  files = dir([dir_name, '*.mat']);

  for file = files';
    results = load([dir_name, file.name]);
    results = results.results;
    args = results('args');
    runtime = args('time_limit');
