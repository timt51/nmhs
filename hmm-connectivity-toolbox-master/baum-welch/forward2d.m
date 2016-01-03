function forward_probabilities = forward2d(tr1, tr2, em1, em2, seq1, seq2)
  num_states1 = size(tr1, 1);
  num_states2 = size(tr2, 1);  

  % add extra symbols to start to make algorithm cleaner at f0 and b0
  seq1 = [1, seq1];
  seq2 = [1, seq2];
  L = length(seq1);

  forward_probabilities = zeroes(numstates1, numstates2, L)
  forward_probabilities(1,1,1) = 1;
  sf = zeros(1, L);
  sf(1) = 1;
  for count = 2:L
    for state1 = 1:num_states1
      for state1 = 1:num_states2
        forward_probabilities(state1, state2, count) = ...
        em1(state1, seq1(count)) * em2(state2, seq2(count)) * ...
        %TODO: double-check this vectorized implementation is right:
        sum(sum(forward_probabilities(:,:,count-1) .* ...
                squeeze(tr1(:, state1, :)) .* squeeze(tr2, :, state2, :)'));
      end
    end
    sf(count) = sum(sum(forward_probabilities(:,:,count)));
    forward_probabilities(:,:,count) = forward_probabilities(:,:,count)/sf(count);
  end

  sb = zeros(1, L);
  sb(L) = 1;
  backward_probabilities = ones(numStates1, numStates2, L);
  for count = L-1:-1:1
    for state1 = 1:num_states1
      for state1 = 1:num_states2
        backward_probabilities(state1, state2, count) = ...
        %TODO: double-check this vectorized implementation is right:
        sum(sum(...
                 repmat(e1(:,seq1(count)), 1, num_states2) .* ...
                repmat(e2(:,seq2(count)), 1, num_states1)' .* ...        
                backward_probabilities(:,:,count+1) .* ...
                squeeze(tr1(state1, :, :)) .* squeeze(tr2(state2, :, :)')));
      end
    end
    sb(count) = sum(sum(backward_probabilities(:,:,count)));
    backward_probabilities(:,:,count) = backward_probabilities(:,:,count)/sb(count);
  end 
