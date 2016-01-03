function [tr1, tr2, e1, e2, estimatedStates1, estimatedStates2, num_iterations, hist] = ...
         hmmtrain2d(seq1, seq2, tr1_guess, tr2_guess, e1_guess, e2_guess, goal_function)
  % This is the main algorithm for finding connectivity. Utilizes the
  % Baum-Welch and Forward-Back algorithtms (as implemented in hmmtrain and
  % hmmdecode, respectively) to estimate the transition and emission
  % matrices, along with the hidden states of two sequences of observations
  % from two neurons. 
         
  HOLD_TR2 = 1;
  HOLD_TR1 = 1;
  tr2_slice = tr2_guess(:,:,1);
  tr1_slice = tr1_guess(:,:,1);  
  % constants
  TOL = 1e-6; %amount by less than which tr and e must change for convergence
  MAXITER = 50; %max number of iterations for this algorithm
  numStates1 = size(tr1_guess, 2); %number of states neuron 1 can be in (N)
  numStates2 = size(tr2_guess, 2); %number of states neuron 2 can be in (M)
  numEmissions1 = size(e1_guess, 2); %number of possible emissions by neuron 1
  numEmissions2 = size(e2_guess, 2); %number of possible emissions by neuron 2

  e1 = e1_guess;
  e1s = {e1_guess};
  e2 = e2_guess;
  e2s = {e2_guess};
  tr1 = tr1_guess;
  tr1s = {tr1_guess};
  tr2 = tr2_guess;
  tr2s = {tr2_guess};

  logL = hmm2dlikelihood(tr1, tr2, e1, e2, seq1, seq2)
  logLs = {logL};

  
  [estimatedStates1, pStates1] = hmmdecode2d(seq1, tr1, e1);
  [estimatedStates2, pStates2] = hmmdecode2d(seq2, tr2, e2);
 

  % pseudo-2D Algorithm
  converged = false;
  for iteration = 1:MAXITER
      
    % TODO: this version of MPC is not very good
    % MPCs1(end+1) = friedmanmpc(pStates1, seq1, e1);
    % MPCs2(end+1) = friedmanmpc(pStates2, seq2, e2);
      
    % break into subsets
    [trainingset1, trainingset2] = aggregateStates(estimatedStates1, ...
                                                   estimatedStates2, seq1, seq2, numStates1, numStates2);
    
    % train tr1 and e1 on relevant subset
    oldTR1 = tr1;
    oldE1 = e1;
    if HOLD_TR1
      [tr1_slice,e1] = hmmtrain(seq1,tr1_slice, e1);
      for j=1:size(tr1, 3)
        tr1(:,:,j) = tr1_slice;
      end
    else
      for i = 1:numStates2
        seqs = trainingset1{i};
        if isGoodTrainingSet(seqs)
          [tr1_i,e1] = hmmtrain(seqs,tr1(:,:,i), e1);
          tr1(:,:,i) = tr1_i;
        end
      end
    end
    
    % train tr2 and e2 on relevant subset
    oldTR2 = tr2;
    oldE2 = e2;
    if HOLD_TR2
      [tr2_slice,e2] = hmmtrain(seq2,tr2_slice, e2);
      for j=1:size(tr2, 3)
        tr2(:,:,j) = tr2_slice;
      end
    else
      for i = 1:numStates1
        seqs = trainingset2{i};
        if isGoodTrainingSet(seqs)
          [tr2_i,e2] = hmmtrain(seqs,tr2(:,:,i), e2);
          tr2(:,:,i) = tr2_i;
        end
      end
    end

    logL = hmm2dlikelihood(tr1, tr2, e1, e2, seq1, seq2)
    logLs{iteration} = logL;
    e1s{iteration} = e1_guess;
    e2s{iteration} = e2_guess;
    tr1s{iteration} = tr1_guess;
    tr2s{iteration} = tr2_guess;

    
    % decode using updated training data
    [estimatedStates1, pStates1] = hmmdecode2d(seq1, tr1, e1);
    [estimatedStates2, pStates2] = hmmdecode2d(seq2, tr2, e2);

    if(goal_function(tr1, tr2, e1, e2, oldTR1, oldTR2, oldE1, oldE2, seq1, seq2))
      sprintf('Converged! (%d iterations)', iteration)
      converged = true;
      break
    end
 
  end
  num_iterations = iteration;
  hist = containers.Map({'e1s', 'e2s', 'tr1s', 'tr2s', 'logLs'},{e1s, e2s, tr1s, tr2s, logLs});
  if ~converged
    disp('WARNING: reached max iterations without convergence')
  end


