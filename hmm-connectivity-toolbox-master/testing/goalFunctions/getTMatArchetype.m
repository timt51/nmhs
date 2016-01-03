%gets a transition matrix archetype.
% 1 = low base-rate and inhibited
% 2 = low base-rate (or medium base-rate and inhibited, etc)
% 3 = medium base-rate
% 4 = high base-rate
% 4 = high base-rate and excited


function T = getTMatArchetype(dim,idx)
  alt = true;
  if alt
    T = getTMatArchetypeAlt(dim, idx);
  else
    if dim == 3
      if idx == 0
        T = [0.99, 0.009, 0.001; 0.8, 0.18, 0.02; 0.6, 0.1, 0.3];
      elseif idx == 1
        T = [0.93, 0.06, 0.01; 0.38, 0.6, 0.02; 0.15, 0.35, 0.5];
      elseif idx == 2
        T = [0.8, 0.19, 0.01; 0.04, 0.92, 0.04; 0.01, 0.19, 0.8];
      elseif idx == 3
        T = [0.5, 0.35, 0.15; 0.02, 0.6, 0.38; 0.01, 0.06, 0.93];
      elseif idx == 4
        T = [0.3, 0.1, 0.6; 0.02, 0.18, 0.8; 0.001, 0.009, 0.99];
      elseif idx == 5
        T = [0.96, 0.02, 0.02; 0.02, 0.96, 0.02; 0.02, 0.02, 0.96];
      else 
        warning('invalid idx passed to getTMatArchetype; T =ing normal base-rate')
        T = [0.8, 0.19, 0.01; 0.04, 0.92, 0.04; 0.01, 0.19, 0.8];
      end
    elseif dim == 2
      if idx == 0 %dormant, inhibited
        T = [0.99, 0.01; 0.9, 0.1];
      elseif idx == 1 %dormant
        T = [0.95, 0.05; 0.5, 0.5];
      elseif idx == 2 %active
        T = [0.5, 0.5; 0.05, 0.95];
      elseif idx == 3 %active, excited
        T = [0.1, 0.9; 0.01, 0.99];
      elseif idx == 4 %null hypothesis
        T = [0.98, 0.02; 0.02, 0.98];
      end
    end
  end  
end


function T = getTMatArchetypeAlt(dim,idx)
  if dim == 3
    if idx == 0
      T = [0.95, 0.04, 0.01; 0.25, 0.7, 0.05; 0.2, 0.2, 0.6];
    elseif idx == 1
      T = [0.9, 0.08, 0.02; 0.15, 0.8, 0.05; 0.1, 0.2, 0.7];
    elseif idx == 2
      T = [0.8, 0.19, 0.01; 0.04, 0.92, 0.04; 0.01, 0.19, 0.8];
    elseif idx == 3
      T = [0.7, 0.25, 0.05; 0.05, 0.8, 0.15; 0.02, 0.08, 0.9];
    elseif idx == 4
      T = [0.6, 0.2, 0.2; 0.05, 0.7, 0.25; 0.01, 0.04, 0.95];
    elseif idx == 5
      T = [0.9, 0.05, 0.05; 0.05, 0.9, 0.05; 0.05, 0.05, 0.9];
    else 
      warning('invalid idx passed to getTMatArchetype; T =ing normal base-rate')
      T = [0.8, 0.19, 0.01; 0.04, 0.92, 0.04; 0.01, 0.19, 0.8];
    end
  elseif dim == 2
    if idx == 0 %dormant, inhibited
      T = [0.99, 0.01; 0.9, 0.1];
    elseif idx == 1 %dormant
      T = [0.95, 0.05; 0.5, 0.5];
    elseif idx == 2 %active
      T = [0.5, 0.5; 0.05, 0.95];
    elseif idx == 3 %active, excited
      T = [0.1, 0.9; 0.01, 0.99];
    elseif idx == 4 %null hypothesis
      T = [0.9, 0.1; 0.1, 0.9];
    end
  end
end  
