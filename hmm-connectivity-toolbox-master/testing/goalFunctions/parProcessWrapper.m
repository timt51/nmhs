function parProcessWrapper(str)
  strargs = strsplit(str, ';');
  if length(strargs) ~= 9
     error('Incorrect number of arguments. Please separate arguments with a ;');
  else
    strargs{5} = str2num(strargs{5});
    strargs{6} = str2num(strargs{6});
    strargs{8} = str2num(strargs{8});   
    runTrials(strargs{:});
  end


