%given a 2d hmm model, converts it into a vector representation and returns a
%map specifying the original dimensionality

function [vec, dims] = vectorize2Dhmm(t, em)
  states = size(t, 1); 
  neighbor_states = size(t, 3);
  emissions = max(size(em));
  dims = containers.Map({'states', 'neighbor_states', 'emissions'}, ...
                        {states, neighbor_states, emissions});
  vec = [reshape(t(:,1:size(t,2)-1,:), [], 1); reshape(em(:,1:size(em,2)-1), [], 1)];
  
