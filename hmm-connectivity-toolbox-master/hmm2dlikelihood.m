function L = hmm2dlikelihood(tr1, tr2, e1, e2, seq1, seq2)
  %builds up log-likelihood by calculating probability of each state at each
  %time slice starting at t=1, and from there calculating likelihood of
  %emissions. Assumes uniform distribution of starting states.
  %(maybe should do something based on transition probabilities?)
  num_states1 = size(e1, 1);
  num_states2 = size(e2, 1);  

  likelihood = 0;
  
  %assume uniform starting distribution
  p_states1 = zeros(num_states1, 1) + 1/num_states1;
  p_states2 = zeros(num_states2, 1) + 1/num_states2;

  for t=1:length(seq1)
    likelihood = likelihood + log(emissionsLikelihood(e1, e2, p_states1, p_states2, ...
                                                  seq1(t), seq2(t)));
    p_states1 = transition(tr1, p_states1, p_states2);
    p_states2 = transition(tr2, p_states2, p_states1);   
  end
  L = likelihood;
end


function e_l = emissionsLikelihood(e1, e2, p_states1, p_states2, emsn1, emsn2)
  %given emission matrices, the probability of each state for each hmm, and the
  %observations, outputs the likelihood of those observations
  e_l = sum(e1(:, emsn1) .* p_states1);
  e_l = e_l*sum(e2(:, emsn2) .* p_states2);
end

function new_p_states = transition(tr, p_states, neighbor_p_states)
  %tr(I,J,K) is the probability of transitioning from state I to J given
  %neighbor in state K.
  new_p_states = zeros(size(p_states));
  combined_state_ps = p_states*neighbor_p_states';
  for j=1:size(new_p_states, 1)
      new_p_states(j) = sum(sum(squeeze(tr(:,j,:)) .* combined_state_ps));
      %for N states in our hmm and M states in the neighbor, squeeze(tr(:,J,:))
      %gives us an NXM matrix describing the probability of transitioning into
      %state J from states (n,m). states_ps gives the probability of currently
      %being in sates (n,m). Summing over peicewise multiplication thus gives
      %us the total probability of ending up in state J.
  end
  new_p_states;
  new_p_states = new_p_states / sum(new_p_states);
end
