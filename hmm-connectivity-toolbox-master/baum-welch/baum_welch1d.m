function [tr_trained, em_trained, logLs] = ...
         baum_welch1d(seq, tr_guess, em_guess)
  CONVERGENCE_LIMIT = 1000;
  EPSILON = 1e-6;
  tol = EPSILON;
  etol = tol;
  trtol = tol;
  tr_trained = tr_guess;
  em_trained = em_guess;
  num_states = size(tr_guess, 1);
  num_emissions = size(em_guess, 2);
  num_events = length(seq);


  [~,~, forward_probabilities, backward_probabilities, normalization_factors] = hmmdecode(seq, tr_trained, em_trained);
  old_logL = sum(log(normalization_factors));
  logLs = [old_logL];

  convergence = false;
  %make seqs line up with forward/backward probabilities - forward_backward
  %adds padding
  seq = [0, seq];
  for iter = 1:CONVERGENCE_LIMIT
    oldTR = tr_trained;
    oldE = em_trained;

    big_chi = zeros(num_states, num_states);
    %use logs and addition/subtraction to avoid floating-point restrictions
    loglik = log(normalization_factors);
    logf = log(forward_probabilities);
    logb = log(backward_probabilities);
    logE = log(em_trained);
    logTR = log(tr_trained);
    
    
    for i = 1:num_states
      for j = 1:num_states
        for t = 1:num_events
          big_chi(i,j) = big_chi(i,j) + exp(logf(i,t) + logTR(i, j) + logE(j, seq(t+1)) + logb(j,t+1))/normalization_factors(t+1);
        end
      end
    end
    
    %calculate new transfer probabilities for hmm - second and third dimension are swapped!!!!!
    tr_trained = big_chi ./ repmat(sum(big_chi, 2), 1, num_states);

    fb_products = exp(logf + logb);
    big_e = zeros(num_states, num_emissions);
    for e = 1:num_emissions
      pos = find(seq == e);
      big_e(:, e) = sum(fb_products(:,pos), 2);
    end
    em_trained = big_e ./ repmat(sum(big_e, 2), 1, num_emissions);

    [~,~, forward_probabilities, backward_probabilities, normalization_factors] = hmmdecode(seq(2:length(seq)), tr_trained, em_trained);
    new_logL = sum(log(normalization_factors));
    logLs(iter+1) = new_logL;
    if (abs(new_logL-old_logL)/(1+abs(old_logL))) < tol
        if norm(tr_trained - oldTR,inf)/num_states < trtol
            if norm(em_trained - oldE,inf)/num_emissions < etol
                if 1
                    fprintf('%s\n',getString(message('stats:hmmtrain:ConvergedAfterIterations',iter)))
                end
                converged = true;
                break
            end
        end
    end
    old_logL = new_logL;
  end



