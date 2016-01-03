function [tr1, tr2, em1, em2, seq1, seq2, gt_logL] = setupHMM(tr1_name, tr2_name, states, seq_length, negative)
  tr1 = archetypeLookup(tr1_name, states);
  tr2 = archetypeLookup(tr2_name, states);
  if negative
     for j=2:states
         tr1(:,:,j) = tr1(:,:,1);
         tr2(:,:,j) = tr2(:,:,1);
     end
  end

  switch states
         case 2
           em1 = [0.45, 0.45, 0.05, 0.05; 0.05, 0.05, 0.45, 0.45];
         case 3
           em1 = [0.44, 0.44, 0.03, 0.03, 0.03, 0.03 ...
                  ; 0.03, 0.03, 0.44, 0.44, 0.03, 0.03 ...
                  ; 0.03, 0.03, 0.03, 0.03, 0.44, 0.44];
  end
  em2 = em1;
  [seq1, seq2, states1, states2] = hmmgenerate2d(seq_length, tr1, tr2, em1, em2);
  %display comparison of results
  [~, ~, gt_s] = forward_backward2d(tr1, tr2, em1, em2, seq1, seq2);
  gt_logL = sum(log(gt_s));
end
