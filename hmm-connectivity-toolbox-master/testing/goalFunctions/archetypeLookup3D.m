function tmat = archetypeLookup3D(n_name, dim)
  if(nargin < 2)
    dim = 2;
  end

  if dim == 2
    tmat = zeros(2,2,2,2);
    switch n_name
      case 'null hypothesis'
        tmat(:,:,1,1) = getTMatArchetype(2, 3);
        tmat(:,:,1,2) = getTMatArchetype(2, 3);        
        tmat(:,:,2,1) = getTMatArchetype(2, 3);
        tmat(:,:,2,2) = getTMatArchetype(2, 3);        
      case 'dormant, unconnected'
        tmat(:,:,1,1) = getTMatArchetype(2, 1);
        tmat(:,:,1,2) = getTMatArchetype(2, 1);
        tmat(:,:,2,1) = getTMatArchetype(2, 1);
        tmat(:,:,2,2) = getTMatArchetype(2, 1);
      case 'dormant, excited 1'
        tmat(:,:,1,1) = getTMatArchetype(2, 1);
        tmat(:,:,1,2) = getTMatArchetype(2, 1);
        tmat(:,:,2,1) = getTMatArchetype(2, 2);
        tmat(:,:,2,2) = getTMatArchetype(2, 2);
      case 'dormant, excited 2'
        tmat(:,:,1,1) = getTMatArchetype(2, 1);
        tmat(:,:,2,1) = getTMatArchetype(2, 1);
        tmat(:,:,1,2) = getTMatArchetype(2, 2);
        tmat(:,:,2,2) = getTMatArchetype(2, 2);
      case 'dormant, excited jointly'
        tmat(:,:,1,1) = getTMatArchetype(2, 1);
        tmat(:,:,1,2) = getTMatArchetype(2, 1);        
        tmat(:,:,2,1) = getTMatArchetype(2, 1);
        tmat(:,:,2,2) = getTMatArchetype(2, 2);        
      case 'dormant, inhibited 1'
        tmat(:,:,1,1) = getTMatArchetype(2, 1);
        tmat(:,:,1,2) = getTMatArchetype(2, 1);
        tmat(:,:,2,1) = getTMatArchetype(2, 0);
        tmat(:,:,2,2) = getTMatArchetype(2, 0);
      case 'dormant, inhibited 2'
        tmat(:,:,1,1) = getTMatArchetype(2, 1);
        tmat(:,:,2,1) = getTMatArchetype(2, 1);
        tmat(:,:,1,2) = getTMatArchetype(2, 0);
        tmat(:,:,2,2) = getTMatArchetype(2, 0);
      case 'dormant, inhibited jointly'
        tmat(:,:,1,1) = getTMatArchetype(2, 1);
        tmat(:,:,1,2) = getTMatArchetype(2, 1);        
        tmat(:,:,2,1) = getTMatArchetype(2, 1);
        tmat(:,:,2,2) = getTMatArchetype(2, 0);        
      case 'active, unconnected'
        tmat(:,:,1,1) = getTMatArchetype(2, 2);
        tmat(:,:,1,2) = getTMatArchetype(2, 2);        
        tmat(:,:,2,1) = getTMatArchetype(2, 2);
        tmat(:,:,2,2) = getTMatArchetype(2, 2);        
      case 'active, excited 1'
        tmat(:,:,1,1) = getTMatArchetype(2, 2);
        tmat(:,:,1,2) = getTMatArchetype(2, 2);
        tmat(:,:,2,1) = getTMatArchetype(2, 3);
        tmat(:,:,2,2) = getTMatArchetype(2, 3);
      case 'active, excited 2'
        tmat(:,:,1,1) = getTMatArchetype(2, 2);
        tmat(:,:,2,1) = getTMatArchetype(2, 2);
        tmat(:,:,1,2) = getTMatArchetype(2, 3);
        tmat(:,:,2,2) = getTMatArchetype(2, 3);
      case 'active, excited jointly'
        tmat(:,:,1,1) = getTMatArchetype(2, 2);
        tmat(:,:,1,2) = getTMatArchetype(2, 2);        
        tmat(:,:,2,1) = getTMatArchetype(2, 2);
        tmat(:,:,2,2) = getTMatArchetype(2, 3);        
      case 'active, inhibited 1'
        tmat(:,:,1,1) = getTMatArchetype(2, 2);
        tmat(:,:,1,2) = getTMatArchetype(2, 2);
        tmat(:,:,2,1) = getTMatArchetype(2, 1);
        tmat(:,:,2,2) = getTMatArchetype(2, 1);
      case 'active, inhibited 2'
        tmat(:,:,1,1) = getTMatArchetype(2, 2);
        tmat(:,:,2,1) = getTMatArchetype(2, 2);
        tmat(:,:,1,2) = getTMatArchetype(2, 1);
        tmat(:,:,2,2) = getTMatArchetype(2, 1);
      case 'active, inhibited jointly'
        tmat(:,:,1,1) = getTMatArchetype(2, 2);
        tmat(:,:,1,2) = getTMatArchetype(2, 2);        
        tmat(:,:,2,1) = getTMatArchetype(2, 2);
        tmat(:,:,2,2) = getTMatArchetype(2, 1);        
    end
  end
  tmat = permute(tmat, [2, 1, 3, 4]);
