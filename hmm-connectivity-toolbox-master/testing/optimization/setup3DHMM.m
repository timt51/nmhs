function [tr1, tr2, tr3, em1, em2, em3, seq1, seq2, seq3 gt_logL] = setup3DHMM(tr1_name, tr2_name, tr3_name, seq_length, negative)
  states = 2;
  tr1 = archetypeLookup3D(tr1_name, states);
  tr2 = archetypeLookup3D(tr2_name, states);
  tr3 = archetypeLookup3D(tr3_name, states);
  if negative
     for j=2:states
         for i=2:states
           tr1(:,:,j,i) = tr1(:,:,1,1);
           tr2(:,:,j,i) = tr2(:,:,1,1);
           tr3(:,:,j,i) = tr3(:,:,1,1);
         end
     end
  end
  em1 = [0.45, 0.45, 0.05, 0.05; 0.05, 0.05, 0.45, 0.45];
  em2 = em1;
  em3 = em1;
  [seq1, seq2, seq3, states1, states2, states3] = hmmgenerate3d(seq_length, tr1, tr2, tr3, em1, em2, em3);
  %display comparison of results
  [~, ~, gt_s] = forward_backward3d(tr1, tr2, tr3, em1, em2, em3, seq1, seq2, seq3);
  gt_logL = sum(log(gt_s));
end
