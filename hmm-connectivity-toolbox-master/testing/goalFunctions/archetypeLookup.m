function tmat = archetypeLookup(n_name, dim)
  if(nargin < 2)
    dim = 3;
  end

  if dim == 3
    tmat = zeros(3,3,3);
    switch n_name 
      case 'dormant, unconnected'
        tmat(:,:,1) = getTMatArchetype(3, 1);
        tmat(:,:,2) = getTMatArchetype(3, 1);
        tmat(:,:,3) = getTMatArchetype(3, 1);
      case 'dormant, excited'
        tmat(:,:,1) = getTMatArchetype(3, 1);
        tmat(:,:,2) = getTMatArchetype(3, 2);
        tmat(:,:,3) = getTMatArchetype(3, 3);
      case 'moderate, inhibited'
        tmat(:,:,1) = getTMatArchetype(3, 2);
        tmat(:,:,2) = getTMatArchetype(3, 1);
        tmat(:,:,3) = getTMatArchetype(3, 0);
      case 'moderate, unconnected'
        tmat(:,:,1) = getTMatArchetype(3, 2);
        tmat(:,:,2) = getTMatArchetype(3, 2);
        tmat(:,:,3) = getTMatArchetype(3, 2);
      case 'moderate, excited'
        tmat(:,:,1) = getTMatArchetype(3, 2);
        tmat(:,:,2) = getTMatArchetype(3, 3);
        tmat(:,:,3) = getTMatArchetype(3, 4);
      case 'active, inhibited'
        tmat(:,:,1) = getTMatArchetype(3, 3);
        tmat(:,:,2) = getTMatArchetype(3, 2);
        tmat(:,:,3) = getTMatArchetype(3, 1);
      case 'active, unconnected'
        tmat(:,:,1) = getTMatArchetype(3, 3);
        tmat(:,:,2) = getTMatArchetype(3, 3);
        tmat(:,:,3) = getTMatArchetype(3, 3);
      case 'null hypothesis'
        tmat(:,:,1) = getTMatArchetype(3, 5);
        tmat(:,:,2) = getTMatArchetype(3, 5);
        tmat(:,:,3) = getTMatArchetype(3, 5);
    end
  elseif dim == 2
    tmat = zeros(2,2,2);
    switch n_name
      case 'dormant, unconnected'
        tmat(:,:,1) = getTMatArchetype(2, 1);
        tmat(:,:,2) = getTMatArchetype(2, 1);
      case 'dormant, excited'
        tmat(:,:,1) = getTMatArchetype(2, 1);
        tmat(:,:,2) = getTMatArchetype(2, 2);
      case 'dormant, inhibited'
        tmat(:,:,1) = getTMatArchetype(2, 1);
        tmat(:,:,2) = getTMatArchetype(2, 0);
      case 'active, excited'
        tmat(:,:,1) = getTMatArchetype(2, 2);
        tmat(:,:,2) = getTMatArchetype(2, 3);
      case 'active, inhibited'
        tmat(:,:,1) = getTMatArchetype(2, 2);
        tmat(:,:,2) = getTMatArchetype(2, 1);
      case 'active, unconnected'
        tmat(:,:,1) = getTMatArchetype(2, 2);
        tmat(:,:,2) = getTMatArchetype(2, 2);
      case 'null hypothesis'
        tmat(:,:,1) = getTMatArchetype(2, 4);
        tmat(:,:,2) = getTMatArchetype(2, 4);
    end
  end
