function b = are2Dmarkov(tr1, tr2, e1, e2)
  b = true;
  if(size(tr1, 1) ~= size(e1, 1))
    b = false
    disp('WARNING: tr1 and e1 do not have matching numbers of states')
  end
  if(size(tr2, 1) ~= size(e2, 1))
    b = false
    disp('WARNING: tr2 and e2 do not have matching numbers of states')
  end
  if(size(tr1, 1) ~= size(tr2, 3))
    b = false
    disp('WARNING: tr1 and tr2 do not have matching numbers of states')
  end
  if(size(tr2, 1) ~= size(tr1, 3))
    b = false
    disp('WARNING: tr1 and tr2 do not have matching numbers of states')
  end
  if(size(tr1, 1) ~= size(tr1, 2))
    b = false
    disp('WARNING: tr1 is not square')
  end
  if(size(tr2, 1) ~= size(tr2, 2))
    b = false
    disp('WARNING: tr2 is not square')
  end
  for k = 1:size(tr1, 3)
    if ~isMarkov(tr1(:,:,k))
      b = false
      disp(['WARNING: tr1 is not markov for tr2 state ', num2str(k)])
    end
  end
  for k = 1:size(tr2, 3)
    if ~isMarkov(tr2(:,:,k))
      b = false
      disp(['WARNING: tr2 is not markov for tr1 state ', num2str(k)])
    end
  end
  if ~isMarkov(e1)
    b = false
    disp('WARNING: e1 is not markov');
  end
  if ~isMarkov(e2)
    b = false
    disp('WARNING: e2 is not markov');
  end


    
