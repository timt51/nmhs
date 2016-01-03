function [little_chi, chi1, chi2, chi1_normalized, chi2_normalized, ...
          chi1_normalized_2d, chi2_normalized_2d]...
         = little_chi_testing(tr1, tr2, em1, em2)
         
  seq1 = hmmgenerate(5000, tr1, em1);
  seq2 = hmmgenerate(5000, tr2, em2);  

  tr1_2d = zeros(size(tr1, 1), size(tr1, 2), size(tr2, 1));


  for k = 1:size(tr2, 1)
      tr1_2d(:,:,k) = tr1;
  end
  tr2_2d = zeros(size(tr2, 1), size(tr2, 2), size(tr1, 1));  
  for k = 1:size(tr1, 1)
      tr2_2d(:,:,k) = tr2;
  end
  
  num_states1 = size(tr1, 1);
  num_states2 = size(tr2, 1);  
  num_emissions1 = size(em1, 2);
  num_emissions2 = size(em2, 2);  
  num_events = length(seq1);


  [forward_probabilities, backward_probabilities, normalization_factors] = forward_backward2d(tr1_2d, tr2_2d, em1, em2, seq1, seq2);
  old_logL = sum(log(normalization_factors));

  %make seqs line up with forward/backward probabilities - forward_backward
  %adds padding
  seq1 = [1, seq1];
  seq2 = [1, seq2];
  little_chi = zeros(num_states1, num_states2, num_states1, num_states2, num_events);

  %use logs and addition/subtraction to avoid floating-point restrictions
  loglik = log(normalization_factors);
  logf = log(forward_probabilities);
  logb = log(backward_probabilities);
  logE1 = log(em1);
  logE2 = log(em2);
  logTR1_2D = log(tr1_2d);
  logTR2_2D = log(tr2_2d);
  
  
  for k = 1:num_states1
    for l = 1:num_states2
      for i = 1:num_states1
        for j = 1:num_states2
          for t = 1:num_events
            little_chi(k,l,i,j,t) = ...
            exp(logf(k,l,t) + logTR1_2D(k, i, l) + logTR2_2D(l, j, k) +...
                logE1(i, seq1(t+1)) + logE2(j, seq2(t+1)) + logb(i,j,t+1) - loglik(t+1));
          end
        end
      end
    end
  end

  %code from matlab's 1d hmm training
  [~,~,fs1,bs1,scale1] = hmmdecode(seq1,tr1,em1);
  logf1 = log(fs1);
  logb1 = log(bs1);
  logE1 = log(em1);
  logTR1 = log(tr1);
  chi1 = zeros(num_states1, num_states1, num_events);
  for k = 1:num_states1
    for l = 1:num_states1
      for t = 1:num_events
        chi1(k,l, t) = exp(logf1(k,t) + logTR1(k,l) + logE1(l,seq1(t+1)) + logb1(l,t+1))./scale1(t+1);
      end
    end
  end

  chi1_normalized = zeros(size(chi1));

  
  [~,~,fs2,bs2,scale2] = hmmdecode(seq2,tr2,em2);
  logf2 = log(fs2);
  logb2 = log(bs2);
  logE2 = log(em2);
  logTR2 = log(tr2);
  chi2 = zeros(num_states2, num_states2, num_events);
  for k = 1:num_states2
    for l = 1:num_states2
      for t = 1:num_events
        chi2(k,l, t) = exp(logf2(k,t) + logTR2(k,l) + logE2(l,seq2(t+1)) + logb2(l,t+1))./scale2(t+1);
      end
    end
  end


  chi1_normalized = chi1;
  chi2_normalized = chi2;

  chi1_2d = squeeze(sum(sum(little_chi, 4), 2));
  chi2_2d = squeeze(sum(sum(little_chi, 3), 1));
  chi1_normalized_2d = chi1_2d;
  chi2_normalized_2d = chi2_2d;

  
  for k = 1:num_events
    chi1_normalized(:,:,k) = bsxfun(@rdivide, chi1(:,:,k), sum(chi1(:,:,k), 2));
    chi2_normalized(:,:,k) = bsxfun(@rdivide, chi2(:,:,k), sum(chi2(:,:,k), 2));

    chi1_normalized_2d(:,:,k) = bsxfun(@rdivide, chi1_2d(:,:,k), sum(chi1_2d(:,:,k), 2));
    chi2_normalized_2d(:,:,k) = bsxfun(@rdivide, chi2_2d(:,:,k), sum(chi2_2d(:,:,k), 2));
  end

  
